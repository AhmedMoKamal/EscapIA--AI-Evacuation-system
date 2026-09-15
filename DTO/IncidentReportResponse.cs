using System.Text.Json.Serialization;

namespace ESCAPIA.DTO
{
    public class IncidentReportResponse
    {
        public string IncidentId {  get; set; }=string.Empty;

        [JsonPropertyName("report_markdown")]
        public string Report {  get; set; }=string.Empty;
    }
}
