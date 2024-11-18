using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Entities
{
    public class TeachingHours
    {
        public int Id { get; set; }
        public byte FromHour { get; set; }
        public byte FromMinute { get; set; }
        public byte ToHour { get; set; }
        public byte ToMinute { get; set; }
        public DateTime EffectiveDate { get; set; }
        public DateTime EndDate { get; set; }
    }

    public class Teacher : User
    {
        public required List<TeachingHours> TeachingHours { get; set; }
        public required int MinimumBookingNoticeMinutes { get; set; }
    }

    public static class TeacherEntityExtension
    {
        public static void DefineTeacherEntity(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Teacher>(entity =>
            {
                entity.ToTable("teacher");
                entity.HasBaseType<User>();

                entity.Property(x => x.MinimumBookingNoticeMinutes)
                    .HasColumnName("minimum_booking_notice_minutes");

                entity.HasMany(x => x.TeachingHours);
            });

            modelBuilder.Entity<TeachingHours>(entity =>
            {
                entity.ToTable("teaching_hours");

                entity.HasKey(e => e.Id)
                    .HasName("id");

                entity.Property(e => e.Id)
                    .ValueGeneratedOnAdd()
                    .HasColumnName("id");

                entity.Property(x => x.FromHour)
                    .HasColumnName("from_hour");

                entity.Property(x => x.FromMinute)
                    .HasColumnName("from_minute");

                entity.Property(x => x.ToHour)
                    .HasColumnName("to_hour");

                entity.Property(x => x.ToMinute)
                    .HasColumnName("to_minute");

                entity.Property(x => x.EffectiveDate)
                    .HasColumnName("effective_date")
                    .HasColumnType("timestamp with time zone");
            });
        }

        public static List<ITimeBlock> GetNonTeachingHours(this Teacher teacher, DateTime from, DateTime to)
        {
            TeachingHours? teachingHours = teacher.TeachingHours.FirstOrDefault();
            if (teachingHours == null)
            {
                return [];
            }

            List<ITimeBlock> timeBlocks = [];

            byte nonWorkingFrom = teachingHours.ToHour;
            byte nonWorkingFromMinute = teachingHours.ToMinute;
            byte nonWorkingTo = teachingHours.FromHour;
            byte nonWorkingToMinute = teachingHours.FromMinute;

            TimeSpan diff = to - from;

            for (int i = 0; i < diff.Days + 1; i++)
            {
                DateTime currentFrom = from.AddDays(i);
                DateTime relativeStartDate =
                    currentFrom.Date.AddHours(nonWorkingFrom).AddMinutes(nonWorkingFromMinute);
                DateTime relativeEndDate =
                    currentFrom.Date.AddHours(nonWorkingTo).AddMinutes(nonWorkingToMinute);
                if (relativeEndDate < relativeStartDate)
                {
                    relativeEndDate = relativeEndDate.AddDays(1);
                }

                var timeBlock = new TimeBlock {StartDate = relativeStartDate, EndDate = relativeEndDate};
                if (timeBlock.EndDate > from && timeBlock.StartDate < to)
                {
                    timeBlocks.Add(timeBlock);
                }
            }

            return timeBlocks;
        }
    }
}
