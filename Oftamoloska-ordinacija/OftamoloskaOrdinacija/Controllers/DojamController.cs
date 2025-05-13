using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Model;


namespace OftamoloskaOrdinacija.Controllers
{

        [ApiController]
    public class DojamController : BaseCRUDController<Model.Dojam, Model.SearchObjects.DojamSearchObject, Model.Dojam, Model.Dojam>
    {
        public DojamController(ILogger<BaseController<Dojam, Model.SearchObjects.DojamSearchObject>> logger, IDojamService service)
            : base(logger, service)
        {
        }
    }
}

