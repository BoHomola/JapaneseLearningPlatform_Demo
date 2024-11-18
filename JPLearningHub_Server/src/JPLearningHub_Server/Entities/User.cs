using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Entities
{
    public enum UserTypeEnum
    {
        Student = 0,
        Teacher = 1,
        Unknown = 2
    }

    public class UserTypeConverter
    {

        public static string ConvertToString(UserTypeEnum userType)
        {
            return userType switch
            {
                UserTypeEnum.Student => "Student",
                UserTypeEnum.Teacher => "Teacher",
                _ => "Unknown",
            };
        }

        public static UserTypeEnum ConvertToEnum(string userType)
        {
            return userType switch
            {
                "Student" => UserTypeEnum.Student,
                "Teacher" => UserTypeEnum.Teacher,
                _ => UserTypeEnum.Unknown,
            };
        }
    }


    public class User
    {
        public string UserId { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string AvatarKey { get; set; } = string.Empty;
        public string UserType { get; set; } = string.Empty;
        public string TimeZone { get; set; } = string.Empty;
        public virtual List<LessonBooking> LessonBookings { get; set; } = new();
    }

    public static class UserEntityExtension
    {
        public static void DefineUserEntity(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("user");

                entity.HasKey(e => e.UserId);

                entity.Property(e => e.UserId)
                      .ValueGeneratedOnAdd()
                      .HasColumnName("user_id");

                entity.Property(e => e.FirstName)
                      .IsRequired()
                      .HasColumnName("first_name");

                entity.Property(e => e.LastName)
                      .IsRequired()
                      .HasColumnName("last_name");

                entity.Property(e => e.AvatarKey)
                      .IsRequired()
                      .HasColumnName("avatar_key");

                entity.Property(e => e.UserType)
                      .IsRequired()
                      .HasColumnName("user_type");

                entity.Property(e => e.TimeZone)
                      .IsRequired()
                      .HasColumnName("time_zone");
            });
        }
    }
}
