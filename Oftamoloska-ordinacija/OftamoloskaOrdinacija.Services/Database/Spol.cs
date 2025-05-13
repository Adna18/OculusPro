using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class Spol
    {
        public Spol()
        {
            Korisniks = new HashSet<Korisnik>();
        }

        public int SpolId { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
    }
}
