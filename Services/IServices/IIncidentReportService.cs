using ESCAPIA.DTO;
using ESCAPIA.Model;

namespace ESCAPIA.Services.IServices
{
    public interface IIncidentReportService
    {
            Task<string?> GetIncidentReportAsync(string incidentId);
            Task<IEnumerable<IncidentDto>> GetIncidents();
    }
}
