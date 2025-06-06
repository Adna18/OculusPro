﻿using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
    public class RecenzijaController : BaseCRUDController<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
        public RecenzijaController(ILogger<BaseController<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject>> logger, IRecenzijaService service)
            : base(logger, service)
        {
        }
    }
}
