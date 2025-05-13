using AutoMapper;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services.Database;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public class TransakcijaService : BaseCRUDService<Model.Transakcija, Database.Transakcija, Model.SearchObjects.BaseSearchObject, TransakcijaUpsertRequest, TransakcijaUpsertRequest>, ITransakcijaService
    {
        public TransakcijaService(OftamoloskiCentarContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}