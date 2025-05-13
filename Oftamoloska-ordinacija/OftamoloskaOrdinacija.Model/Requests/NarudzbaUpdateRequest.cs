using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.Requests
{
    public class NarudzbaUpdateRequest
    {
        public int? Kolicina { get; set; }
        public string? Status { get; set; }
    }
}
