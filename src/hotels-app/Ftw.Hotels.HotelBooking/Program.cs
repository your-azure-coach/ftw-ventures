using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelBooking.Api.GraphQL;
using Ftw.Hotels.Common.WebAppBuilderExtensions;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Azure.Monitor.OpenTelemetry.Exporter;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using OpenTelemetry;

var builder = WebApplication.CreateBuilder(args);

var runLocal = false;

#if DEBUG
runLocal = true;
#endif

builder.Configuration.ConfigureConfiguration(runLocal);

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS:CONNECTIONSTRING"]))
#endif
    .AddGraphQLServer()
    .AddInstrumentation()
    .InitializeOnStartup()
    .AddQueryType<Query>()
#if DEBUG
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelBooking).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomAvailabilityExtension.graphql"));
#else
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelBooking).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomAvailabilityExtension.graphql").PublishToRedis(SchemaNames.Remote.HotelBooking, sp => sp.GetRequiredService<ConnectionMultiplexer>()));
#endif

builder.Logging.AddOpenTelemetry(
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hotel-catalog")));

builder.Services.ConfigureLogging(builder.Configuration, runLocal, "hotel-catalog");

var app = builder.Build();

app.MapGraphQL();

app.Run();