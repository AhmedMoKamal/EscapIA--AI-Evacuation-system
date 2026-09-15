namespace ESCAPIA.DTO
{
    public class UserProfileDto
    {
        public int Id { get; set; }
        public string Name { get; set; }=string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Role { get; set; } = "Security";

        public bool IsActive { get; set; } = true;
    }
}
