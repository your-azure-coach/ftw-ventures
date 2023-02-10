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

#if DEBUG
    builder.Configuration.ConfigureConfiguration(runLocal: true);
#else
    builder.Configuration.ConfigureConfiguration(runLocal: false);
#endif

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
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("HotelPricing")));

builder.Services.AddOpenTelemetryTracing(
    t =>
    {
        t.AddHttpClientInstrumentation();
        t.AddSqlClientInstrumentation();
        t.AddAspNetCoreInstrumentation();
        t.AddHotChocolateInstrumentation();
#if DEBUG
        t.AddConsoleExporter();
#else
        t.AddAzureMonitorTraceExporter(m => m.ConnectionString = builder.Configuration["APPINSIGHTS:CONNECTIONSTRING"]); 
#endif
    }
);

var app = builder.Build();

app.MapGraphQL();

app.Run();