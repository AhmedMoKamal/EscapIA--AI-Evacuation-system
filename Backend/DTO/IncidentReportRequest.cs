namespace ESCAPIA.DTO
{
    public class IncidentReportRequest
    {
        public string IncidentId { get; set; } = string.Empty;

        public DateTime StartAt { get; set; }

        public DateTime? EndAt { get; set; }

        public string Status { get; set; } = string.Empty;

        public List<IncidentLogDto> Logs { get; set; } = new();
    }
}
