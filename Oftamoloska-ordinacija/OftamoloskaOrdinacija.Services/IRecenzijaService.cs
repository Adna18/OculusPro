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
    public interface IRecenzijaService : ICRUDService<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
    }
}
