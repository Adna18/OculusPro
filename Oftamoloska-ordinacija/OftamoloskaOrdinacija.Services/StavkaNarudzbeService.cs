using AutoMapper;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
//using Microsoft.AspNetCore.Http;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace OftamoloskaOrdinacija.Services
{
    public class StavkaNarudzbeService : BaseCRUDService<Model.StavkaNarudzbe, Database.StavkaNarudzbe, StavkaNarudzbeSearchObject, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>, IStavkaNarudzbeService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public StavkaNarudzbeService(OftamoloskiCentarContext context, IHttpContextAccessor httpContextAccessor, IMapper mapper)
            : base(context, mapper)
        {
           
           _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<StavkaNarudzbe> AddFilter(IQueryable<StavkaNarudzbe> query, StavkaNarudzbeSearchObject? search = null)
        {
            if (search?.NarudzbaId != 0)
            {
                query = query.Where(x => x.NarudzbaId == search.NarudzbaId);
            }

            return base.AddFilter(query, search);
        }

    }
}
