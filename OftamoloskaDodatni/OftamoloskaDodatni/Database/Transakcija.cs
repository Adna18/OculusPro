using System;
using System.Collections.Generic;

namespace OftamoloskaDodatni.Services.Database
{
    public partial class Transakcija
    {
        public int TransakcijaId { get; set; }
        public int? NarudzbaId { get; set; }
        public double? Iznos { get; set; }
        public string? StatusTransakcije { get; set; }
        public string? TransId { get; set; }

        public virtual Narudzba? Narudzba { get; set; }
    }
}
