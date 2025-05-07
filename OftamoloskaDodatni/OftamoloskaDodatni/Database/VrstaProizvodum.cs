using System;
using System.Collections.Generic;

namespace OftamoloskaDodatni.Services.Database
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
