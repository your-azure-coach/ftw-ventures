using Ftw.Hotels.HotelCatalog.Api.GraphQL;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Api.Types;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;
using Ftw.Hotels.HotelCatalog.Data.Models;
using GreenDonut;
using HotChocolate.Subscriptions;
using System;

namespace Ftw.Hotels.HotelCatalog.IoT
{
    public class RoomTemperatureGeneratorHostedService : IHostedService
    {
        private readonly ITopicEventSender _sender;
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public RoomTemperatureGeneratorHostedService(IServiceScopeFactory serviceScopeFactory, ITopicEventSender sender)
        {
            _sender = sender;
            _serviceScopeFactory = serviceScopeFactory;
        }
        public Task StartAsync(CancellationToken cancellationToken)
        {
            Task.Run(async () =>
            {
                Random random = new Random();
                while (!cancellationToken.IsCancellationRequested)
                {
                    using (var scope = _serviceScopeFactory.CreateScope())
                    {
                        IHotelCatalogService hotelCatalogService = scope.ServiceProvider.GetRequiredService<IHotelCatalogService>();

                        var rooms = await hotelCatalogService.GetRoomsAsync();
                        foreach (var room in rooms)
                        {
                            var roomTemperature = new RoomTemperature
                            {
                                RoomId = room.Id,
                                Temperature = random.NextDouble() * (21 - 20) + 20
                            };
                            var topicName = $"{nameof(Subscription.OnRoomTemperatureChanged)}_{roomTemperature.RoomId}";
                            await _sender.SendAsync(topicName, roomTemperature);
                        };
                    }
                    Thread.Sleep(TimeSpan.FromSeconds(2));
                }
            });

            return Task.CompletedTask;
         }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}
