using ESCAPIA.Data;
using ESCAPIA.Hub;
using ESCAPIA.Model;
using ESCAPIA.Services.IServices;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;


namespace ESCAPIA.Services
{
    public class BuildingStateService : IBuildingStateService
    {
        private readonly ApplicationDb _applicationDb;
        private readonly IHubContext<BuildingHub> _hubContext;
        public BuildingStateService(ApplicationDb applicationDb,
             IHubContext<BuildingHub> hubContext)

        {
            _applicationDb = applicationDb;
            _hubContext = hubContext;

        }
        public async Task<IEnumerable<BuildingState>> GetAllAsync()
        {
            return await _applicationDb.BuildingState
                .ToListAsync();
        }
       

        public async Task<BuildingState> UpdateAsync(BuildingState State)
        {
            // ==========================================
            //  Update current state of the Zone
            // ==========================================

            var existingState = await _applicationDb.BuildingState
                .FirstOrDefaultAsync(x => x.ZoneId == State.ZoneId);
            if (existingState == null)
            {
                _applicationDb.BuildingState.Add(State);
            }
            else
            {
                existingState.FireDetected = State.FireDetected;
                existingState.CrowdDensity = State.CrowdDensity;
                existingState.RiskLevel = State.RiskLevel;
                existingState.EvacuationRequired = State.EvacuationRequired;
                existingState.Instruction = State.Instruction;
                existingState.LastUpdated = State.LastUpdated;
                existingState.PeopleCount = State.PeopleCount;
                existingState.SmokeDetected = State.SmokeDetected;
                existingState.FullRoute = State.FullRoute;
                existingState.isRerouted = State.isRerouted;
                existingState.SafeExitsCount = State.SafeExitsCount;
                existingState.TotalExits = State.TotalExits;

            }

            //======================
            //Save Update
            //======================
            await _applicationDb.SaveChangesAsync();

            //=======================
            // Incident Logic
            //=======================

            var openIncident = await _applicationDb.Incidents
                .FirstOrDefaultAsync(x => x.Status == "Open");
            //======================
            //Fire Started
            //======================
            if (openIncident == null && State.FireDetected)
            {
                openIncident = new Incident
                {
                    IncidentId = $"INC-{Guid.NewGuid().ToString("N")[..8].ToUpper()}",
                    StartAt = State.LastUpdated,
                    Status = "Open"
                };
                _applicationDb.Incidents.Add(openIncident);
                //========================================
                // Save first to generate Incident Id
                //========================================
                await _applicationDb.SaveChangesAsync();
            }

            // ==========================================
            // 4. If there is an Incident
            //    save current state as IncidentLog
            // ==========================================

            if (openIncident != null)
            {
                var log = new IncidentLog
                {
                    IncidentId = openIncident.IncidentId,

                    Timestamp = State.LastUpdated,
                    ZoneId = State.ZoneId,
                    SmokeDetected = State.SmokeDetected,
                    CrowdDensity = State.CrowdDensity,
                    FireDetected = State.FireDetected,
                    FullRoute = State.FullRoute,
                    RiskLevel = State.RiskLevel,
                    EvacuationRequired = State.EvacuationRequired,
                    Instruction = State.Instruction,
                    PeopleCount = State.PeopleCount,
                    isRerouted = State.isRerouted,
                    SafeExitsCount = State.SafeExitsCount,
                    TotalExits = State.TotalExits,
                };
                _applicationDb.IncidentLogs.Add(log);


                // ==========================================
                // 5. Check ALL Zones
                // ==========================================

                var allZones = await _applicationDb.BuildingState
                    .ToListAsync();

                bool allZonesSafe =
                    allZones.Any() &&
                    allZones.All(x =>
                        !x.FireDetected &&
                        string.Equals(
                            x.RiskLevel,
                            "Low",
                            StringComparison.OrdinalIgnoreCase));


                // ==========================================
                // 6. Close Incident ONLY when ALL zones safe
                // ==========================================

                if (allZonesSafe)
                {
                    openIncident.Status = "Closed";
                    openIncident.EndAt = State.LastUpdated;
                }


                // ==========================================
                // 7. Save IncidentLog + Incident changes
                // ==========================================

                await _applicationDb.SaveChangesAsync();
            }

            // ==========================================
            // 8. Send update through SignalR
            // ==========================================

            await _hubContext.Clients.All
                .SendAsync("BuildingStateUpdated", State);


            return State;

        }
    }
}

