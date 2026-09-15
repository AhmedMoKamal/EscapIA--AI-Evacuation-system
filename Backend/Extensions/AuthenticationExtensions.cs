using ESCAPIA.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;

namespace ESCAPIA.Extensions
{
    public static class AuthenticationExtensions
    {
        public static IServiceCollection AddJwtAuthentication(this IServiceCollection services
            , IConfiguration configuration)
        {
            services
   .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
   .AddJwtBearer(options =>
   {
       options.TokenValidationParameters = new TokenValidationParameters
       {
           ValidateIssuer = true,
           ValidateAudience = true,
           ValidateLifetime = true,
           ValidateIssuerSigningKey = true,

           ValidIssuer = configuration["Jwt:Issuer"],

           ValidAudience =configuration["Jwt:Audience"],

           IssuerSigningKey = new SymmetricSecurityKey(
               Encoding.UTF8.GetBytes(
                  configuration["Jwt:Key"]!
               )
           )
       };

       options.Events = new JwtBearerEvents
       {
           OnTokenValidated = async context =>
           {
               var db = context.HttpContext
                   .RequestServices
                   .GetRequiredService<ApplicationDb>();

               var userIdClaim = context.Principal?
                   .FindFirst(ClaimTypes.NameIdentifier);

               if (userIdClaim == null)
               {
                   context.Fail("Invalid user");
                   return;
               }

               if (!int.TryParse(
                   userIdClaim.Value,
                   out int userId))
               {
                   context.Fail("Invalid user ID");
                   return;
               }

               var user = await db.Users
                   .AsNoTracking()
                   .FirstOrDefaultAsync(x => x.Id == userId);

               if (user == null)
               {
                   context.Fail("User not found");
                   return;
               }

               if (!user.IsActive)
               {
                   context.Fail(
                       "User access has been disabled by the mall"
                   );

                   return;
               }
           }
       };
   });
            services.AddAuthorization();
            return services;
        }
    }
}
