using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Services.Authentication;
using JPLearningHub_Server.Services.Persistance.Context;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace JPLearningHub_Server.Services.Persistance.Seeder
{
    public class Seeder(SharedDBContext context) : ISeeder
    {
        private readonly SharedDBContext context = context;

        public void DropDB()
        {
            _ = context.Database.EnsureDeleted();
        }

        public void SeedData()
        {
            string studentId = "ab2c534e-8053-49eb-9c17-1e04d8d435ab";
            string teacherId = "107aab44-c19d-4ad7-bf14-e90121ff7ca8";

            EntityEntry<Teacher> teacher;
            EntityEntry<Student> student;
            // Create Student
            {
                string salt = PasswordHelper.CreateSalt();
                string hashedPass = PasswordHelper.HashPassword("bo", salt);
                _ = context.Auths.Add(new Auth
                {
                    Email = "bo",
                    PasswordHash = hashedPass,
                    Salt = salt,
                    UserId = studentId,
                    Roles = [AuthRole.Student]
                });
                student = context.Students.Add(new Student
                {
                    UserId = studentId.ToString(),
                    FirstName = "Bohumil",
                    LastName = "Homola",
                    TimeZone = "Europe/Prague",
                    Credits = 15000,
                    AvatarKey = "avatars/bf8b274c-81e4-4489-8d2f-b9d166be692b.jpg",
                    UserType = UserTypeConverter.ConvertToString(UserTypeEnum.Student)
                });
                Console.WriteLine("Added student: " + studentId);
            }

            // Create Teacher
            {
                string salt = PasswordHelper.CreateSalt();
                string hashedPass = PasswordHelper.HashPassword("sh", salt);
                _ = context.Auths.Add(new Auth
                {
                    Email = "sh",
                    PasswordHash = hashedPass,
                    Salt = salt,
                    UserId = teacherId,
                    Roles = [AuthRole.Teacher]
                });
                teacher = context.Teachers.Add(new Teacher
                {
                    UserId = teacherId.ToString(),
                    FirstName = "Shiori",
                    LastName = "Kagaya",
                    AvatarKey = "avatars/4efb20bf-da43-4f9e-bc58-003a17cdf9d5.jpg",
                    TimeZone = "Asia/Tokyo",
                    MinimumBookingNoticeMinutes = 24 * 60,
                    TeachingHours =
                    [
                        new TeachingHours
                    {
                        FromHour = 21,
                        ToHour = 14,
                        EffectiveDate = DateTime.UtcNow,
                        EndDate = DateTime.MaxValue
                    }
                    ],
                    UserType = UserTypeConverter.ConvertToString(UserTypeEnum.Teacher)
                });
                Console.WriteLine("Added teacher: " + teacherId);
            }

            _ = context.LessonBookings.Add(new LessonBooking
            {
                LessonId = Guid.NewGuid().ToString(),  // Generate a new Guid here
                Teacher = teacher.Entity,
                StartDate = DateTime.UtcNow.Add(TimeSpan.FromHours(1)).RoundUp(),
                EndDate = DateTime.UtcNow.Add(TimeSpan.FromHours(1.5)).RoundUp(),
                LessonMessage = "Practicing N3 words.",
                Participants = [teacher.Entity, student.Entity]
            });
            _ = context.LessonBookings.Add(new LessonBooking
            {
                LessonId = Guid.NewGuid().ToString(),  // Generate a new Guid here
                Teacher = teacher.Entity,
                StartDate = DateTime.UtcNow.Add(TimeSpan.FromHours(2)).RoundUp(),
                EndDate = DateTime.UtcNow.Add(TimeSpan.FromHours(2.5)).RoundUp(),
                LessonMessage = "Praciting intonation",
                Participants = [teacher.Entity, student.Entity]
            });
            _ = context.LessonBookings.Add(new LessonBooking
            {
                LessonId = Guid.NewGuid().ToString(),  // Generate a new Guid here
                Teacher = teacher.Entity,
                StartDate = DateTime.UtcNow.Add(TimeSpan.FromHours(27)).RoundUp(),
                EndDate = DateTime.UtcNow.Add(TimeSpan.FromHours(28)).RoundUp(),
                LessonMessage = "Perfecting grammar",
                Participants = [teacher.Entity, student.Entity]
            });
            _ = context.LessonBookings.Add(new LessonBooking
            {
                LessonId = Guid.NewGuid().ToString(),  // Generate a new Guid here
                Teacher = teacher.Entity,
                StartDate = DateTime.UtcNow.Add(TimeSpan.FromHours(138)).RoundUp(),
                EndDate = DateTime.UtcNow.Add(TimeSpan.FromHours(139)).RoundUp(),
                LessonMessage = "Finalizing the lesson.",
                Participants = [teacher.Entity, student.Entity]
            });

            Console.WriteLine(DateTime.UtcNow);

            _ = context.SaveChanges();
        }
    }
}
