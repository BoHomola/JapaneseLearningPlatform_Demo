namespace JPLearningHub_Server.Services.Storage
{
    public interface IStorageService
    {
        public string GeneratePreSignedURL(string objectKey, TimeSpan expiry);
        public Task UploadFile(IFormFile file, string objectKey);
    }
}
