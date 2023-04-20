using Ftw.Hotels.HotelPricing.Api.Types;
using Ftw.Hotels.HotelPricing.Data;
using System;

namespace Ftw.Hotels.HotelPricing.Api.GraphQL
{
    public class Query
    {
        public async Task<RoomPriceType> GetRoomPrice(Guid roomId, RoomPriceDataLoader dataloader, bool useDataLoader = false, bool simulateException = false)
        {
            if (simulateException)
                throw new Exception("Failed to retrieve room price, because of simulated exception.");
            
            if (useDataLoader)
                return await dataloader.LoadAsync(roomId);

            return await RoomPriceCalculator.GetSingleRoomPrice(roomId);
        } 
    }
}
