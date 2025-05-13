using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public interface ICRUDService<T, Tsearch, TInsert, TUpdate> : IService<T, Tsearch> where Tsearch : class
    {
        Task<T> Insert(TInsert insert);
        Task<T> Update(int id,TUpdate update);
       Task<T> Delete(int id);

    }

}
