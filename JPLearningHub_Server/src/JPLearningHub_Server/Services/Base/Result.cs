namespace JPLearningHub_Server.Services.Base
{
    public class Result
    {
        public Result()
        {
            Success = true;
	    ErrorMessage = string.Empty;
        }

        public Result(string errorMessage)
        {
            Success = false;
            ErrorMessage = errorMessage;
        }

        public bool Success { get; private set; }
        public string ErrorMessage { get; private set; }
    }

    public class Result<T> : Result where T : new()
    {
        public Result(string errorMessage) : base(errorMessage)
        {
            Data = new T();
        }

        public Result(T data) : base()
        {
            Data = data;
        }

        public T Data { get; private set; }
    }
}
