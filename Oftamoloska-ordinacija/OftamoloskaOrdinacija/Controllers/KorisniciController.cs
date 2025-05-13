using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Services.Database;

namespace OftamoloskaOrdinacija.Controllers
{
    [ApiController]
  

    public class KorisniciController : BaseCRUDController<Model.Korisnik,Model.SearchObjects.KorisnikSearchObject,KorisnikInsertRequest,KorisnikUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Model.Korisnik,Model.SearchObjects.KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {

        }

        [AllowAnonymous]
        public override Task<Model.Korisnik> Insert([FromBody] KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }


    }
}
