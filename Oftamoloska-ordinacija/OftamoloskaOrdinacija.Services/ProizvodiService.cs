using AutoMapper;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
using OftamoloskaOrdinacija.Services.ProizvodiStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public class ProizvodiService : BaseCRUDService<Model.Proizvodi, Database.Proizvod, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>, IProizvodiService
    {
        public BaseState _baseState { get; set; }

        public ProizvodiService(BaseState baseState,OftamoloskiCentarContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }
        public override Task<Model.Proizvodi> Insert(ProizvodiInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        public override async Task<Model.Proizvodi> Update(int id, ProizvodiUpdateRequest update)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public override Task<Model.Proizvodi> Delete(int id)
        {
            return base.Delete(id);
        }

        public async Task<Model.Proizvodi> Activate(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Model.Proizvodi> Hide(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }
        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");

            return await state.AllowedActions();
        }

        public override IQueryable<Database.Proizvod> AddFilter(IQueryable<Database.Proizvod> query, ProizvodiSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS) || x.Sifra.Contains(search.FTS));
            }

            if (!string.IsNullOrWhiteSpace(search?.Sifra))
            {
                filteredQuery = filteredQuery.Where(x => x.Sifra == search.Sifra);
            }

            return filteredQuery;
        }


    }
}
