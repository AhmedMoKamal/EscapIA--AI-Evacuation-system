using ESCAPIA.DTO;
using ESCAPIA.Services.IServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;


namespace ESCAPIA.Controllers
{
   
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost]
        public async Task<IActionResult>Login (LoginDto loginDto)
        {
            if (string.IsNullOrWhiteSpace(loginDto.Password) ||
                 string.IsNullOrWhiteSpace(loginDto.PhoneNumber))
            {
                return BadRequest(new
                {
                    Message = "Phone number and password are required"
                });
            }

            var result =await _authService.LoginAsync(loginDto);
            if (result == null)
            {
                return Unauthorized(new
                {
                    Message = "Invalid credentials or inactive user"
                });
            }
            return Ok(result);
        }
        [Authorize]
        [HttpGet("profile")]
        public async Task<IActionResult> GetProfile()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
            {
                return Unauthorized();
            }

            if (!int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized();
            }

            var user = await _authService.GetProfileAsync(userId);

            if (user == null || !user.IsActive)
            {
                return Unauthorized();
            }

            return Ok(new
            {
                userId = user.Id,
                name = user.Name,
                phoneNumber = user.PhoneNumber,
                role = user.Role,
                isActive = user.IsActive
            });
        }

    }
}
