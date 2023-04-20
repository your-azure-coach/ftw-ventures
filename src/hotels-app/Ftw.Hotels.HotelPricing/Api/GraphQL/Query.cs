using Ftw.Hotels.HotelPricing.Api.Types;
using Ftw.Hotels.HotelPricing.Data;
using System;

namespace Ftw.Hotels.HotelPricing.Api.GraphQL
{
    public class Query
    {
        public async Task<RoomPriceType> GetRoomPrice(Guid roomId, RoomPriceDataLoader dataloader, bool useDataLoader = false)
        {
            if(useDataLoader)
                return await dataloader.LoadAsync(roomId);

            return await RoomPriceCalculator.GetSingleRoomPrice(roomId);
        } 
    }
}
