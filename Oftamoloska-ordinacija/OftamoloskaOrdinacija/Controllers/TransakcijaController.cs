using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
    public class TransakcijaController : BaseCRUDController<Model.Transakcija, BaseSearchObject, TransakcijaUpsertRequest, TransakcijaUpsertRequest>
    {
        public TransakcijaController(ILogger<BaseController<Model.Transakcija, BaseSearchObject>> logger, ITransakcijaService service)
            : base(logger, service)
        {
        }
    }
}
