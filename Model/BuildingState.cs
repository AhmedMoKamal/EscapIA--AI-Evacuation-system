namespace ESCAPIA.Model
{
    public class BuildingState
    {
        public int Id { get; set; }

        public string ZoneId { get; set; } = string.Empty;

        public bool SmokeDetected { get; set; }

        public string CrowdDensity { get; set; } = string.Empty;
        public int PeopleCount { get; set; }

        public bool FireDetected { get; set; }

        public string RiskLevel { get; set; } = string.Empty;

        public bool EvacuationRequired { get; set; }

        public string Instruction { get; set; } = string.Empty;
        public List<string> FullRoute { get; set; } = new();

        public bool isRerouted { get; set; }
        public DateTime LastUpdated { get; set; }

        public int SafeExitsCount { get; set; }
        public int TotalExits { get; set; } = 2;
    }
}
