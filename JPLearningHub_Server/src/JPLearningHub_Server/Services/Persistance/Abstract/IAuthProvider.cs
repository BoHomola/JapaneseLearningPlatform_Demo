using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Services.Base;

namespace JPLearningHub_Server.Services.Persistance.Abstract
{
    public interface IAuthProvider
    {
        public Task<Auth?> GetAuthAsync(string email);
	public Task<Result> AddAuthAsync(Auth auth);
    }
}
