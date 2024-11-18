using JPLearningHub_Server.Entities;

namespace JPLearningHub_Server.Models
{
    public class LessonBookingMessage
    {
        public UserModel Teacher { get; set; } = new();
        public UserModel[] Students { get; set; } = [];
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string LessonMessage { get; set; } = string.Empty;
    }

    public class TeachingHoursModel
    {
        public byte FromHour { get; set; }
        public byte FromMinute { get; set; }
        public byte ToHour { get; set; }
        public byte ToMinute { get; set; }
        public DateTime EffectiveDate { get; set; }
        public DateTime EndDate { get; set; }

        public static TeachingHoursModel FromEntity(TeachingHours entity)
        {
            return new TeachingHoursModel
            {
                FromHour = entity.FromHour,
                FromMinute = entity.FromMinute,
                ToHour = entity.ToHour,
                ToMinute = entity.ToMinute,
                EffectiveDate = entity.EffectiveDate,
                EndDate = entity.EndDate
            };
        }
    }

    public class TimeslotModel
    {
        public DateTime From { get; set; }
        public DateTime To { get; set; }
    }

    public class TimeslotsModel
    {
        public TimeslotModel[] UnavailableTimeslots { get; set; } = [];
    }

    public enum LessonLength
    {
        ShortLesson,
        LongLesson
    }

    public class BookingRequestModel
    {
        public int BookingIndex { get; set; }
        public DateTime StartDate { get; set; }
        public LessonLength LessonLength { get; set; }
        public required string TeacherId { get; set; }
        public string? LessonMessage { get; set; }
        public DateTime EndDate => StartDate.AddMinutes(LessonLength == LessonLength.ShortLesson ? 30 : 60);
    }
}
