using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.AspNetCore.Mvc;


namespace ESCAPIA.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IncidentsController : ControllerBase
    {
       private readonly IIncidentReportService _incidentReportService;
        public IncidentsController(IIncidentReportService incidentReportService)
        {
            _incidentReportService = incidentReportService;
        }
        [HttpGet("{incidentId}/report")]
        public async Task<IActionResult>GetReport(string incidentId)
        {
            var report= await _incidentReportService
                .GetIncidentReportAsync(incidentId);
            if (report == null)
            {
                return NotFound(new
                {
                    Message = "Incident not found"
                });
            }
            return Content(report, "text/markdown");
        }
        [HttpGet("incidents")]
        public async Task<ActionResult<IEnumerable<Incident>>> GetAllIncident()
        {
           var incident= await _incidentReportService.GetIncidents();
            return Ok(incident);
        }

      
    }
}
