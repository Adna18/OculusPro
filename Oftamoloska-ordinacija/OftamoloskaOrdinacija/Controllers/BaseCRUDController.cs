﻿using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Services;

namespace OftamoloskaOrdinacija.Controllers
{
    [Route("[controller]")]

    public class BaseCRUDController<T, TSearch,TInsert,TUpdate> : BaseController<T,TSearch> where T : class where TSearch : class
    {
        protected new readonly ICRUDService<T, TSearch,TInsert,TUpdate> _service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TSearch>> logger, ICRUDService<T, TSearch, TInsert, TUpdate> service)
            :base(logger, service)
        {
            _logger = logger;
            _service = service;
        }
        [HttpPost]
        public virtual async Task <T>Insert([FromBody]TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id,update);
        }
       [HttpDelete("{id}")]
        public async virtual Task<T> Delete(int id)
        {
            var result = _service.Delete(id);

            return await result;

        }
    }
}
