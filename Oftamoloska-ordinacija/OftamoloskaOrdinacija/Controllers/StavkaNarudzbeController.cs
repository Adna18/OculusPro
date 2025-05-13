using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    public class StavkaNarudzbeController : BaseCRUDController<Model.StavkaNarudzbe, Model.SearchObjects.StavkaNarudzbeSearchObject, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>
    {
        public StavkaNarudzbeController(ILogger<BaseController<Model.StavkaNarudzbe, Model.SearchObjects.StavkaNarudzbeSearchObject>> logger, IStavkaNarudzbeService service)
            : base(logger, service)
        {
        }

    }
}
