using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;


namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
    public class TerminController : BaseCRUDController<Model.Termin, Model.SearchObjects.TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>
    {
        public TerminController(ILogger<BaseController<Termin, Model.SearchObjects.TerminSearchObject>> logger, ITerminService service)
            : base(logger, service)
        {
        }
    }
}
