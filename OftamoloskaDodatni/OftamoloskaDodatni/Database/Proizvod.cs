using System;
using System.Collections.Generic;

namespace OftamoloskaDodatni.Services.Database
{
    public partial class Proizvod
    {
        public Proizvod()
        {
            Dojams = new HashSet<Dojam>();
            OmiljeniProizvodis = new HashSet<OmiljeniProizvodi>();
            Recenzijas = new HashSet<Recenzija>();
            StavkaNarudzbes = new HashSet<StavkaNarudzbe>();
        }

        public int ProizvodId { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Sifra { get; set; }
        public decimal Cijena { get; set; }
        public int? VrstaId { get; set; }
        public byte[]? Slika { get; set; }
        public string? StateMachine { get; set; }

        public virtual VrstaProizvodum? Vrsta { get; set; }
        public virtual ICollection<Dojam> Dojams { get; set; }
        public virtual ICollection<OmiljeniProizvodi> OmiljeniProizvodis { get; set; }
        public virtual ICollection<Recenzija> Recenzijas { get; set; }
        public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; }
    }
}
