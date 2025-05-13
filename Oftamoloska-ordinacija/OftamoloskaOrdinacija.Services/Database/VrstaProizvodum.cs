using System;
using System.Collections.Generic;

namespace OftamoloskaOrdinacija.Services.Database
{
    public partial class VrstaProizvodum
    {
        public VrstaProizvodum()
        {
            Proizvods = new HashSet<Proizvod>();
        }

        public int VrstaId { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Proizvod> Proizvods { get; set; }
    }
}
