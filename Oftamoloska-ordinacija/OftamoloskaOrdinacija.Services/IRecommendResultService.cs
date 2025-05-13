using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services
{
    public interface IRecommendResultService : ICRUDService<Model.RecommendResult, BaseSearchObject, RecommendResultUpsertRequest, RecommendResultUpsertRequest>
    {
        Task<List<Model.RecommendResult>> TrainProductsModel();
        Task DeleteAllRecommendation();
    }
}
