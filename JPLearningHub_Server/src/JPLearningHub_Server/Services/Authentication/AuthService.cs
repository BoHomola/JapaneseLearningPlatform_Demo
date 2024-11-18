using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Services.Base;
using JPLearningHub_Server.Services.Persistance.Abstract;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace JPLearningHub_Server.Services.Authentication
{
    public class AuthService : IAuthService
    {
        private readonly IAuthProvider authProvider;

        public AuthService(IAuthProvider authProvider)
        {
            this.authProvider = authProvider;
        }

        public async Task<Result<Token>> Authenticate(string email, string password)
        {
            var authRecord = await authProvider.GetAuthAsync(email);
            if (authRecord == null)
            {
                return new Result<Token>("Invalid email or password.");
            }

            if (authRecord.PasswordHash != PasswordHelper.HashPassword(password, authRecord.Salt))
            {
                return new Result<Token>("Invalid email or password.");
            }

            return new Result<Token>(new Token()
            {
                AuthorizationToken = GenerateToken(authRecord),
                Expires = DateTime.Now.AddDays(1)
            });
        }

        public async Task<Result<Guid>> Register(string email, string password)
        {

            var authRecord = await authProvider.GetAuthAsync(email);
            if (authRecord != null)
            {
                return new Result<Guid>("User already exists.");
            }

            string salt = PasswordHelper.CreateSalt();
            string passwordHash = PasswordHelper.HashPassword(password, salt);
            Guid userId = Guid.NewGuid();

            authRecord = new Auth
            {
                Email = email,
                Salt = salt,
                PasswordHash = passwordHash,
                UserId = userId.ToString(),
                Roles = new string[] { AuthRole.Student }
            };

            try
            {
                await authProvider.AddAuthAsync(authRecord);
            }
            catch (DbUpdateException ex)
            {
                return new Result<Guid>(ex.Message);
            }

            return new Result<Guid>(userId);
        }


        public string GenerateToken(Auth auth)
        {
            var handler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes("6574d854c464ed69b0e13c0f7734d3b51779429a1b08e6f8b480f0da4a7ef8b0");
            var credentials = new SigningCredentials(
                new SymmetricSecurityKey(key),
                SecurityAlgorithms.HmacSha256Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = GenerateClaims(auth),
                Expires = DateTime.Now.AddDays(1),
                SigningCredentials = credentials,
            };

            var token = handler.CreateToken(tokenDescriptor);
            return handler.WriteToken(token);
        }

        private static ClaimsIdentity GenerateClaims(Auth auth)
        {
            var claims = new ClaimsIdentity();
            claims.AddClaim(new Claim(ClaimTypes.Email, auth.Email));
            claims.AddClaim(new Claim(ClaimTypes.NameIdentifier, auth.UserId.ToString()));

            foreach (var role in auth.Roles)
                claims.AddClaim(new Claim(ClaimTypes.Role, role));

            return claims;
        }
    }

    public static class AuthRole
    {
        public const string Student = "student";
        public const string Teacher = "teacher";
    }
}
