using OftamoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.SearchObjects
{
    public class TerminSearchObject : BaseSearchObject
    {
        public string? Doktor { get; set; }
        public string? Pacijent { get; set; }
        public DateTime? Datum { get; set; }
    }
}
