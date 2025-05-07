using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace OftamoloskaDodatni.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<Database.Korisnik, Model.Korisnik>();
            CreateMap<Database.TipKorisnika, Model.TipKorisnika>();


        }
    }
}
