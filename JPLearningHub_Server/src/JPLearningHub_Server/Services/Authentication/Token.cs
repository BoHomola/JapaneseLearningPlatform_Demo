
namespace JPLearningHub_Server.Services.Authentication;
public record Token
{
    public string AuthorizationToken { get; set; } = string.Empty;
    public DateTime Expires { get; set; }
}
