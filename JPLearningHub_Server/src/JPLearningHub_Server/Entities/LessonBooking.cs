using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Entities
{
    public class LessonBooking : IEvent
    {
        public string LessonId { get; set; } = string.Empty;
        public string TeacherId { get; set; } = string.Empty;
        public required Teacher Teacher { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string LessonMessage { get; set; } = string.Empty;
        public string TeacherPrivateMessage { get; set; } = string.Empty;
        public List<User> Participants { get; set; } = [];
    }

    public static class LessonBookingEntityExtension
    {
        public static void DefineLessonBookingEntity(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<LessonBooking>(entity =>
            {
                entity.ToTable("lesson_booking");

                entity.HasKey(e => e.LessonId)
                      .HasName("lesson_id");

                entity.Property(e => e.LessonMessage)
                     .HasColumnName("lesson_message");

                entity.Property(e => e.StartDate)
                      .HasColumnName("start_date")
                      .HasColumnType("timestamp with time zone");

                entity.Property(e => e.EndDate)
                      .HasColumnName("end_date")
                      .HasColumnType("timestamp with time zone");

                entity.Property(e => e.TeacherPrivateMessage)
                      .HasColumnName("teacher_private_message");

                entity.HasMany(d => d.Participants)
                      .WithMany(s => s.LessonBookings).UsingEntity(x => x.ToTable("lesson_participants"));

                entity.HasOne(e => e.Teacher);
            });
        }
    }
}
