﻿using AutoMapper;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public class BaseCRUDService<T, TDb, TSearch,TInsert,TUpdate> : BaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(OftamoloskiCentarContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public virtual async Task BeforeInsert(TDb entity,TInsert insert)
        {

        }
        public virtual async Task<T>Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();
            TDb entity = _mapper.Map<TDb>(insert);
            set.Add(entity);
            await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Update(int id,TUpdate update)
        {
            var set = _context.Set<TDb>();
            var entity = await set.FindAsync(id);
            _mapper.Map(update, entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Delete(int id)
        {
            var set = _context.Set<TDb>();

            foreach (var item in _context.OmiljeniProizvodis)
            {
                if (id == item.ProizvodId)
                {
                    _context.OmiljeniProizvodis.Remove(item);
                }
            }

            foreach (var item in _context.StavkaNarudzbes)
            {
                if (id == item.ProizvodId)
                {
                    _context.StavkaNarudzbes.Remove(item);
                }
            }

            foreach (var item in _context.Recenzijas)
            {
                if (id == item.ProizvodId)
                {
                    _context.Recenzijas.Remove(item);
                }
            }

            foreach (var item in _context.Dojams)
            {
                if (id == item.ProizvodId)
                {
                    _context.Dojams.Remove(item);
                }
            }

            foreach (var item in _context.RecommendResults)
            {
                if (id == item.ProizvodId)
                {
                    _context.RecommendResults.Remove(item);
                }
                else if (id == item.PrviProizvodId)
                {
                    _context.RecommendResults.Remove(item);
                }
                else if (id == item.DrugiProizvodId)
                {
                    _context.RecommendResults.Remove(item);
                }
                else if (id == item.TreciProizvodId)
                {
                    _context.RecommendResults.Remove(item);
                }
            }



            var entity = await set.FindAsync(id);

            set.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

    }
}

