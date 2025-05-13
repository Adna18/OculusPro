using AutoMapper;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
//using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
//using Microsoft.AspNetCore.Http;
using System.Security.Claims;
//using Microsoft.AspNetCore.Http;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Http;



namespace OftamoloskaOrdinacija.Services
{
    public class TerminService : BaseCRUDService<Model.Termin, Database.Termin, TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>, ITerminService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public TerminService(OftamoloskiCentarContext context,IHttpContextAccessor httpContextAccessor, IMapper mapper)
            : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<Database.Termin> AddFilter(IQueryable<Database.Termin> query, TerminSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Doktor != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikIdDoktorNavigation.Username.StartsWith(search.Doktor.ToString()));
            }
            if (search.Pacijent != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikIdPacijentNavigation.Username.StartsWith(search.Pacijent.ToString()));
            }
            if (search.Datum != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum.Value.Day == search.Datum.Value.Day &&
                                                        x.Datum.Value.Month == search.Datum.Value.Month &&
                                                        x.Datum.Value.Year == search.Datum.Value.Year);
            }
            return filteredQuery;
        }

        public override Task<Model.Termin> Insert(TerminInsertRequest insert)
        {
            if (!insert.Datum.HasValue)
            {
                throw new ArgumentException("Datum ne smije biti null.");
            }

            if (insert.Datum.Value.Hour < 8 || insert.Datum.Value.Hour > 20)
            {
                throw new ArgumentException("Sati moraju biti između 8 i 20.");
            }

            DateTime currentDate = DateTime.Now.Date;
            if (insert.Datum.Value.Date <= currentDate)
            {
                throw new ArgumentException("Ne možete zakazati termin za trenutni dan ili dane unazad.");
            }

            return base.Insert(insert);
        }
    }

}