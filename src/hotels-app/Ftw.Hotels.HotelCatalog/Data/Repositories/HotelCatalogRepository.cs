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
            var room = await _dbContext.Rooms.SingleAsync(r => r.Id == roomId);
            room.Capacity = newCapacity;            
            await _dbContext.SaveChangesAsync();
            return room;
        }

        public async Task<Country> GetCountryByCodeAsync(string code)
        {
            return await _dbContext.Countries.Include("Hotels").Include("Hotels.Rooms").SingleAsync(c => c.Code == code);
        }

        public async Task<IEnumerable<Hotel>> GetHotelsByNameAsync(string name)
        {
            return await _dbContext.Hotels.Where(h => h.Name.Contains(name, StringComparison.OrdinalIgnoreCase)).Include("Country").Include("Rooms").ToListAsync();
        }

        public async Task<Room> GetRoomAsync(Guid id)
        {
            return await _dbContext.Rooms.Include("Hotel").Include("Hotel.Country").SingleAsync(r => r.Id == id);
        }
    }
}
