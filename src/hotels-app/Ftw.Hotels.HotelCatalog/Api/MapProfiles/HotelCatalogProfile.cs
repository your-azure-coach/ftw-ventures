using AutoMapper;
using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Api.MapProfiles
{
    public class HotelCatalogProfile: Profile
    {
        public HotelCatalogProfile()
        {
            CreateMap<Country, CountryType>();
            CreateMap<Hotel, HotelType>();
            CreateMap<Room, RoomType>();
        }
    }
}
