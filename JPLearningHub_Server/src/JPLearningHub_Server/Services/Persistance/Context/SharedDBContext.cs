using JPLearningHub_Server.Entities;
using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Services.Persistance.Context;

public class SharedDBContext : DbContext
{
    public SharedDBContext(DbContextOptions<SharedDBContext> options) : base(options)
    {
        Auths = Set<Auth>();
        Users = Set<User>();
        LessonBookings = Set<LessonBooking>();
        Teachers = Set<Teacher>();
        Students = Set<Student>();
    }

    public DbSet<Auth> Auths { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<LessonBooking> LessonBookings { get; set; }
    public DbSet<Teacher> Teachers { get; set; }
    public DbSet<Student> Students { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.DefineAuthEntity();
        modelBuilder.DefineUserEntity();
        modelBuilder.DefineTeacherEntity();
        modelBuilder.DefineStudentEntity();
        modelBuilder.DefineLessonBookingEntity();
    }
}