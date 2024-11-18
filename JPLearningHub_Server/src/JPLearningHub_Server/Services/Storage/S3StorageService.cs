using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;

namespace JPLearningHub_Server.Services.Storage
{
    public class S3StorageService : IStorageService, IDisposable
    {
        private readonly AmazonS3Client s3Client;
        private readonly string bucketName;

        public S3StorageService()
        {
            string accessKey = Environment.GetEnvironmentVariable("S3_ACCESS_KEY")!;
            string secretKey = Environment.GetEnvironmentVariable("S3_SECRET_KEY")!;
            string serviceUrl = Environment.GetEnvironmentVariable("S3_SERVICE_URL")!;
            bucketName = Environment.GetEnvironmentVariable("S3_BUCKET_NAME")!;

            AmazonS3Config config = new()
            {
                ServiceURL = serviceUrl,
                ForcePathStyle = true
            };

            s3Client = new AmazonS3Client(accessKey, secretKey, config);
        }

        public string GeneratePreSignedURL(string objectKey, TimeSpan expiry)
        {
            GetPreSignedUrlRequest request = new()
            {
                BucketName = bucketName,
                Key = objectKey,
                Expires = DateTime.UtcNow.Add(expiry)
            };

            return s3Client.GetPreSignedURL(request);
        }

        public async Task UploadFile(IFormFile file, string objectKey)
        {
            using MemoryStream memoryStream = new();
            Console.WriteLine($"received file: {file.FileName} size: {file.Length}");
            await file.CopyToAsync(memoryStream);
            memoryStream.Position = 0;
            TransferUtilityUploadRequest uploadRequest = new()
            {
                InputStream = memoryStream,
                Key = objectKey,
                BucketName = bucketName,
                ContentType = file.ContentType
            };
            TransferUtility fileTransferUtility = new(s3Client);
            Console.WriteLine($"Uploading file: {file.FileName} to bucket: {bucketName}");
            await fileTransferUtility.UploadAsync(uploadRequest);
        }

        public void Dispose()
        {
            s3Client.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
