﻿using OftamoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Model.SearchObjects
{
    public class OmiljeniProizvodiSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public int? ProizvodId { get; set; }

    }
}
