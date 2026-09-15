using ESCAPIA.Data;
using ESCAPIA.DTO;
using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.EntityFrameworkCore;

namespace ESCAPIA.Services
{
    public class IncidentReportService : IIncidentReportService
    {
        private readonly ApplicationDb _applicationDb;
        private readonly IConfiguration _configuration;
        private readonly HttpClient _httpClient;
        public IncidentReportService (ApplicationDb applicationDb , IConfiguration configuration, HttpClient httpClient)
        {
            _applicationDb = applicationDb;
            _configuration = configuration;
            _httpClient = httpClient;
        }
        public async Task<string?> GetIncidentReportAsync(string incidentId)
        {
            var incident= await _applicationDb.Incidents
                .Include(x=>x.Logs)
                .FirstOrDefaultAsync(x=>x.IncidentId == incidentId);
            if (incident == null)
            {
                return null;
            }
            var request=new IncidentReportRequest
            {
                IncidentId = incident.IncidentId,
                StartAt = incident.StartAt,
                EndAt = incident.EndAt,
                Status = incident.Status,
                Logs = incident.Logs
                .OrderBy(x => x.Timestamp)
                .Select(x => new IncidentLogDto
                {
                    ZoneId = x.ZoneId,
                    SmokeDetected=x.SmokeDetected,
                    FireDetected=x.FireDetected,
                    RiskLevel=x.RiskLevel,
                    PeopleCount=x.PeopleCount,
                    CrowdDensity=x.CrowdDensity,
                    EvacuationRequired=x.EvacuationRequired,
                    Instruction=x.Instruction,
                    FullRoute=x.FullRoute,
                    isRerouted=x.isRerouted,
                    TotalExits=x.TotalExits,
                    SafeExitsCount=x.SafeExitsCount,
                    Timestamp=x.Timestamp,
                   
                }
                ).ToList()
            };
            var url = _configuration["ReportApi:Url"];
            if (string.IsNullOrWhiteSpace(url))
            {
                throw new InvalidOperationException(
                     "ReportApi:Url is not configured."
                    );
            }
            var response = await _httpClient.PostAsJsonAsync(url, request);

           
            if (!response.IsSuccessStatusCode)
            {
                throw new HttpRequestException(
                    $"Report API failed : {(int)response.StatusCode} {response.ReasonPhrase}"
                );
            }
            var Report =
                await response.Content
                .ReadFromJsonAsync<IncidentReportResponse>();
            
            if (Report == null)
            {
                throw new Exception("Empty report response from Report API.");
            }
            return Report.Report;
        }

        public async Task<IEnumerable<IncidentDto>> GetIncidents()
        {
           var incidents=await _applicationDb.Incidents
                
                .OrderByDescending(x=>x.Id)
                .ToListAsync();
            return incidents.Select(x => new IncidentDto
            {
                Id = x.Id,
                IncidentId = x.IncidentId,
                StartAt = x.StartAt,
                EndAt = x.EndAt,
                Status = x.Status,
             
            });
                
        }
    }
        
    
}
