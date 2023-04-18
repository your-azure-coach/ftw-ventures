namespace Ftw.Hotels.HotelPricing.Api.Types
{
    [GraphQLName("RoomPrice")]
    public class RoomPriceType
    {
        [GraphQLIgnore]
        public Guid RoomId { get; set; }
        public double Price { get; set; }

        public double EarlyBirdDiscount { get; set; }   
    }
}
