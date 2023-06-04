using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.Models;
using HotChocolate.Subscriptions;
using static Microsoft.ApplicationInsights.MetricDimensionNames.TelemetryContext;
using System.Threading;
using HotChocolate.Execution;

namespace Ftw.Hotels.HotelCatalog.Api.GraphQL
{
    public class Subscription
    {
        [Subscribe]
        public RoomType OnRoomCapacityChanged([EventMessage] RoomType room) => room;



        [Subscribe(With = nameof(OnRoomTemperatureChangedSubscription))]
        public RoomTemperature OnRoomTemperatureChanged([EventMessage] RoomTemperature roomTemperature) => roomTemperature;

        public ValueTask<ISourceStream<RoomTemperature>> OnRoomTemperatureChangedSubscription([Service] ITopicEventReceiver receiver, Guid roomId)
        {
            var topicName = $"{nameof(Subscription.OnRoomTemperatureChanged)}_{roomId}";
            return receiver.SubscribeAsync<RoomTemperature>(topicName);
        }
    }
}
