using Ftw.Hotels.HotelPricing.Api.Types;
using Ftw.Hotels.HotelPricing.Data;
using System;

namespace Ftw.Hotels.HotelPricing.Api.GraphQL
{
    public class RoomPriceDataLoader : BatchDataLoader<Guid, RoomPriceType>
    {
        public RoomPriceDataLoader(IBatchScheduler batchScheduler,   DataLoaderOptions options = null)
            : base(batchScheduler, options)
        { 
        }

        protected override async Task<IReadOnlyDictionary<Guid, RoomPriceType>> LoadBatchAsync(
            IReadOnlyList<Guid> roomIds, 
            CancellationToken cancellationToken)
        {
            var roomPrices = await RoomPriceCalculator.GetMultipleRoomPricesInBatch(roomIds);
            return roomPrices.ToDictionary(rp => rp.RoomId);
        }        
    }
}
