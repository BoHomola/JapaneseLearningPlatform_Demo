using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Models;
using JPLearningHub_Server.Services.Persistance.Context;
using JPLearningHub_Server.Services.Storage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace JPLearningHub_Server.Controllers
{
    [ApiController]
    [Route("api/")]
    public class TeacherController(SharedDBContext sharedContext, IStorageService storageService) : ControllerBase
    {
        private readonly SharedDBContext sharedContext = sharedContext;
        private readonly IStorageService storageService = storageService;

        [HttpGet("teachers")]
        [Authorize]
        public async Task<ActionResult> GetTeachers()
        {

            List<Teacher> teachers = await sharedContext.Teachers.ToListAsync();
            List<TeacherModel> teacherModels = teachers.Select(x =>
                    TeacherModel.FromTeacher(x,
                        storageService.GeneratePreSignedURL(x.AvatarKey, TimeSpan.FromMinutes(5)))).ToList();

            return Ok(teacherModels);
        }
    }
}
