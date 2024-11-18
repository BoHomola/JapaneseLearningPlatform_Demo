using System.Security.Cryptography;

namespace JPLearningHub_Server.Services.Authentication
{
    public class PasswordHelper
    {
        public static string CreateSalt(int size = 16)
        {
            RandomNumberGenerator rng = RandomNumberGenerator.Create();
            var saltBytes = new byte[size];
            rng.GetBytes(saltBytes);
            return Convert.ToBase64String(saltBytes);
        }

        public static string HashPassword(string password, string salt, int iterations = 10000)
        {
            var pbkdf2 = new Rfc2898DeriveBytes(password, Convert.FromBase64String(salt), iterations, HashAlgorithmName.SHA256);
            var hash = pbkdf2.GetBytes(32); // 256-bit hash
            return Convert.ToBase64String(hash);
        }

        public static bool VerifyPassword(string enteredPassword, string storedHash, string storedSalt, int iterations = 10000)
        {
            var hashOfEnteredPassword = HashPassword(enteredPassword, storedSalt, iterations);
            return hashOfEnteredPassword == storedHash;
        }
    }
}
