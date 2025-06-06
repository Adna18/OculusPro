﻿using AutoMapper;
using Microsoft.EntityFrameworkCore;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public class BaseService<T,TDb,TSearch>:IService<T,TSearch>where TDb:class where T:class where TSearch:BaseSearchObject
    {
        protected OftamoloskiCentarContext _context;
        protected IMapper _mapper { get; set; }
        public BaseService(OftamoloskiCentarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> Get(TSearch? search=null)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();

            query = AddFilter(query, search);
            query = AddInclude(query, search);


            result.Count = await query.CountAsync();

            if (search?.Page.HasValue==true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }
            var list = await query.ToListAsync();
            var tmp= _mapper.Map<List<T>>(list);
            result.Result = tmp;
            return result;
        }
        public virtual IQueryable <TDb>AddFilter(IQueryable<TDb>query,TSearch? serach = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? serach = null)
        {
            return query;
        }
        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
    }
}
