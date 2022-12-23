namespace Ftw.Hotels.HotelPricing.Api.Types
{
    [GraphQLName("RoomPrice")]
    public class RoomPriceType
    {
        public double Price { get; set; }

        public double EarlyBirdDiscount { get; set; }   
    }
}
