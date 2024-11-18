using JPLearningHub_Server.Models;
using JPLearningHub_Server.Services.Authentication;
using JPLearningHub_Server.Services.Persistance.Context;
using JPLearningHub_Server.Services.Storage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Controllers
{
    [ApiController]
    [Route("api/")]
    public class StudentController(SharedDBContext sharedContext, IStorageService storageService) : ControllerBase
    {
        private readonly SharedDBContext sharedContext = sharedContext;
        private readonly IStorageService storageService = storageService;

        [HttpGet("students")]
        [Authorize(policy: AuthRole.Teacher)]
        public async Task<ActionResult> GetStudents()
        {

            List<Entities.Student> students = await sharedContext.Students.ToListAsync();
            List<StudentModel> studentModels = students.Select(x =>
                    StudentModel.FromStudent(x,
                        storageService.GeneratePreSignedURL(x.AvatarKey, TimeSpan.FromMinutes(5)))).ToList();

            return Ok(studentModels);
        }
    }
}
