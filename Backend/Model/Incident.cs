namespace ESCAPIA.Model
{
    public class Incident
    {
        public int Id { get; set; }
        public string IncidentId {  get; set; }=string.Empty;
        public DateTime StartAt { get; set; }
        public DateTime? EndAt { get; set; }
        public string Status { get; set; } = "Open";
        public List<IncidentLog> Logs {  get; set; }=new List<IncidentLog>();
    }
}
