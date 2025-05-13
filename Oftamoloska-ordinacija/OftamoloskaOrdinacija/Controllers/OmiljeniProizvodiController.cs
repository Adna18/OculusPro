using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
    public class OmiljeniProizvodiController : BaseCRUDController<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject, OmiljeniProizvodiUpsertRequest, OmiljeniProizvodiUpsertRequest>
    {
        public OmiljeniProizvodiController(ILogger<BaseController<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject>> logger, IOmiljeniProizvodiService service)
            : base(logger, service)
        {
        }
    }
}
