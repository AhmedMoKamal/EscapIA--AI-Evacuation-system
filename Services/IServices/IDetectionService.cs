using ESCAPIA.DTO;
using ESCAPIA.Model;

namespace ESCAPIA.Services.IServices
{
    public interface IDetectionService
    {
        
        
        Task<Detection> CreateAsync (Detection detection);
        
        
    }
}
