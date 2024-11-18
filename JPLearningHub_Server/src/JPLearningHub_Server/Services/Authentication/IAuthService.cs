using JPLearningHub_Server.Services.Base;

namespace JPLearningHub_Server.Services.Authentication
{
    public interface IAuthService
    {
        public Task<Result<Token>> Authenticate(string email, string password);
        public Task<Result<Guid>> Register(string email, string password);
    }
}
