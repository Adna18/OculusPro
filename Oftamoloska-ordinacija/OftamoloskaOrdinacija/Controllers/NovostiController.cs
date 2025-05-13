using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
    public class NovostiController : BaseCRUDController<Model.Novost, Model.SearchObjects.NovostSearchObject, NovostUpsertRequest, NovostUpsertRequest>
    {
        public NovostiController(ILogger<BaseController<Novost, Model.SearchObjects.NovostSearchObject>> logger, INovostiService service)
            : base(logger, service)
        {
        }
    }
}
