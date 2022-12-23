using Microsoft.EntityFrameworkCore;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;
using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Data.Repositories
{
    public class HotelCatalogRepository : IHotelCatalogRepository
    {
        private readonly HotelCatalogDbContext _dbContext;

        public HotelCatalogRepository(HotelCatalogDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<IEnumerable<Country>> GetCountriesAsync()
        {
            return await _dbContext.Countries.Include("Hotels").Include("Hotels.Rooms").ToListAsync();
        }

        public async Task<IEnumerable<Hotel>> GetHotelsAsync()
        {
            return await _dbContext.Hotels.Include("Country").Include("Rooms").OrderBy(h => h.Stars).ToListAsync();
        }

        public async Task<IEnumerable<Room>> GetRoomsAsync()
        {
            return await _dbContext.Rooms.Include("Hotel").Include("Hotel.Country").OrderBy(r => r.Hotel.Name).ThenBy(r => r.Number).ToListAsync();
        }

        public async Task<Room> ChangeRoomCapacity(Guid roomId, int newCapacity)
        {
            var room = _dbContext.Rooms.Single(r => r.Id == roomId);
            room.Capacity = newCapacity;            
            await _dbContext.SaveChangesAsync();
            return room;
        } 
    }
}
