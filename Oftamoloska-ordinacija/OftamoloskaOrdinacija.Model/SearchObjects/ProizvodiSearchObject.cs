using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.SearchObjects
{
    public class ProizvodiSearchObject:BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? Sifra { get; set; }
    }
}
