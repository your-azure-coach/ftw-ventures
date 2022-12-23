using HotChocolate.Subscriptions;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Api.Types;

namespace Ftw.Hotels.HotelCatalog.Api.GraphQL
{
    public class Mutation
    {
        public async Task<RoomType> ChangeRoomCapacity([Service] IHotelCatalogService service, [Service] ITopicEventSender sender, Guid roomId, int newCapacity)
        {
            var result = await service.ChangeRoomCapacityAsync(roomId, newCapacity);
            await sender.SendAsync(nameof(Subscription.roomCapacityChanged), result);
            return result;
        }
    }
}
