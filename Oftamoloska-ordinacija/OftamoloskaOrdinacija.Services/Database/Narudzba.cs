using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class Narudzba
    {
        public Narudzba()
        {
            StavkaNarudzbes = new HashSet<StavkaNarudzbe>();
            Transakcijas = new HashSet<Transakcija>();
        }

        public int NarudzbaId { get; set; }
        public string? BrojNarudzbe { get; set; }
        public DateTime? Datum { get; set; }
        public string? Status { get; set; }
        public int? KorisnikId { get; set; }
        public double? Iznos { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; }
        public virtual ICollection<Transakcija> Transakcijas { get; set; }
    }
}
