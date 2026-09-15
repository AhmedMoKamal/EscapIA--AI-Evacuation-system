using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ESCAPIA.Migrations
{
    /// <inheritdoc />
    public partial class RemoveZoneAndExit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "exits");

            migrationBuilder.DropTable(
                name: "zones");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "exits",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Capactiy = table.Column<int>(type: "int", nullable: false),
                    IsAvailable = table.Column<bool>(type: "bit", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_exits", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "zones",
                columns: table => new
                {
                    ZoneId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Floor = table.Column<int>(type: "int", nullable: false),
                    X = table.Column<double>(type: "float", nullable: false),
                    Y = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_zones", x => x.ZoneId);
                });
        }
    }
}
