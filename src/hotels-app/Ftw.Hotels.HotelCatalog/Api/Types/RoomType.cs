namespace Ftw.Hotels.HotelCatalog.Api.Types
{
    [GraphQLName("Room")]
    public class RoomType
    {
        public Guid Id { get; set; }
        public string Number { get; set; }
        public int Floor { get; set; }
        public int Capacity { get; set; }

        public HotelType Hotel { get; set; }
    }
}
