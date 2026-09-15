using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class AddExitCounts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SafeExitsCount",
                table: "IncidentLogs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TotalExits",
                table: "IncidentLogs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "SafeExitsCount",
                table: "detections",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TotalExits",
                table: "detections",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "SafeExitsCount",
                table: "BuildingState",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TotalExits",
                table: "BuildingState",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SafeExitsCount",
                table: "IncidentLogs");

            migrationBuilder.DropColumn(
                name: "TotalExits",
                table: "IncidentLogs");

            migrationBuilder.DropColumn(
                name: "SafeExitsCount",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "TotalExits",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "SafeExitsCount",
                table: "BuildingState");

            migrationBuilder.DropColumn(
                name: "TotalExits",
                table: "BuildingState");
        }
    }
}
