using Ftw.Hotels.HotelCatalog.Api.Types;

namespace Ftw.Hotels.HotelCatalog.Api.Services
{
    public interface IHotelCatalogService
    {
        public Task<IEnumerable<CountryType>> GetCountriesAsync();
        public Task<IEnumerable<HotelType>> GetHotelsAsync();
        public Task<IEnumerable<RoomType>> GetRoomsAsync();
        public Task<RoomType> ChangeRoomCapacityAsync(Guid roomId, int newCapacity);
    }
}
