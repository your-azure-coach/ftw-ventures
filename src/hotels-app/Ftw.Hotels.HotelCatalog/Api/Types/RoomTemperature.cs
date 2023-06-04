namespace Ftw.Hotels.HotelCatalog.Api.Types
{
    [GraphQLName("RoomTemperature")]
    public class RoomTemperature
    {
        public Guid RoomId { get; set; }
        public double Temperature { get; set; }
    }
}
