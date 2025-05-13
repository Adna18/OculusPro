using OftamoloskaOrdinacija.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.Requests
{
    public class NarudzbaInsertRequest
    {
        public List<StavkaNarudzbe>? Items { get; set; }
        public int? KorisnikID { get; set; }
    }
}
