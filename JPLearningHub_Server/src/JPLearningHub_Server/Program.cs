using System.Security.Claims;
using System.Text;
using JPLearningHub_Server.Services.Authentication;
using JPLearningHub_Server.Services.Persistance.Abstract;
using JPLearningHub_Server.Services.Persistance.Context;
using JPLearningHub_Server.Services.Persistance.Implementation;
using JPLearningHub_Server.Services.Persistance.Seeder;
using JPLearningHub_Server.Services.Storage;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);
DotNetEnv.Env.Load("../../.env");
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
string? connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING");
builder.Services.AddDbContext<SharedDBContext>(options => options.UseNpgsql(connectionString));

builder.Services.AddScoped<IAuthProvider, PGAuthProvider>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IStorageService, S3StorageService>();
builder.Services.AddTransient<ISeeder, Seeder>();

builder.Services.AddControllers();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AnyCors", policy =>
    {
        policy.SetIsOriginAllowed(origin => true)
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddAuthentication(o =>
            {
                o.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                o.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                o.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(o =>
            {
                o.IncludeErrorDetails = true;
                o.SaveToken = true;
                o.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(DotNetEnv.Env.GetString("JWT_SECRET_KEY")!)
                    ),
                    ValidateIssuer = false,
                    ValidateAudience = true,
                    ValidAudience = "authenticated",
                };
                o.Events = new JwtBearerEvents()
                {
                    OnTokenValidated = context =>
                    {
                        if (context.Principal == null)
                        {
                            return Task.CompletedTask;
                        }
                        ClaimsPrincipal principal = context.Principal;
                        if (principal.Identity is not ClaimsIdentity identity)
                        {
                            return Task.CompletedTask;
                        }
                        string? userMetadata = context.Principal.FindFirst("user_metadata")?.Value;

                        if (!string.IsNullOrEmpty(userMetadata))
                        {
                            Dictionary<string, string>? metadata = JsonConvert.DeserializeObject<Dictionary<string, string>>(userMetadata);
                            if (metadata == null)
                            {
                                return Task.CompletedTask;
                            }
                            if (metadata.TryGetValue("role", out string? role) && role != null)
                            {
                                identity.AddClaim(new Claim(ClaimTypes.Role, role.ToString()));
                            }
                        }

                        return Task.CompletedTask;
                    }
                };
            });

builder.Services.AddAuthorizationBuilder()
    .AddPolicy(AuthRole.Student, policy => policy.RequireRole(AuthRole.Student))
    .AddPolicy(AuthRole.Teacher, policy => policy.RequireRole(AuthRole.Teacher));

builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "JPLearningHub API",
        Version = "v1"
    });

    OpenApiSecurityScheme securityScheme = new()
    {
        Name = "JWT Authentication",
        Description = "Enter your JWT token in this field",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT"
    };

    options.AddSecurityDefinition("Bearer", securityScheme);

    OpenApiSecurityRequirement securityRequirement = new()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
};

    options.AddSecurityRequirement(securityRequirement);

});

WebApplication app = builder.Build();

if (args.Contains("seed"))
{
    //create new scope
    using IServiceScope scope = app.Services.CreateScope();
    ISeeder seeder = scope.ServiceProvider.GetRequiredService<ISeeder>();
    seeder.SeedData();
    return;
}

if (args.Contains("drop"))
{
    //create new scope
    using IServiceScope scope = app.Services.CreateScope();
    ISeeder seeder = scope.ServiceProvider.GetRequiredService<ISeeder>();
    seeder.DropDB();
    return;
}

app.UseCors("AnyCors");
app.MapControllers();
app.UseAuthentication();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();

app.Run();
