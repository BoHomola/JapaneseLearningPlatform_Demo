using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace JPLearningHub_Server.Migrations
{
    /// <inheritdoc />
    public partial class ForceReset : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "auth",
                columns: table => new
                {
                    email = table.Column<string>(type: "text", nullable: false),
                    password_hash = table.Column<string>(type: "text", nullable: false),
                    salt = table.Column<string>(type: "text", nullable: false),
                    roles = table.Column<string[]>(type: "text[]", nullable: false),
                    user_id = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("email", x => x.email);
                });

            migrationBuilder.CreateTable(
                name: "user",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "text", nullable: false),
                    first_name = table.Column<string>(type: "text", nullable: false),
                    last_name = table.Column<string>(type: "text", nullable: false),
                    avatar_key = table.Column<string>(type: "text", nullable: false),
                    user_type = table.Column<string>(type: "text", nullable: false),
                    time_zone = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user", x => x.user_id);
                });

            migrationBuilder.CreateTable(
                name: "student",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "text", nullable: false),
                    credits = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_student", x => x.user_id);
                    table.ForeignKey(
                        name: "FK_student_user_user_id",
                        column: x => x.user_id,
                        principalTable: "user",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "teacher",
                columns: table => new
                {
                    user_id = table.Column<string>(type: "text", nullable: false),
                    minimum_booking_notice_minutes = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_teacher", x => x.user_id);
                    table.ForeignKey(
                        name: "FK_teacher_user_user_id",
                        column: x => x.user_id,
                        principalTable: "user",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "lesson_booking",
                columns: table => new
                {
                    LessonId = table.Column<string>(type: "text", nullable: false),
                    TeacherId = table.Column<string>(type: "text", nullable: false),
                    start_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    end_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    lesson_message = table.Column<string>(type: "text", nullable: false),
                    teacher_private_message = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("lesson_id", x => x.LessonId);
                    table.ForeignKey(
                        name: "FK_lesson_booking_teacher_TeacherId",
                        column: x => x.TeacherId,
                        principalTable: "teacher",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "teaching_hours",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    from_hour = table.Column<byte>(type: "smallint", nullable: false),
                    from_minute = table.Column<byte>(type: "smallint", nullable: false),
                    to_hour = table.Column<byte>(type: "smallint", nullable: false),
                    to_minute = table.Column<byte>(type: "smallint", nullable: false),
                    effective_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    EndDate = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    TeacherUserId = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("id", x => x.id);
                    table.ForeignKey(
                        name: "FK_teaching_hours_teacher_TeacherUserId",
                        column: x => x.TeacherUserId,
                        principalTable: "teacher",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "lesson_participants",
                columns: table => new
                {
                    LessonBookingsLessonId = table.Column<string>(type: "text", nullable: false),
                    ParticipantsUserId = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_lesson_participants", x => new { x.LessonBookingsLessonId, x.ParticipantsUserId });
                    table.ForeignKey(
                        name: "FK_lesson_participants_lesson_booking_LessonBookingsLessonId",
                        column: x => x.LessonBookingsLessonId,
                        principalTable: "lesson_booking",
                        principalColumn: "LessonId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_lesson_participants_user_ParticipantsUserId",
                        column: x => x.ParticipantsUserId,
                        principalTable: "user",
                        principalColumn: "user_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_lesson_booking_TeacherId",
                table: "lesson_booking",
                column: "TeacherId");

            migrationBuilder.CreateIndex(
                name: "IX_lesson_participants_ParticipantsUserId",
                table: "lesson_participants",
                column: "ParticipantsUserId");

            migrationBuilder.CreateIndex(
                name: "IX_teaching_hours_TeacherUserId",
                table: "teaching_hours",
                column: "TeacherUserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "auth");

            migrationBuilder.DropTable(
                name: "lesson_participants");

            migrationBuilder.DropTable(
                name: "student");

            migrationBuilder.DropTable(
                name: "teaching_hours");

            migrationBuilder.DropTable(
                name: "lesson_booking");

            migrationBuilder.DropTable(
                name: "teacher");

            migrationBuilder.DropTable(
                name: "user");
        }
    }
}
