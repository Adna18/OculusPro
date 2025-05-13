using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Controllers;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    public class ZdravstveniKartonController : BaseCRUDController<ZdravstveniKarton, ZdravstveniKartonSearchObject, ZdravstevniKartonInsertRequest, ZdravstevniKartonUpdateRequest>
    {
        public ZdravstveniKartonController(ILogger<BaseController<ZdravstveniKarton, ZdravstveniKartonSearchObject>> logger, IZdravstveniKartonService service)
            : base(logger, service)
        {
        }
    }
}
