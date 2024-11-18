using JPLearningHub_Server.Entities;

namespace JPLearningHub_Server.Models
{
    public class TeacherModel
    {
        public UserModel User { get; set; } = new();

        public static TeacherModel FromTeacher(Teacher teacher, string avatarUrl)
        {
            return new TeacherModel
            {
                User = UserModel.FromUser(teacher, avatarUrl),
            };
        }
    }
}
