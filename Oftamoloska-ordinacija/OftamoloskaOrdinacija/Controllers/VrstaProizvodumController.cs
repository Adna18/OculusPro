using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    public class VrstaProizvodumController : BaseController<Model.VrstaProizvodum,BaseSearchObject>
    {
        public VrstaProizvodumController(ILogger<BaseController<Model.VrstaProizvodum,BaseSearchObject>> logger, 
            IService<Model.VrstaProizvodum,BaseSearchObject> service) : base(logger, service)
        {

        }
    }
}
