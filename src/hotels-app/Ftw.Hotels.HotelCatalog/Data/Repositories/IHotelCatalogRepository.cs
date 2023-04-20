using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Data.Repositories
{
    public interface IHotelCatalogRepository
    {
        Task<IEnumerable<Country>> GetCountriesAsync();
        Task<Country> GetCountryByCodeAsync(string code);
        Task<IEnumerable<Hotel>> GetHotelsAsync();

        Task<IEnumerable<Hotel>> GetHotelsByNameAsync(string name);
        Task<IEnumerable<Room>> GetRoomsAsync();
        Task<Room> GetHotelRoomByNumber(Guid hotelId, string roomNumber);
        Task<Room> GetRoomAsync(Guid id);
        Task<Room> ChangeRoomCapacity(Guid roomId, int newCapacity);
    }
}
