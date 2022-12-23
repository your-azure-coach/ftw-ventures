using AutoMapper;
using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.Repositories;

namespace Ftw.Hotels.HotelCatalog.Api.Services
{
    public class HotelCatalogService : IHotelCatalogService
    {
        private readonly IMapper _mapper;
        private readonly IHotelCatalogRepository _repository;

        public HotelCatalogService(IHotelCatalogRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper= mapper;
        }
        public async Task<RoomType> ChangeRoomCapacityAsync(Guid roomId, int newCapacity)
        {
            var room = await _repository.ChangeRoomCapacity(roomId, newCapacity);
            return _mapper.Map<RoomType>(room);
        }

        public async Task<IEnumerable<CountryType>> GetCountriesAsync()
        {
            var countries = await _repository.GetCountriesAsync();
            return _mapper.Map<IEnumerable<CountryType>>(countries);
        }

        public async Task<IEnumerable<HotelType>> GetHotelsAsync()
        {
            var hotels = await _repository.GetHotelsAsync();
            return _mapper.Map<IEnumerable<HotelType>>(hotels);
        }

        public async Task<IEnumerable<RoomType>> GetRoomsAsync()
        {
            var rooms = await _repository.GetRoomsAsync();
            return _mapper.Map<IEnumerable<RoomType>>(rooms);             
        }
    }
}
