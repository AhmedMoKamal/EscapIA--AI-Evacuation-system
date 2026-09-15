using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class AddEvacuationInstruction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "EvacuationInstruction",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MessageAr = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MessageEn = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Exit = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EvacuationInstruction", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "EvacuationInstruction");
        }
    }
}
