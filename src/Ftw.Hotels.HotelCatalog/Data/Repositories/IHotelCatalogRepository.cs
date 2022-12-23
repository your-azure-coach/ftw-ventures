using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Data.Repositories
{
    public interface IHotelCatalogRepository
    {
        Task<IEnumerable<Country>> GetCountriesAsync();
        Task<IEnumerable<Hotel>> GetHotelsAsync();
        Task<IEnumerable<Room>> GetRoomsAsync();

        Task<Room> ChangeRoomCapacity(Guid roomId, int newCapacity);
    }
}
