using ESCAPIA.Model;

namespace ESCAPIA.Services.IServices
{
    public interface IBuildingStateService
    {
       
        Task<BuildingState> UpdateAsync(BuildingState State);
        Task<IEnumerable<BuildingState>> GetAllAsync ();
    }
}
