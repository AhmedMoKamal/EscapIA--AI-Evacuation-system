using ESCAPIA.Data;
using ESCAPIA.DTO;
using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ESCAPIA.Services
{
    public class AuthService : IAuthService
    {
        private readonly ApplicationDb _applicationDb;
        private readonly IConfiguration _configuration;
        public AuthService(ApplicationDb applicationDb, IConfiguration configuration)
        {
            _applicationDb = applicationDb;
            _configuration = configuration;
        }

        public async Task<UserProfileDto?> GetProfileAsync(int userId)
        {
            return await _applicationDb.Users
                .AsNoTracking()
                .Where(x=>x.Id == userId)
                .Select(x=> new UserProfileDto
                {
                    Id = x.Id,
                    Name = x.Name,
                    PhoneNumber = x.PhoneNumber,
                    IsActive = x.IsActive,
                    Role = x.Role,
                }
                ).FirstOrDefaultAsync();
        }

        public async Task<LoginResponseDto?> LoginAsync(LoginDto dto)
        {
            var user=await _applicationDb.Users
                .FirstOrDefaultAsync(x=>x.PhoneNumber == dto.PhoneNumber);
            if (user == null || !user.IsActive)
            {
                return null;
            }
            bool passwordValid = BCrypt.Net.BCrypt.Verify(
                dto.Password
                , user.PasswordHash);
            if (!passwordValid)
            {
                return null;
            }
            var claims = new List<Claim>
            {
                new Claim(
                    ClaimTypes.NameIdentifier,
                    user.Id.ToString()
                ),

                new Claim(
                    ClaimTypes.Name,
                    user.Name
                ),

                new Claim(
                    ClaimTypes.Role,
                    user.Role
                )
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(
                    _configuration["Jwt:Key"]!
                )
            );

            var credentials =
                new SigningCredentials(
                    key,
                    SecurityAlgorithms.HmacSha256
                );

            // JWT صالح لمدة 2 شهور
            var expiresAt =
                DateTime.UtcNow.AddMonths(2);

            var token = new JwtSecurityToken(
                issuer:
                    _configuration["Jwt:Issuer"],

                audience:
                    _configuration["Jwt:Audience"],

                claims: claims,

                expires: expiresAt,

                signingCredentials: credentials
            );

            var tokenString =
                new JwtSecurityTokenHandler()
                    .WriteToken(token);

            return new LoginResponseDto
            {
                Token = tokenString,
                UserId = user.Id,
                Name = user.Name,
                Role = user.Role,
                ExpiresAt = expiresAt
            };
        }

    }
    }

