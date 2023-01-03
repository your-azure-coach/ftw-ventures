
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.SuperGraph.Api.GraphQL;
using static HotChocolate.ErrorCodes;
using Ftw.Hotels.Common.WebAppBuilderExtensions;

var builder = WebApplication.CreateBuilder(args);

#if DEBUG
    builder.Configuration.ConfigureConfiguration(runLocal: true);
#else
    builder.Configuration.ConfigureConfiguration(runLocal: false);
#endif

builder.Services.AddHttpClient(SchemaNames.Local.HotelWeather,  c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTELWEATHER:URI"]}"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelCatalog, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTELCATALOG:URI"]}/graphql/"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelPricing, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTELPRICING:URI"]}/graphql/"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelBooking, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTELBOOKING:URI"]}/graphql/"));

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS:CONNECTIONSTRING"]))
#endif
    .AddGraphQL(SchemaNames.Local.HotelWeather)
    .AddQueryType<Query>()
    .AddGraphQLServer()
#if DEBUG
    .AddRemoteSchema(SchemaNames.Remote.HotelCatalog)
    .AddRemoteSchema(SchemaNames.Remote.HotelPricing)
    .AddRemoteSchema(SchemaNames.Remote.HotelBooking)
#else
    .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelCatalog, sp => sp.GetRequiredService<ConnectionMultiplexer>())
    .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelPricing, sp => sp.GetRequiredService<ConnectionMultiplexer>())
    .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelBooking, sp => sp.GetRequiredService<ConnectionMultiplexer>())
#endif
    .AddLocalSchema(SchemaNames.Local.HotelWeather)
    .AddTypeExtensionsFromFile("./Api/Stitching/HotelWeatherExtension.graphql");

var app = builder.Build();

app.UseWebSockets();
app.MapGraphQL();

app.Run();