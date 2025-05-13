using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Services.Database;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]

    public class ProizvodiController : BaseCRUDController<Model.Proizvodi, Model.SearchObjects.ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>
    {
        public  ProizvodiController(ILogger<BaseController<Model.Proizvodi, Model.SearchObjects.ProizvodiSearchObject>> logger, IProizvodiService service) : base(logger, service)
        {

        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Proizvodi> Activate(int id)
        {
            return await (_service as IProizvodiService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Model.Proizvodi> Hide(int id)
        {
            return await (_service as IProizvodiService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IProizvodiService).AllowedActions(id);
        }

    }
}
