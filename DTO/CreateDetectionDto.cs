namespace ESCAPIA.DTO
{
    public class CreateDetectionDto
    {
        public string ZoneId { get; set; }=string.Empty;

        public bool SmokeDetected { get; set; }

        public string CrowdDensity { get; set; }= string.Empty;

        public bool FireDetected { get; set; }

        public int PeopleCount { get; set; }

        // Decision recieved from AI

        public string RiskLevel { get; set; } = string.Empty;

        public bool EvacuationRequired { get; set; }
        public string Instruction { get; set; } = string.Empty;

        public List<string> FullRoute { get; set; }=new();

        public bool isRouted { get; set; }
        public int SafeExitsCount { get; set; }
        public int TotalExits { get; set; } = 2;

    }
}
