﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.Requests
{
    public class NovostUpsertRequest
    {
        public string? Naslov { get; set; }

        public string? Sadrzaj { get; set; }

        public DateTime? DatumObjave { get; set; }

    }
}
