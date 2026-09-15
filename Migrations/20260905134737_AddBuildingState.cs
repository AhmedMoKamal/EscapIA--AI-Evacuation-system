using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class AddBuildingState : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BuildingState",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ZoneId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SmokeDetected = table.Column<bool>(type: "bit", nullable: false),
                    CrowdDensity = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PeopleCount = table.Column<int>(type: "int", nullable: false),
                    FireDetected = table.Column<bool>(type: "bit", nullable: false),
                    RiskLevel = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EvacuationRequired = table.Column<bool>(type: "bit", nullable: false),
                    Instruction = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastUpdated = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BuildingState", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BuildingState");
        }
    }
}
