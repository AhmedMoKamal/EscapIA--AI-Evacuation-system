using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class AddAIDecisionFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "EvacuationRequired",
                table: "detections",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Instruction",
                table: "detections",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "RiskLevel",
                table: "detections",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "SafeRoute",
                table: "detections",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "SafeRoute",
                table: "BuildingState",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EvacuationRequired",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "Instruction",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "RiskLevel",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "SafeRoute",
                table: "detections");

            migrationBuilder.DropColumn(
                name: "SafeRoute",
                table: "BuildingState");
        }
    }
}
