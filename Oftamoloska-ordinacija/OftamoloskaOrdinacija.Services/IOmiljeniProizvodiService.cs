using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public interface IOmiljeniProizvodiService : ICRUDService<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject, OmiljeniProizvodiUpsertRequest, OmiljeniProizvodiUpsertRequest>
    {

    }
}
