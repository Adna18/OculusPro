﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.Requests
{
    public class RecenzijaInsertRequest
    {
        public int RecenzijaId { get; set; }

        public string? Sadrzaj { get; set; }

        public DateTime? Datum { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }
    }
}
