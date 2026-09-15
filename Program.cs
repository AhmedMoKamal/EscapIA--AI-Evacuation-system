
using ESCAPIA.Data;
using ESCAPIA.Extensions;
using ESCAPIA.Hub;
using ESCAPIA.Services;
using ESCAPIA.Services.IServices;

using Microsoft.EntityFrameworkCore;


namespace ESCAPIA
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // SignalR
            builder.Services.AddSignalR();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            //Database
            
            builder.Services.AddDbContext<ApplicationDb>(options =>
             options.UseSqlServer(
               builder.Configuration.GetConnectionString("DefaultConnection")
           ));


            // Authentication & Authorization
            builder.Services.AddJwtAuthentication(
                builder.Configuration
            );
            // Application Services
            builder.Services.AddScoped<IDetectionService, DetectionService>();

            //.........Future plans.........
            //builder.Services.AddScoped<ITwilioService, TwilioService>();
            builder.Services.AddScoped<IBuildingStateService, BuildingStateService>();

            builder.Services.AddHttpClient<IIncidentReportService, IncidentReportService>();
            builder.Services.AddScoped<IAuthService, AuthService>();

            //CORS
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowAll", policy =>
                {
                    policy
                        .AllowAnyHeader()
                        .AllowAnyMethod()
                        .AllowCredentials()
                        .SetIsOriginAllowed(_ => true);
                });
            });

            var app = builder.Build();


            // Configure the HTTP request pipeline.
            app.UseSwagger();
            app.UseSwaggerUI();

            app.UseHttpsRedirection();
            app.UseCors("AllowAll");

            app.UseAuthentication();

            app.UseAuthorization();


            app.MapControllers();
            app.MapHub<BuildingHub>("/buildingHub");

            app.Run();
        }
    }
}
