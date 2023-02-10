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

        public async Task<CountryType> GetCountryByCodeAsync([Service] IHotelCatalogService service, string code)
            => await service.GetCountryByCodeAsync(code);

        [UseFiltering()]
        public async Task<IEnumerable<HotelType>> GetHotelsAsync([Service] IHotelCatalogService service)
            => await service.GetHotelsAsync();

        public async Task<IEnumerable<HotelType>> GetHotelsByNameAsync([Service] IHotelCatalogService service, string name)
            => await service.GetHotelsByNameAsync(name);

        [UseFiltering()]
        public async Task<IEnumerable<RoomType>> GetRoomsAsync([Service] IHotelCatalogService service)
            => await service.GetRoomsAsync();
    }
}
