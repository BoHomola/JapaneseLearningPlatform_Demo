using JPLearningHub_Server.Entities;

namespace JPLearningHub_Server.Models
{
    public class StudentModel
    {
        public UserModel User { get; set; } = new();
        public long Credits { get; set; }

        public static StudentModel FromStudent(Student student, string avatarUrl)
        {
            return new StudentModel
            {
                User = UserModel.FromUser(student, avatarUrl),
                Credits = student.Credits
            };
        }
    }
}
