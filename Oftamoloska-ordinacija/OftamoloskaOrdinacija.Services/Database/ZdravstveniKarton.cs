using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class ZdravstveniKarton
    {
        public int ZdravstveniKartonId { get; set; }
        public string? Sadrzaj { get; set; }
        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
    }
}
