
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.SuperGraph.Api.GraphQL;
using static HotChocolate.ErrorCodes;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient(SchemaNames.Local.HotelWeather,  c => c.BaseAddress = new Uri(builder.Configuration["API_HOTELWEATHER_URI"]));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelCatalog, c => c.BaseAddress = new Uri(builder.Configuration["API_HOTELCATALOG_URI"]));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelPricing, c => c.BaseAddress = new Uri(builder.Configuration["API_HOTELPRICING_URI"]));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelBooking, c => c.BaseAddress = new Uri(builder.Configuration["API_HOTELBOOKING_URI"]));

if (builder.Environment.IsDevelopment())
{
    builder.Services
        .AddGraphQL(SchemaNames.Local.HotelWeather)
        .AddQueryType<Query>()
        .AddGraphQLServer()
        .AddRemoteSchema(SchemaNames.Remote.HotelCatalog)
        .AddRemoteSchema(SchemaNames.Remote.HotelPricing)
        .AddRemoteSchema(SchemaNames.Remote.HotelBooking)
        .AddLocalSchema(SchemaNames.Local.HotelWeather)
        .AddTypeExtensionsFromFile("./Api/Stitching/HotelWeatherExtension.graphql");
}
else
{
    builder.Services.AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS_CONNECTIONSTRING"]));
    builder.Services
        .AddGraphQL(SchemaNames.Local.HotelWeather)
        .AddQueryType<Query>()
        .AddGraphQLServer()
        .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelCatalog, sp => sp.GetRequiredService<ConnectionMultiplexer>())
        .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelPricing, sp => sp.GetRequiredService<ConnectionMultiplexer>())
        .AddRemoteSchemasFromRedis(SchemaNames.Remote.HotelBooking, sp => sp.GetRequiredService<ConnectionMultiplexer>())
        .AddLocalSchema(SchemaNames.Local.HotelWeather)
        .AddTypeExtensionsFromFile("./Api/Stitching/HotelWeatherExtension.graphql");
}

var app = builder.Build();

app.UseWebSockets();
app.MapGraphQL();

app.Run();