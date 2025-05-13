using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class TipKorisnika
    {
        public TipKorisnika()
        {
            Korisniks = new HashSet<Korisnik>();
        }

        public int TipKorisnikaId { get; set; }
        public string? Tip { get; set; }

        public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
    }
}
