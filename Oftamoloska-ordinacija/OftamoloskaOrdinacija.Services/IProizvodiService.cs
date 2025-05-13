using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public interface IProizvodiService:ICRUDService<Proizvodi,ProizvodiSearchObject,ProizvodiInsertRequest,ProizvodiUpdateRequest>
    {
        Task<Model.Proizvodi> Activate(int id);
        Task<Model.Proizvodi> Hide(int id);
        Task<List<string>> AllowedActions(int id);


    }
}
