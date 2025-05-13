using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Services
{
    public interface IZdravstveniKartonService : ICRUDService<Model.ZdravstveniKarton, ZdravstveniKartonSearchObject, ZdravstevniKartonInsertRequest, ZdravstevniKartonUpdateRequest>
    {
    }
}
