using Ftw.Hotels.HotelPricing.Api.Types;
using System;

namespace Ftw.Hotels.HotelPricing.Data
{
    //Static class not a good practise, just for simulation purpose
    public static class RoomPriceCalculator
    {
        private static Random _random = new Random();
        private static HttpClient ioSimulator = new HttpClient();

        public static async Task<List<RoomPriceType>> GetMultipleRoomPricesInBatch(IReadOnlyList<Guid> roomIds)
        {
            //Simulate call to Google's API in batch
            await ioSimulator.GetAsync("https://www.google.com");

            var roomPrices = new List<RoomPriceType>();
            foreach (var roomId in roomIds)
            {
                roomPrices.Add(new RoomPriceType
                {
                    RoomId = roomId,
                    Price = Math.Round(_random.NextDouble() * (235 - 95) + 95, 2),
                    EarlyBirdDiscount = Math.Round(_random.NextDouble() * (0.2 - 0.01) + 0.01, 2)
                });
            }
            return roomPrices;
        }

        public static async Task<RoomPriceType> GetSingleRoomPrice(Guid roomId)
        {
            //Simulate call to Google's API
            await ioSimulator.GetAsync("https://www.google.com");

            return new RoomPriceType {
                RoomId = roomId,
                Price = Math.Round(_random.NextDouble() * (235 - 95) + 95, 2),
                EarlyBirdDiscount = Math.Round(_random.NextDouble() * (0.2 - 0.01) + 0.01, 2)
            };
        }
    }
}
