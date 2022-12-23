using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelBooking.Api.GraphQL;

var builder = WebApplication.CreateBuilder(args);

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS_CONNECTIONSTRING"]))
#endif
    .AddGraphQLServer()
    .InitializeOnStartup()
    .AddQueryType<Query>()
#if DEBUG
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelBooking).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomAvailabilityExtension.graphql"));
#else
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelBooking).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomAvailabilityExtension.graphql").PublishToRedis(SchemaNames.Remote.HotelBooking, sp => sp.GetRequiredService<ConnectionMultiplexer>()));
#endif

var app = builder.Build();

app.MapGraphQL();

app.Run();