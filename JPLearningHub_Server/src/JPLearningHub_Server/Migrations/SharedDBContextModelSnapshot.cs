﻿// <auto-generated />
using System;
using JPLearningHub_Server.Services.Persistance.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace JPLearningHub_Server.Migrations
{
    [DbContext(typeof(SharedDBContext))]
    partial class SharedDBContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.6")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("JPLearningHub_Server.Entities.Auth", b =>
                {
                    b.Property<string>("Email")
                        .HasColumnType("text")
                        .HasColumnName("email");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("password_hash");

                    b.Property<string[]>("Roles")
                        .IsRequired()
                        .HasColumnType("text[]")
                        .HasColumnName("roles");

                    b.Property<string>("Salt")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("salt");

                    b.Property<string>("UserId")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("user_id");

                    b.HasKey("Email")
                        .HasName("email");

                    b.ToTable("auth", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.LessonBooking", b =>
                {
                    b.Property<string>("LessonId")
                        .HasColumnType("text");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("end_date");

                    b.Property<string>("LessonMessage")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("lesson_message");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("start_date");

                    b.Property<string>("TeacherId")
                        .IsRequired()
                        .HasColumnType("text");

                    b.Property<string>("TeacherPrivateMessage")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("teacher_private_message");

                    b.HasKey("LessonId")
                        .HasName("lesson_id");

                    b.HasIndex("TeacherId");

                    b.ToTable("lesson_booking", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.TeachingHours", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("id");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("Id"));

                    b.Property<DateTime>("EffectiveDate")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("effective_date");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("timestamp with time zone");

                    b.Property<byte>("FromHour")
                        .HasColumnType("smallint")
                        .HasColumnName("from_hour");

                    b.Property<byte>("FromMinute")
                        .HasColumnType("smallint")
                        .HasColumnName("from_minute");

                    b.Property<string>("TeacherUserId")
                        .HasColumnType("text");

                    b.Property<byte>("ToHour")
                        .HasColumnType("smallint")
                        .HasColumnName("to_hour");

                    b.Property<byte>("ToMinute")
                        .HasColumnType("smallint")
                        .HasColumnName("to_minute");

                    b.HasKey("Id")
                        .HasName("id");

                    b.HasIndex("TeacherUserId");

                    b.ToTable("teaching_hours", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.User", b =>
                {
                    b.Property<string>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("text")
                        .HasColumnName("user_id");

                    b.Property<string>("AvatarKey")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("avatar_key");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("first_name");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("last_name");

                    b.Property<string>("TimeZone")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("time_zone");

                    b.Property<string>("UserType")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("user_type");

                    b.HasKey("UserId");

                    b.ToTable("user", (string)null);

                    b.UseTptMappingStrategy();
                });

            modelBuilder.Entity("LessonBookingUser", b =>
                {
                    b.Property<string>("LessonBookingsLessonId")
                        .HasColumnType("text");

                    b.Property<string>("ParticipantsUserId")
                        .HasColumnType("text");

                    b.HasKey("LessonBookingsLessonId", "ParticipantsUserId");

                    b.HasIndex("ParticipantsUserId");

                    b.ToTable("lesson_participants", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.Student", b =>
                {
                    b.HasBaseType("JPLearningHub_Server.Entities.User");

                    b.Property<long>("Credits")
                        .HasColumnType("bigint")
                        .HasColumnName("credits");

                    b.ToTable("student", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.Teacher", b =>
                {
                    b.HasBaseType("JPLearningHub_Server.Entities.User");

                    b.Property<int>("MinimumBookingNoticeMinutes")
                        .HasColumnType("integer")
                        .HasColumnName("minimum_booking_notice_minutes");

                    b.ToTable("teacher", (string)null);
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.LessonBooking", b =>
                {
                    b.HasOne("JPLearningHub_Server.Entities.Teacher", "Teacher")
                        .WithMany()
                        .HasForeignKey("TeacherId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Teacher");
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.TeachingHours", b =>
                {
                    b.HasOne("JPLearningHub_Server.Entities.Teacher", null)
                        .WithMany("TeachingHours")
                        .HasForeignKey("TeacherUserId");
                });

            modelBuilder.Entity("LessonBookingUser", b =>
                {
                    b.HasOne("JPLearningHub_Server.Entities.LessonBooking", null)
                        .WithMany()
                        .HasForeignKey("LessonBookingsLessonId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("JPLearningHub_Server.Entities.User", null)
                        .WithMany()
                        .HasForeignKey("ParticipantsUserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.Student", b =>
                {
                    b.HasOne("JPLearningHub_Server.Entities.User", null)
                        .WithOne()
                        .HasForeignKey("JPLearningHub_Server.Entities.Student", "UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.Teacher", b =>
                {
                    b.HasOne("JPLearningHub_Server.Entities.User", null)
                        .WithOne()
                        .HasForeignKey("JPLearningHub_Server.Entities.Teacher", "UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("JPLearningHub_Server.Entities.Teacher", b =>
                {
                    b.Navigation("TeachingHours");
                });
#pragma warning restore 612, 618
        }
    }
}
