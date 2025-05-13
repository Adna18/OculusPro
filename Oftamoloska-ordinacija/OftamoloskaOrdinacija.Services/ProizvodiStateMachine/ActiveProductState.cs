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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace OftamoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class ActiveProductState : BaseState
    {
        public ActiveProductState(IServiceProvider serviceProvider,OftamoloskiCentarContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }
        public override async Task<Model.Proizvodi> Hide(int id)
        {
            var set = _context.Set<Database.Proizvod>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Proizvodi>(entity);
        }
        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Hide");

            return list;
        }

    }
}
