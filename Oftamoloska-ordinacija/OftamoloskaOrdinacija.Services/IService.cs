using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public interface IService<T,Tsearch > where Tsearch:class
    {
        Task<PagedResult<T>> Get(Tsearch search = null);
        Task<T>GetById(int id);
    
    }
}
