using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Entities
{
    public class Auth
    {
        public required string Email { get; set; } = string.Empty;
        public required string PasswordHash { get; set; } = string.Empty;
        public required string Salt { get; set; } = string.Empty;
        public required string[] Roles { get; set; }
        public string UserId { get; set; } = string.Empty;
    }

    public static class AuthEntityExtension
    {
        public static void DefineAuthEntity(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Auth>(entity =>
            {
                entity.ToTable("auth");

                entity.HasKey(e => e.Email)
                      .HasName("email");

                entity.Property(e => e.Email)
                      .IsRequired()
                      .HasColumnName("email");

                entity.Property(e => e.PasswordHash)
                      .IsRequired()
                      .HasColumnName("password_hash");

                entity.Property(e => e.Salt)
                      .IsRequired()
                      .HasColumnName("salt");

                entity.Property(e => e.Roles)
                      .IsRequired()
                      .HasColumnName("roles");

                entity.Property(e => e.UserId)
                    .HasColumnName("user_id");
            });
        }
    }
}
