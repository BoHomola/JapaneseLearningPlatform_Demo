using JPLearningHub_Server.Entities;

namespace JPLearningHub_Server.Models
{
    public class UserModel
    {
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string AvatarKey { get; set; } = string.Empty;
        public string AvatarUrl { get; set; } = string.Empty;
        public string UserId { get; set; } = string.Empty;
        public string TimeZone { get; set; } = string.Empty;
        public string UserType { get; set; } = string.Empty;

        public static UserModel FromUser(User user, string avatarUrl)
        {
            return new UserModel
            {
                FirstName = user.FirstName,
                LastName = user.LastName,
                AvatarKey = user.AvatarKey,
                AvatarUrl = avatarUrl,
                UserId = user.UserId,
                TimeZone = user.TimeZone,
                UserType = user.UserType
            };
        }
    }
}
