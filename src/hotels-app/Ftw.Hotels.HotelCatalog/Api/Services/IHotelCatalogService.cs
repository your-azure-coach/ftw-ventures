using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Api.Services
{
    public interface IHotelCatalogService
    {
        public Task<IEnumerable<CountryType>> GetCountriesAsync();
        public Task<CountryType> GetCountryByCodeAsync(string code);
        public Task<IEnumerable<HotelType>> GetHotelsAsync();
        public Task<IEnumerable<HotelType>> GetHotelsByNameAsync(string name);
        public Task<IEnumerable<RoomType>> GetRoomsAsync();
        public Task<RoomType> GetRoomAsync(Guid id);
        public Task<RoomType> ChangeRoomCapacityAsync(Guid roomId, int newCapacity);
    }
}
