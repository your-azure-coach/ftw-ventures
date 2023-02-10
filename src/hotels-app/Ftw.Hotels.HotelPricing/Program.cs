using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelPricing.Api.GraphQL;
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
    .AddInstrumentation(i => {
        i.RenameRootActivity = true;
        i.IncludeDocument = true;
    })
    .AddQueryType<Query>()
    .InitializeOnStartup()
#if DEBUG
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelPricing).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomPriceExtension.graphql"));
#else
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelPricing).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomPriceExtension.graphql").PublishToRedis(SchemaNames.Remote.HotelPricing, sp => sp.GetRequiredService<ConnectionMultiplexer>())); 
#endif

builder.Logging.AddOpenTelemetry(
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hotel-pricing")));

builder.Services.ConfigureLogging(builder.Configuration, runLocal, "hotel-pricing");

var app = builder.Build();

app.MapGraphQL();

app.Run();