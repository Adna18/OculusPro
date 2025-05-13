using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace OftamoloskaOrdinacija.Services.Migrations
{
    public partial class baza : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "RecommendResult",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    PrviProizvodID = table.Column<int>(type: "int", nullable: true),
                    DrugiProizvodID = table.Column<int>(type: "int", nullable: true),
                    TreciProizvodID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecommendResult", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Spol",
                columns: table => new
                {
                    SpolID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Spol", x => x.SpolID);
                });

            migrationBuilder.CreateTable(
                name: "TipKorisnika",
                columns: table => new
                {
                    TipKorisnikaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Tip = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TipKorisnika", x => x.TipKorisnikaID);
                });

            migrationBuilder.CreateTable(
                name: "VrstaProizvoda",
                columns: table => new
                {
                    VrstaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrstaPro__42CB8F0F22B4B70C", x => x.VrstaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Adresa = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TipKorisnikaID = table.Column<int>(type: "int", nullable: true),
                    SpolID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnik", x => x.KorisnikID);
                    table.ForeignKey(
                        name: "FK__Korisnik__SpolID__403A8C7D",
                        column: x => x.SpolID,
                        principalTable: "Spol",
                        principalColumn: "SpolID");
                    table.ForeignKey(
                        name: "FK__Korisnik__TipKor__3F466844",
                        column: x => x.TipKorisnikaID,
                        principalTable: "TipKorisnika",
                        principalColumn: "TipKorisnikaID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvod",
                columns: table => new
                {
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Sifra = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    VrstaID = table.Column<int>(type: "int", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Proizvod", x => x.ProizvodID);
                    table.ForeignKey(
                        name: "FK__Proizvod__VrstaI__4316F928",
                        column: x => x.VrstaID,
                        principalTable: "VrstaProizvoda",
                        principalColumn: "VrstaID");
                });

            migrationBuilder.CreateTable(
                name: "Narudzba",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbe = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    Datum = table.Column<DateTime>(type: "date", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    Iznos = table.Column<double>(type: "float", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Narudzba", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FK__Narudzba__Korisn__45F365D3",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Novost",
                columns: table => new
                {
                    NovostID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DatumObjave = table.Column<DateTime>(type: "date", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Novost", x => x.NovostID);
                    table.ForeignKey(
                        name: "FK__Novost__Korisnik__4BAC3F29",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    TerminID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: true),
                    KorisnikID_doktor = table.Column<int>(type: "int", nullable: true),
                    KorisnikID_pacijent = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Termin", x => x.TerminID);
                    table.ForeignKey(
                        name: "FK__Termin__Korisnik__5DCAEF64",
                        column: x => x.KorisnikID_doktor,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Termin__Korisnik__5EBF139D",
                        column: x => x.KorisnikID_pacijent,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "ZdravstveniKarton",
                columns: table => new
                {
                    ZdravstveniKartonID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ZdravstveniKarton", x => x.ZdravstveniKartonID);
                    table.ForeignKey(
                        name: "FK__Zdravstve__Koris__48CFD27E",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Dojam",
                columns: table => new
                {
                    DojamID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsLiked = table.Column<bool>(type: "bit", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Dojam", x => x.DojamID);
                    table.ForeignKey(
                        name: "FK__Dojam__KorisnikI__52593CB8",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Dojam__ProizvodI__534D60F1",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "OmiljeniProizvodi",
                columns: table => new
                {
                    OmiljeniProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumDodavanja = table.Column<DateTime>(type: "date", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Omiljeni__C509DCAB6CEE6737", x => x.OmiljeniProizvodID);
                    table.ForeignKey(
                        name: "FK__OmiljeniP__Koris__571DF1D5",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__OmiljeniP__Proiz__5629CD9C",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "Recenzija",
                columns: table => new
                {
                    RecenzijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Datum = table.Column<DateTime>(type: "date", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Recenzija", x => x.RecenzijaID);
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__4F7CD00D",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FK__Recenzija__Proiz__4E88ABD4",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "StavkaNarudzbe",
                columns: table => new
                {
                    StavkaNarudzbeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Kolicina = table.Column<int>(type: "int", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: true),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StavkaNarudzbe", x => x.StavkaNarudzbeID);
                    table.ForeignKey(
                        name: "FK__StavkaNar__Narud__5AEE82B9",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaID");
                    table.ForeignKey(
                        name: "FK__StavkaNar__Proiz__59FA5E80",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "Transakcija",
                columns: table => new
                {
                    TransakcijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true),
                    Iznos = table.Column<double>(type: "float", nullable: true),
                    status_transakcije = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    trans_id = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transakcija", x => x.TransakcijaID);
                    table.ForeignKey(
                        name: "FK__Transakci__Narud__6383C8BA",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Dojam_KorisnikID",
                table: "Dojam",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Dojam_ProizvodID",
                table: "Dojam",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_SpolID",
                table: "Korisnik",
                column: "SpolID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_TipKorisnikaID",
                table: "Korisnik",
                column: "TipKorisnikaID");

            migrationBuilder.CreateIndex(
                name: "UQ__Korisnik__536C85E4FD7E0446",
                table: "Korisnik",
                column: "Username",
                unique: true,
                filter: "[Username] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "UQ__Korisnik__A9D105347AB120A1",
                table: "Korisnik",
                column: "Email",
                unique: true,
                filter: "[Email] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_KorisnikID",
                table: "Narudzba",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Novost_KorisnikID",
                table: "Novost",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniProizvodi_KorisnikID",
                table: "OmiljeniProizvodi",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OmiljeniProizvodi_ProizvodID",
                table: "OmiljeniProizvodi",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_VrstaID",
                table: "Proizvod",
                column: "VrstaID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_KorisnikID",
                table: "Recenzija",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_ProizvodID",
                table: "Recenzija",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_NarudzbaID",
                table: "StavkaNarudzbe",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_ProizvodID",
                table: "StavkaNarudzbe",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_KorisnikID_doktor",
                table: "Termin",
                column: "KorisnikID_doktor");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_KorisnikID_pacijent",
                table: "Termin",
                column: "KorisnikID_pacijent");

            migrationBuilder.CreateIndex(
                name: "IX_Transakcija_NarudzbaID",
                table: "Transakcija",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_ZdravstveniKarton_KorisnikID",
                table: "ZdravstveniKarton",
                column: "KorisnikID");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Dojam");

            migrationBuilder.DropTable(
                name: "Novost");

            migrationBuilder.DropTable(
                name: "OmiljeniProizvodi");

            migrationBuilder.DropTable(
                name: "Recenzija");

            migrationBuilder.DropTable(
                name: "RecommendResult");

            migrationBuilder.DropTable(
                name: "StavkaNarudzbe");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Transakcija");

            migrationBuilder.DropTable(
                name: "ZdravstveniKarton");

            migrationBuilder.DropTable(
                name: "Proizvod");

            migrationBuilder.DropTable(
                name: "Narudzba");

            migrationBuilder.DropTable(
                name: "VrstaProizvoda");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Spol");

            migrationBuilder.DropTable(
                name: "TipKorisnika");
        }
    }
}
