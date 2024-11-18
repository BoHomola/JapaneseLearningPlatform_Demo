using System.Security.Claims;
using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Helpers;
using JPLearningHub_Server.Models;
using JPLearningHub_Server.Services.Persistance.Context;
using JPLearningHub_Server.Services.Storage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Controllers
{
    [ApiController]
    [Route("api/")]
    public class LessonController(SharedDBContext dBContext, IStorageService storageService) : ControllerBase
    {
        private readonly SharedDBContext dBContext = dBContext;
        private readonly IStorageService storageService = storageService;

        [HttpGet("lessons")]
        [Authorize]
        public async Task<ActionResult> GetLessons(
            [FromQuery] DateTime? startDate = null,
            [FromQuery] DateTime? endDate = null)
        {
            startDate ??= DateTime.UtcNow;
            endDate ??= startDate.Value.AddDays(90);

            string userId = User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
            if (userId == null)
            {
                return Unauthorized();
            }

            List<LessonBooking> lessons = await dBContext.LessonBookings
                .Where(x => x.Participants.Select(y => y.UserId).Contains(userId))
                .Where(x => x.StartDate >= startDate && x.StartDate <= endDate)
                .Include(x => x.Participants).Include(lessonBooking => lessonBooking.Teacher)
                .ToListAsync();

            List<LessonBookingMessage> lessonResponse = [];
            foreach (LessonBooking? lesson in lessons)
            {
                LessonBookingMessage lessonMessage = new()
                {
                    Teacher = UserModel.FromUser(lesson.Teacher, storageService.GeneratePreSignedURL(lesson.Teacher.AvatarKey, TimeSpan.FromMinutes(5))),
                    Students = lesson.Participants
                    .Where(x => x.UserId != lesson.TeacherId)
                    .Select(x => UserModel.FromUser(x, storageService.GeneratePreSignedURL(x.AvatarKey, TimeSpan.FromMinutes(5))))
                    .ToArray(),
                    StartDate = lesson.StartDate,
                    EndDate = lesson.EndDate,
                    LessonMessage = lesson.LessonMessage
                };
                lessonResponse.Add(lessonMessage);
            }

            lessonResponse.Sort((x, y) => x.StartDate.CompareTo(y.StartDate));

            return Ok(lessonResponse);
        }
        [HttpGet("timeslots")]
        [Authorize]
        public async Task<ActionResult> GetTimeslots([FromQuery] DateTime? startDate = null, [FromQuery] DateTime? endDate = null, [FromQuery] string? teacherId = null)
        {
            startDate ??= DateTime.UtcNow.Date;
            endDate ??= startDate.Value.AddDays(1);

            Console.WriteLine(startDate.Value.ToString("o"));

            Console.WriteLine("startDate: " + startDate.Value);
            Console.WriteLine("endDate: " + endDate);

            Teacher? teacher = teacherId != null
                ? await dBContext.Teachers
                    .Include(x => x.LessonBookings)
                    .Include(x => x.TeachingHours.Where(x => x.EndDate > DateTime.UtcNow))
                    .FirstOrDefaultAsync(x => x.UserId == teacherId)
                : await dBContext.Teachers
                    .Include(x => x.LessonBookings)
                    .Include(x => x.TeachingHours.Where(x => x.EndDate > DateTime.UtcNow))
                    .FirstOrDefaultAsync();

            if (teacher == null)
            {
                return NotFound();
            }

            List<ITimeBlock> timeBlocks = [];
            timeBlocks.AddRange(teacher.LessonBookings.Where(x =>
                        (x.EndDate >= startDate && x.EndDate <= endDate)
                        || (x.StartDate >= startDate && x.StartDate <= endDate)
                    || (x.StartDate <= startDate && x.EndDate >= endDate))
                    .Select(x => x.RoundToHalf()));
            timeBlocks.AddRange(teacher.GetNonTeachingHours(startDate.Value, endDate.Value));

            DateTime minimumNoticeTime = DateTime.UtcNow.AddMinutes(teacher.MinimumBookingNoticeMinutes);
            if (minimumNoticeTime >= startDate)
            {
                timeBlocks.Add(new TimeBlock()
                {
                    StartDate = startDate.Value,
                    EndDate = minimumNoticeTime
                }.RoundToHalf());
            }

            List<ITimeBlock> mergedBlocks = TimeBlockMerger.MergeTimeBlocks(timeBlocks);


            //trim
            mergedBlocks.Where(x => x.StartDate < startDate).ToList().ForEach(x => x.StartDate = startDate.Value);
            mergedBlocks.Where(x => x.EndDate > endDate).ToList().ForEach(x => x.EndDate = endDate.Value);


            TimeslotsModel model = new()
            {
                UnavailableTimeslots = mergedBlocks.Select(x => new TimeslotModel
                {
                    From = x.StartDate,
                    To = x.EndDate
                }).ToArray()
            };

            return Ok(model);
        }

        [HttpPost("book")]
        [Authorize]
        public async Task<ActionResult> BookLesson([FromBody] List<BookingRequestModel> request)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
            if (userId == null)
            {
                return Unauthorized();
            }

            Teacher? teacher = await dBContext.Teachers
                .Include(x => x.LessonBookings)
                .Include(x => x.TeachingHours.Where(x => x.EndDate > DateTime.UtcNow))
                .FirstOrDefaultAsync(x => x.UserId == request.First().TeacherId);

            if (teacher == null)
            {
                Console.WriteLine("Teacher not found");
                return NotFound();
            }

            Student? student = await dBContext.Students
                .Include(x => x.LessonBookings)
                .FirstOrDefaultAsync(x => x.UserId == userId);

            if (student == null)
            {
                Console.WriteLine("Student not found");
                return NotFound();
            }

            if (request.Count == 0)
            {
                return BadRequest();
            }

            request.Sort((x, y) => x.StartDate.CompareTo(y.StartDate));

            List<ITimeBlock> timeBlocks = [];
            timeBlocks.AddRange(teacher.LessonBookings.Select(x => x.RoundToHalf()));
            timeBlocks.AddRange(student.LessonBookings.Select(x => x.RoundToHalf()));
            timeBlocks.AddRange(teacher.GetNonTeachingHours(request.First().StartDate, request.Last().EndDate));
            timeBlocks.Add(new TimeBlock()
            {
                StartDate = DateTime.UtcNow.AddDays(-1).Date,
                EndDate = DateTime.UtcNow.AddMinutes(teacher.MinimumBookingNoticeMinutes)
            }.RoundToHalf());

            List<ITimeBlock> unavailableTimeBlocks = TimeBlockMerger.MergeTimeBlocks(timeBlocks);

            List<int> rejectedIndexes = [];

            foreach (BookingRequestModel bookingRequest in request)
            {
                TimeBlock timeBlock = new()
                {
                    StartDate = bookingRequest.StartDate,
                    EndDate = bookingRequest.EndDate
                };

                if (timeBlock.Overlaps(unavailableTimeBlocks))
                {
                    rejectedIndexes.Add(request.IndexOf(bookingRequest));
                    continue;
                }

                dBContext.LessonBookings.Add(new LessonBooking
                {
                    LessonId = Guid.NewGuid().ToString(),
                    Teacher = teacher,
                    Participants = [teacher, student],
                    StartDate = bookingRequest.StartDate,
                    EndDate = bookingRequest.EndDate,
                    LessonMessage = bookingRequest.LessonMessage ?? ""
                });
            };

            if (rejectedIndexes.Count > 0)
            {
                return BadRequest(rejectedIndexes);
            }
            else
            {
                await dBContext.SaveChangesAsync();
                return Ok();
            }
        }
    }
}
