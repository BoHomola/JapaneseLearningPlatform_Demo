using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Models;
using JPLearningHub_Server.Services.Authentication;
using JPLearningHub_Server.Services.Base;
using JPLearningHub_Server.Services.Persistance.Context;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;

namespace JPLearningHub_Server.Controllers
{
    [ApiController]
    [Route("api/")]
    public class LoginController(IAuthService authService, SharedDBContext sharedContext) : ControllerBase
    {
        private readonly IAuthService authService = authService;
        private readonly SharedDBContext sharedContext = sharedContext;

        [HttpPost("login")]
        public async Task<ActionResult> Login([FromBody] LoginRequest loginRequest)
        {
            var result = await authService.Authenticate(loginRequest.Email, loginRequest.Password);

            if (!result.Success)
            {
                return Unauthorized(result.ErrorMessage);
            }

            return Ok(new
            {
                Token = result.Data.AuthorizationToken,
                result.Data.Expires
            });
        }

        [HttpPost("register")]
        public async Task<ActionResult> Register([FromBody] RegisterRequest registerRequest)
        {

            using (IDbContextTransaction transaction = await sharedContext.Database.BeginTransactionAsync())
            {
                try
                {
                    Result<Guid> result = await authService.Register(registerRequest.Email, registerRequest.Password);
                    if (!result.Success)
                    {
                        return Forbid(result.ErrorMessage);
                    }

                    await sharedContext.Users.AddAsync(new Student()
                    {
                        UserId = result.Data.ToString(),
                        FirstName = registerRequest.FirstName,
                        LastName = registerRequest.LastName,
                        Credits = 0,
                        AvatarKey = "avatars/default.png",
                        UserType = UserTypeConverter.ConvertToString(UserTypeEnum.Student)
                    });

                    await sharedContext.SaveChangesAsync();
                    await transaction.CommitAsync();
                }
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    return Forbid(ex.Message);
                }
            }

            var authResult = await authService.Authenticate(registerRequest.Email, registerRequest.Password);

            if (!authResult.Success)
            {
                return Unauthorized();
            }

            return Ok(new
            {
                Token = authResult.Data.AuthorizationToken,
                authResult.Data.Expires
            });
        }
    }
}
