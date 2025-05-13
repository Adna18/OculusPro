using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class OftamoloskiCentarContext : DbContext
    {
        public OftamoloskiCentarContext()
        {
        }

        public OftamoloskiCentarContext(DbContextOptions<OftamoloskiCentarContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Dojam> Dojams { get; set; } = null!;
        public virtual DbSet<Korisnik> Korisniks { get; set; } = null!;
        public virtual DbSet<Narudzba> Narudzbas { get; set; } = null!;
        public virtual DbSet<Novost> Novosts { get; set; } = null!;
        public virtual DbSet<OmiljeniProizvodi> OmiljeniProizvodis { get; set; } = null!;
        public virtual DbSet<Proizvod> Proizvods { get; set; } = null!;
        public virtual DbSet<Recenzija> Recenzijas { get; set; } = null!;
        public virtual DbSet<RecommendResult> RecommendResults { get; set; } = null!;
        public virtual DbSet<Spol> Spols { get; set; } = null!;
        public virtual DbSet<StavkaNarudzbe> StavkaNarudzbes { get; set; } = null!;
        public virtual DbSet<Termin> Termins { get; set; } = null!;
        public virtual DbSet<TipKorisnika> TipKorisnikas { get; set; } = null!;
        public virtual DbSet<Transakcija> Transakcijas { get; set; } = null!;
        public virtual DbSet<VrstaProizvodum> VrstaProizvoda { get; set; } = null!;
        public virtual DbSet<ZdravstveniKarton> ZdravstveniKartons { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server=localhost;Database=OftamoloskiCentar;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Dojam>(entity =>
            {
                entity.ToTable("Dojam");

                entity.Property(e => e.DojamId).HasColumnName("DojamID");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Dojams)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Dojam__KorisnikI__52593CB8");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.Dojams)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK__Dojam__ProizvodI__534D60F1");
            });

            modelBuilder.Entity<Korisnik>(entity =>
            {
                entity.ToTable("Korisnik");

                entity.HasIndex(e => e.Username, "UQ__Korisnik__536C85E4FD7E0446")
                    .IsUnique();

                entity.HasIndex(e => e.Email, "UQ__Korisnik__A9D105347AB120A1")
                    .IsUnique();

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.Adresa).HasMaxLength(20);

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.Ime).HasMaxLength(50);

                entity.Property(e => e.Prezime).HasMaxLength(50);

                entity.Property(e => e.SpolId).HasColumnName("SpolID");

                entity.Property(e => e.Telefon).HasMaxLength(20);

                entity.Property(e => e.TipKorisnikaId).HasColumnName("TipKorisnikaID");

                entity.Property(e => e.Username).HasMaxLength(20);

                entity.HasOne(d => d.Spol)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.SpolId)
                    .HasConstraintName("FK__Korisnik__SpolID__403A8C7D");

                entity.HasOne(d => d.TipKorisnika)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.TipKorisnikaId)
                    .HasConstraintName("FK__Korisnik__TipKor__3F466844");
            });

            modelBuilder.Entity<Narudzba>(entity =>
            {
                entity.ToTable("Narudzba");

                entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");

                entity.Property(e => e.BrojNarudzbe).HasMaxLength(10);

                entity.Property(e => e.Datum).HasColumnType("date");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.Status).HasMaxLength(20);

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Narudzbas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Narudzba__Korisn__45F365D3");
            });

            modelBuilder.Entity<Novost>(entity =>
            {
                entity.ToTable("Novost");

                entity.Property(e => e.NovostId).HasColumnName("NovostID");

                entity.Property(e => e.DatumObjave).HasColumnType("date");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.Naslov).HasMaxLength(50);

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Novosts)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Novost__Korisnik__4BAC3F29");
            });

            modelBuilder.Entity<OmiljeniProizvodi>(entity =>
            {
                entity.HasKey(e => e.OmiljeniProizvodId)
                    .HasName("PK__Omiljeni__C509DCAB6CEE6737");

                entity.ToTable("OmiljeniProizvodi");

                entity.Property(e => e.OmiljeniProizvodId).HasColumnName("OmiljeniProizvodID");

                entity.Property(e => e.DatumDodavanja).HasColumnType("date");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.OmiljeniProizvodis)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__OmiljeniP__Koris__571DF1D5");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.OmiljeniProizvodis)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK__OmiljeniP__Proiz__5629CD9C");
            });

            modelBuilder.Entity<Proizvod>(entity =>
            {
                entity.ToTable("Proizvod");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.Property(e => e.Cijena).HasColumnType("decimal(10, 2)");

                entity.Property(e => e.Naziv).HasMaxLength(50);

                entity.Property(e => e.StateMachine).HasMaxLength(50);

                entity.Property(e => e.VrstaId).HasColumnName("VrstaID");

                entity.HasOne(d => d.Vrsta)
                    .WithMany(p => p.Proizvods)
                    .HasForeignKey(d => d.VrstaId)
                    .HasConstraintName("FK__Proizvod__VrstaI__4316F928");
            });

            modelBuilder.Entity<Recenzija>(entity =>
            {
                entity.ToTable("Recenzija");

                entity.Property(e => e.RecenzijaId).HasColumnName("RecenzijaID");

                entity.Property(e => e.Datum).HasColumnType("date");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Recenzijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Recenzija__Koris__4F7CD00D");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.Recenzijas)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK__Recenzija__Proiz__4E88ABD4");
            });

            modelBuilder.Entity<RecommendResult>(entity =>
            {
                entity.ToTable("RecommendResult");

                entity.Property(e => e.DrugiProizvodId).HasColumnName("DrugiProizvodID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.Property(e => e.PrviProizvodId).HasColumnName("PrviProizvodID");

                entity.Property(e => e.TreciProizvodId).HasColumnName("TreciProizvodID");
            });

            modelBuilder.Entity<Spol>(entity =>
            {
                entity.ToTable("Spol");

                entity.Property(e => e.SpolId).HasColumnName("SpolID");

                entity.Property(e => e.Naziv).HasMaxLength(10);
            });

            modelBuilder.Entity<StavkaNarudzbe>(entity =>
            {
                entity.ToTable("StavkaNarudzbe");

                entity.Property(e => e.StavkaNarudzbeId).HasColumnName("StavkaNarudzbeID");

                entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");

                entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");

                entity.HasOne(d => d.Narudzba)
                    .WithMany(p => p.StavkaNarudzbes)
                    .HasForeignKey(d => d.NarudzbaId)
                    .HasConstraintName("FK__StavkaNar__Narud__5AEE82B9");

                entity.HasOne(d => d.Proizvod)
                    .WithMany(p => p.StavkaNarudzbes)
                    .HasForeignKey(d => d.ProizvodId)
                    .HasConstraintName("FK__StavkaNar__Proiz__59FA5E80");
            });

            modelBuilder.Entity<Termin>(entity =>
            {
                entity.ToTable("Termin");

                entity.Property(e => e.TerminId).HasColumnName("TerminID");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.Property(e => e.KorisnikIdDoktor).HasColumnName("KorisnikID_doktor");

                entity.Property(e => e.KorisnikIdPacijent).HasColumnName("KorisnikID_pacijent");

                entity.HasOne(d => d.KorisnikIdDoktorNavigation)
                    .WithMany(p => p.TerminKorisnikIdDoktorNavigations)
                    .HasForeignKey(d => d.KorisnikIdDoktor)
                    .HasConstraintName("FK__Termin__Korisnik__5DCAEF64");

                entity.HasOne(d => d.KorisnikIdPacijentNavigation)
                    .WithMany(p => p.TerminKorisnikIdPacijentNavigations)
                    .HasForeignKey(d => d.KorisnikIdPacijent)
                    .HasConstraintName("FK__Termin__Korisnik__5EBF139D");
            });

            modelBuilder.Entity<TipKorisnika>(entity =>
            {
                entity.ToTable("TipKorisnika");

                entity.Property(e => e.TipKorisnikaId).HasColumnName("TipKorisnikaID");

                entity.Property(e => e.Tip).HasMaxLength(50);
            });

            modelBuilder.Entity<Transakcija>(entity =>
            {
                entity.ToTable("Transakcija");

                entity.Property(e => e.TransakcijaId).HasColumnName("TransakcijaID");

                entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");

                entity.Property(e => e.StatusTransakcije)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("status_transakcije");

                entity.Property(e => e.TransId)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("trans_id");

                entity.HasOne(d => d.Narudzba)
                    .WithMany(p => p.Transakcijas)
                    .HasForeignKey(d => d.NarudzbaId)
                    .HasConstraintName("FK__Transakci__Narud__6383C8BA");
            });

            modelBuilder.Entity<VrstaProizvodum>(entity =>
            {
                entity.HasKey(e => e.VrstaId)
                    .HasName("PK__VrstaPro__42CB8F0F22B4B70C");

                entity.Property(e => e.VrstaId).HasColumnName("VrstaID");

                entity.Property(e => e.Naziv).HasMaxLength(50);
            });

            modelBuilder.Entity<ZdravstveniKarton>(entity =>
            {
                entity.ToTable("ZdravstveniKarton");

                entity.Property(e => e.ZdravstveniKartonId).HasColumnName("ZdravstveniKartonID");

                entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.ZdravstveniKartons)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Zdravstve__Koris__48CFD27E");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
