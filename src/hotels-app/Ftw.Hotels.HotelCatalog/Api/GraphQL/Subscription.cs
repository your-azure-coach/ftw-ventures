using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.Models;

namespace Ftw.Hotels.HotelCatalog.Api.GraphQL
{
    public class Subscription
    {
        [Subscribe]
        public RoomType roomCapacityChanged([EventMessage] RoomType room) => room;
    }
}
