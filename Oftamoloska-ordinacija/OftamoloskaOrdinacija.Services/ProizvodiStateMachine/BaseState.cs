﻿using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using OftamoloskaOrdinacija.Model;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace OftamoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class BaseState
    {
        protected OftamoloskiCentarContext _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, OftamoloskiCentarContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }
        public virtual Task<Model.Proizvodi>Insert(ProizvodiInsertRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Update(int id,ProizvodiUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Hide(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Delete(int id)
        {
            throw new UserException("Not allowed");
        }
        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialProductState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftProductState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveProductState>();
                    break;

                default:
                    throw new UserException("Not allowed");
            }
        }

    }
}
