using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class Korisnik
    {
        public Korisnik()
        {
            Dojams = new HashSet<Dojam>();
            Narudzbas = new HashSet<Narudzba>();
            Novosts = new HashSet<Novost>();
            OmiljeniProizvodis = new HashSet<OmiljeniProizvodi>();
            Recenzijas = new HashSet<Recenzija>();
            TerminKorisnikIdDoktorNavigations = new HashSet<Termin>();
            TerminKorisnikIdPacijentNavigations = new HashSet<Termin>();
            ZdravstveniKartons = new HashSet<ZdravstveniKarton>();
        }

        public int KorisnikId { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? Telefon { get; set; }
        public string? Adresa { get; set; }
        public byte[]? Slika { get; set; }
        public string? LozinkaSalt { get; set; }
        public string? LozinkaHash { get; set; }
        public int? TipKorisnikaId { get; set; }
        public int? SpolId { get; set; }

        public virtual Spol? Spol { get; set; }
        public virtual TipKorisnika? TipKorisnika { get; set; }
        public virtual ICollection<Dojam> Dojams { get; set; }
        public virtual ICollection<Narudzba> Narudzbas { get; set; }
        public virtual ICollection<Novost> Novosts { get; set; }
        public virtual ICollection<OmiljeniProizvodi> OmiljeniProizvodis { get; set; }
        public virtual ICollection<Recenzija> Recenzijas { get; set; }
        public virtual ICollection<Termin> TerminKorisnikIdDoktorNavigations { get; set; }
        public virtual ICollection<Termin> TerminKorisnikIdPacijentNavigations { get; set; }
        public virtual ICollection<ZdravstveniKarton> ZdravstveniKartons { get; set; }
    }
}
