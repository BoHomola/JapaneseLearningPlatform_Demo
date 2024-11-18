using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Entities
{
    public class Student : User
    {
        public long Credits { get; set; } = 0;
    }

    public static class StudentStudentExtension
    {
        public static void DefineStudentEntity(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Student>(entity =>
            {

                entity.ToTable("student");

                entity.HasBaseType<User>();

                entity.Property(x => x.Credits)
                .HasColumnName("credits");
            });
        }
    }
}
