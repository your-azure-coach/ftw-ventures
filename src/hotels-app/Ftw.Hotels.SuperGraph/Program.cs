
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.SuperGraph.Api.GraphQL;
using Ftw.Hotels.Common.WebAppBuilderExtensions;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Azure.Monitor.OpenTelemetry.Exporter;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using OpenTelemetry;
using Microsoft.ApplicationInsights;

var builder = WebApplication.CreateBuilder(args);

var runLocal = false;

#if DEBUG
runLocal = true;
#endif

builder.Configuration.ConfigureConfiguration(runLocal);

builder.Logging.AddOpenTelemetry(
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hotel-supergraph")));

builder.Services.ConfigureLogging(builder.Configuration, runLocal, "hotel-supergraph");

builder.Services.AddHttpClient(SchemaNames.Local.HotelWeather,  c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTEL-WEATHER:URI"]}"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelCatalog, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTEL-CATALOG:URI"]}/graphql/"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelPricing, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTEL-PRICING:URI"]}/graphql/"));
builder.Services.AddHttpClient(SchemaNames.Remote.HotelBooking, c => c.BaseAddress = new Uri($"{builder.Configuration["API:HOTEL-BOOKING:URI"]}/graphql/"));

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS:CONNECTIONSTRING"]))
#endif
    .AddGraphQL(SchemaNames.Local.HotelWeather)
    .AddQueryType<Query>()
    .AddGraphQLServer()
    .AddInstrumentation(i => i.IncludeDocument = true)
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
    .IgnoreRootTypes(SchemaNames.Local.HotelWeather)
    .AddTypeExtensionsFromFile("./Api/Stitching/HotelWeatherExtension.graphql");

var app = builder.Build();


app.UseWebSockets();
app.MapGraphQL();
app.UseStaticFiles();
app.Run();