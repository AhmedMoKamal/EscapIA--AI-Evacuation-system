using ESCAPIA.DTO;
using ESCAPIA.Model;

namespace ESCAPIA.Services.IServices
{
    public interface IAuthService
    {
        Task <LoginResponseDto?> LoginAsync(LoginDto dto);

        Task<UserProfileDto?> GetProfileAsync(int userId);
    }
}
