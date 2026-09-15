using ESCAPIA.Model;

namespace ESCAPIA.DTO
{
    public class IncidentDto
    {
        public int Id { get; set; }
        public string IncidentId { get; set; } = string.Empty;
        public DateTime StartAt { get; set; }
        public DateTime? EndAt { get; set; }
        public string Status { get; set; } = "Open";
        
    }
}
