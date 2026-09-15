using ESCAPIA.Data;
using ESCAPIA.Model;
using ESCAPIA.Services.IServices;


namespace ESCAPIA.Services
{
    public class DetectionService : IDetectionService
    {
        private readonly ApplicationDb _applicationDb;
        private readonly IBuildingStateService _buildingStateService;
        //private readonly ITwilioService twilioService;

        public DetectionService(ApplicationDb applicationDb, IBuildingStateService buildingStateService)
        //,ITwilioService twilioService)
        {
            _applicationDb = applicationDb;
            _buildingStateService = buildingStateService;
            //this.twilioService = twilioService;

        }
        public async Task<Detection> CreateAsync(Detection detection)
        {
            //=======================
            //save Detection
            //=======================

            _applicationDb.detections.Add(detection);
            await _applicationDb.SaveChangesAsync();


            //Update Building State
            var state = new BuildingState
            {
                ZoneId = detection.ZoneId,
                FireDetected = detection.FireDetected,
                CrowdDensity = detection.CrowdDensity,
                SmokeDetected = detection.SmokeDetected,
                PeopleCount = detection.PeopleCount,

                RiskLevel = detection.RiskLevel,
                EvacuationRequired = detection.EvacuationRequired,
                Instruction = detection.Instruction,
                FullRoute = detection.FullRoute,
                isRerouted = detection.isRerouted,
                SafeExitsCount = detection.SafeExitsCount,
                TotalExits = detection.TotalExits,
                LastUpdated = DateTime.UtcNow,

            };
            await _buildingStateService.UpdateAsync(state);
            //============================================
            //Message   //.........Future plans.........
            //============================================
            //if (detection.EvacuationRequired)
            //{
            //    var message =
            //        $"EMERGENCY!\n Fire detected in {detection.ZoneId}.\n "
            //        + $"Level: {detection.RiskLevel}. \n"
            //        + $"Evacuation Required: {detection.Instruction}.\n "
            //        + $"Full Route: {string.Join(" → ", detection.FullRoute)}.\n\n"

            //        + $"🚨 تحذير طارئ!\n"
            //        + $"تم اكتشاف حريق في {detection.ZoneId}.\n"
            //        + $"مستوى الخطر: {detection.RiskLevel}\n"
            //        + $"يجب الإخلاء: {detection.Instruction}\n"
            //        + $"المسار الآمن: {string.Join(" → ", detection.FullRoute)}\n\n";

            //    var users = await applicationDb.Users.ToListAsync();
            //    foreach (var user in users)
            //    {
            //        await twilioService.SendEmergencySmsAsync(message, user.PhoneNumber);
            //    }




            return detection;
        }
    }
}
     
    
//}
