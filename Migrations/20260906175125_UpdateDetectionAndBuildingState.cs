using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDetectionAndBuildingState : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_zones",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "FireDetected",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "IsSafe",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "Name",
                table: "zones");

            migrationBuilder.RenameColumn(
                name: "SmokeLevel",
                table: "zones",
                newName: "Y");

            migrationBuilder.RenameColumn(
                name: "CrowdDensity",
                table: "zones",
                newName: "Floor");

            migrationBuilder.RenameColumn(
                name: "SafeRoute",
                table: "detections",
                newName: "FullRoute");

            migrationBuilder.RenameColumn(
                name: "SafeRoute",
                table: "BuildingState",
                newName: "FullRoute");

            migrationBuilder.AddColumn<string>(
                name: "ZoneId",
                table: "zones",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<double>(
                name: "X",
                table: "zones",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_zones",
                table: "zones",
                column: "ZoneId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_zones",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "ZoneId",
                table: "zones");

            migrationBuilder.DropColumn(
                name: "X",
                table: "zones");

            migrationBuilder.RenameColumn(
                name: "Y",
                table: "zones",
                newName: "SmokeLevel");

            migrationBuilder.RenameColumn(
                name: "Floor",
                table: "zones",
                newName: "CrowdDensity");

            migrationBuilder.RenameColumn(
                name: "FullRoute",
                table: "detections",
                newName: "SafeRoute");

            migrationBuilder.RenameColumn(
                name: "FullRoute",
                table: "BuildingState",
                newName: "SafeRoute");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "zones",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddColumn<bool>(
                name: "FireDetected",
                table: "zones",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsSafe",
                table: "zones",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "zones",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_zones",
                table: "zones",
                column: "Id");
        }
    }
}
