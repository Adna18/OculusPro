using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;

[ApiController]
public class NarudzbaController : BaseCRUDController<Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
{
    public NarudzbaController(ILogger<BaseController<Narudzba, NarudzbaSearchObject>> logger, INarudzbaService service)
        : base(logger, service)
    {
    }
}