using ESCAPIA.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using System.Text.Json;


namespace ESCAPIA.Data
{
    public class ApplicationDb:DbContext
    {
        public ApplicationDb(DbContextOptions<ApplicationDb> options) : base (options) 
        { 
        }
        public DbSet<Detection> detections { get; set; }
        
        public DbSet<BuildingState> BuildingState { get; set; }

        public DbSet<User> Users { get; set; }
        public DbSet<Incident> Incidents { get; set; }

        public DbSet<IncidentLog> IncidentLogs { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            //=========================
            // FullRoute Converter
            //=========================

            var routeConverter=new ValueConverter<List<string>,string>(

                v=>JsonSerializer.Serialize(v,(JsonSerializerOptions?)null),

                v=>JsonSerializer.Deserialize<List<string>>(v, (JsonSerializerOptions?)null
                )??new List<string>()
                 
                );

            modelBuilder.Entity<Detection>()
            .Property(x => x.FullRoute)
            .HasConversion(routeConverter);

            modelBuilder.Entity<BuildingState>()
            .Property(x => x.FullRoute)
            .HasConversion(routeConverter);


            //=========================
            // Incident -> IncidentLog
            //=========================

            modelBuilder.Entity<IncidentLog>()
                .HasOne(x=> x.Incident)
                .WithMany(x=>x.Logs)
                .HasForeignKey(x=>x.IncidentId)
                .HasPrincipalKey(x=>x.IncidentId)
                .OnDelete(DeleteBehavior.Cascade);

        }
    }
}
