using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Services.Base;
using JPLearningHub_Server.Services.Persistance.Abstract;
using JPLearningHub_Server.Services.Persistance.Context;

namespace JPLearningHub_Server.Services.Persistance.Implementation
{
    public class PGAuthProvider : IAuthProvider
    {
        private SharedDBContext authContext;

        public PGAuthProvider(SharedDBContext authContext)
        {
            this.authContext = authContext;
        }

        public Task<Result> AddAuthAsync(Auth auth)
        {
            return authContext.Auths.AddAsync(auth).AsTask().ContinueWith(t => new Result());
        }

        public Task<Auth?> GetAuthAsync(string email)
        {
            return authContext.Auths.FindAsync(email).AsTask();
        }
    }
}
