using System.Text.Json.Serialization;

namespace ESCAPIA.DTO
{
    public class IncidentLogDto
    {
   

        public string ZoneId { get; set; } = string.Empty;

        public bool SmokeDetected { get; set; }

        public string CrowdDensity { get; set; } = string.Empty;

        public int PeopleCount { get; set; }

        public bool FireDetected { get; set; }

        public string RiskLevel { get; set; } = string.Empty;

        public bool EvacuationRequired { get; set; }

        public string Instruction { get; set; } = string.Empty;
       
        [JsonPropertyName("fullRoute")]
        public List<string> FullRoute { get; set; } = new();

        public bool isRerouted { get; set; }

        public int SafeExitsCount { get; set; }
        public int TotalExits { get; set; } = 2;

        public DateTime Timestamp { get; set; }
    }
}
