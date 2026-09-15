using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDetection : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SmokeLevel",
                table: "detections");

            migrationBuilder.RenameColumn(
                name: "TimesTemp",
                table: "detections",
                newName: "Timestamp");

            migrationBuilder.RenameColumn(
                name: "Location",
                table: "detections",
                newName: "ZoneId");

            migrationBuilder.AlterColumn<string>(
                name: "CrowdDensity",
                table: "detections",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "PeopleCount",
                table: "detections",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "SmokeDetected",
                table: "detections",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PeopleCount",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "SmokeDetected",
                table: "detections");

            migrationBuilder.RenameColumn(
                name: "ZoneId",
                table: "detections",
                newName: "Location");

            migrationBuilder.RenameColumn(
                name: "Timestamp",
                table: "detections",
                newName: "TimesTemp");

            migrationBuilder.AlterColumn<int>(
                name: "CrowdDensity",
                table: "detections",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddColumn<double>(
                name: "SmokeLevel",
                table: "detections",
                type: "float",
                nullable: false,
                defaultValue: 0.0);
        }
    }
}
