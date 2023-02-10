namespace Ftw.Hotels.HotelCatalog.Api.Types
{
    [GraphQLName("Hotel")]
    public class HotelType
    {
        public Guid Id { get; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int Stars { get; set; }
        public string City { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }

        public int NumberOfRooms { 
            get 
            {
                return Rooms.Count<RoomType>();
            }
        }

        public IEnumerable<RoomType> Rooms { get; set; }

        public CountryType Country { get; set; }
    }
}
