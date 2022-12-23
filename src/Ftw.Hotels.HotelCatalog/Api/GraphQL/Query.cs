using AutoMapper;
using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Data.Repositories;

namespace Ftw.Hotels.HotelCatalog.Api.GraphQL
{
    public class Query
    {
        [UseFiltering()]
        public async Task<IEnumerable<CountryType>> GetCountriesAsync([Service] IHotelCatalogService service)
            => await service.GetCountriesAsync();

        [UseFiltering()]
        public async Task<IEnumerable<HotelType>> GetHotelsAsync([Service] IHotelCatalogService service)
            => await service.GetHotelsAsync();

        [UseFiltering()]
        public async Task<IEnumerable<RoomType>> GetRoomsAsync([Service] IHotelCatalogService service)
            => await service.GetRoomsAsync();
    }
}
