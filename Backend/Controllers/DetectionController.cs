using ESCAPIA.DTO;
using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.AspNetCore.Mvc;

namespace ESCAPIA.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DetectionController : ControllerBase
    {
       private readonly IDetectionService _detectionService;
        
        public DetectionController(IDetectionService detectionService)
        {
            _detectionService = detectionService;
            
            
        }
       
        [HttpPost]
        public async Task <ActionResult<Detection>> CreateAsync(CreateDetectionDto Dto)
        {
            var detection=new Detection
            {
                ZoneId=Dto.ZoneId,
                PeopleCount=Dto.PeopleCount,
                CrowdDensity=Dto.CrowdDensity,
                SmokeDetected=Dto.SmokeDetected,
                FireDetected=Dto.FireDetected,

                RiskLevel=Dto.RiskLevel,
                EvacuationRequired=Dto.EvacuationRequired,
                FullRoute=Dto.FullRoute ,
                Instruction=Dto.Instruction,
                
                isRerouted=Dto.isRouted,
                SafeExitsCount=Dto.SafeExitsCount,
                TotalExits=Dto.TotalExits,
                
                
            };
            var result=await _detectionService.CreateAsync(detection);
         
            return Ok(result);
        }

       
    }
}
