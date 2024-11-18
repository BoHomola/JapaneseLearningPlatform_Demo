using System.Security.Claims;
using JPLearningHub_Server.Models;
using JPLearningHub_Server.Services.Authentication;
using JPLearningHub_Server.Services.Persistance.Context;
using JPLearningHub_Server.Services.Storage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Controllers;

[ApiController]
[Route("api/")]
public class UserController : ControllerBase
{
    private readonly IAuthService authService;
    private readonly SharedDBContext sharedContext;
    private readonly IStorageService storageService;

    public UserController(IAuthService authService, SharedDBContext sharedContext, IStorageService storageService)
    {
        this.authService = authService;
        this.sharedContext = sharedContext;
        this.storageService = storageService;
    }

    [HttpGet("test")]
    public ActionResult Test()
    {
        return Ok("Testing new deployment 4124421");
    }

    [HttpGet("user")]
    [Authorize]
    public async Task<ActionResult> GetUser()
    {
        string? userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (userId == null)
        {
            return Unauthorized();
        }

        var user = await sharedContext.Users.FirstOrDefaultAsync(x => x.UserId == userId);

        if (user == null)
        {
            return Unauthorized();
        }

        var url = storageService.GeneratePreSignedURL(user.AvatarKey, TimeSpan.FromMinutes(5));

        return Ok(UserModel.FromUser(user, url));
    }

    [HttpPost("avatar")]
    public async Task<IActionResult> UploadImage(IFormFile file)
    {
        Console.WriteLine($"received file: {file.FileName} size: {file.Length}");
        if (file == null || file.Length == 0)
        {
            return BadRequest("No file uploaded.");
        }

        // if (!file.ContentType.StartsWith("image/"))
        // {
        //     return BadRequest("Only image files are allowed.");
        // }
        //
        if (file.Length > 5 * 1024 * 1024)
        {
            return BadRequest("File size exceeds the limit of 5MB.");
        }

        try
        {
            string objectKey = $"avatars/{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await storageService.UploadFile(file, objectKey);

            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
            {
                return NotFound();
            }

            var user = await sharedContext.Users.FindAsync(Guid.Parse(userId));
            if (user == null)
            {
                return NotFound();
            }

            user.AvatarKey = objectKey;
            await sharedContext.SaveChangesAsync();


            string newUrl = storageService.GeneratePreSignedURL(objectKey, TimeSpan.FromMinutes(5));
            Console.WriteLine($"new url: {newUrl}");
            return Ok(new { newUrl });
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex);
            return StatusCode(500, $"Internal server error: {ex}");
        }
    }
}
