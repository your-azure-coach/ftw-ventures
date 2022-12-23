namespace Ftw.Hotels.HotelBooking.Api.Types
{
    [GraphQLName("RoomAvailability")]
    public class RoomAvailabilityType
    {
        public DateOnly Day { get; set; }

        public bool IsAvailable { get; set; }
    }
}
