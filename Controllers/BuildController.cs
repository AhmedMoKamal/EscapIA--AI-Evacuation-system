using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.AspNetCore.Mvc;

namespace ESCAPIA.Controllers
{
 [ApiController]
    [Route("api/[controller]")]
    public class BuildController : ControllerBase
    {
       
          private readonly IBuildingStateService _buildingStateService;

            public BuildController(
                IBuildingStateService buildingStateService)
            {
                _buildingStateService = buildingStateService;
            }

       

          
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var state=await _buildingStateService.GetAllAsync();
            return Ok(state);
        }
        }
}
