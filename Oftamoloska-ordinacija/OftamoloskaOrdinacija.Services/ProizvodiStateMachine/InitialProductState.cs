using AutoMapper;
using Microsoft.EntityFrameworkCore;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class InitialProductState:BaseState
    {
        public InitialProductState(IServiceProvider serviceProvider,OftamoloskiCentarContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }

      public override async Task<Proizvodi>Insert(ProizvodiInsertRequest request)
        {
            var set = _context.Set<Database.Proizvod>();
            var entity = _mapper.Map<Database.Proizvod>(request);

            entity.StateMachine = "draft";
            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Proizvodi>(entity);
        }
        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
