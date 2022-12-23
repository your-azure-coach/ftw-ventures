using Ftw.Hotels.HotelPricing.Api.Types;

namespace Ftw.Hotels.HotelPricing.Api.GraphQL
{
    public class Query
    {
        private static Random _random = new Random();
        public RoomPriceType GetRoomPrice(Guid roomId)
        {
            return new RoomPriceType {
                Price = Math.Round(_random.NextDouble() * (235 - 95) + 95, 2),
                EarlyBirdDiscount = Math.Round(_random.NextDouble() * (0.2 - 0.01) + 0.01, 2)
            };
        }
    }
}
