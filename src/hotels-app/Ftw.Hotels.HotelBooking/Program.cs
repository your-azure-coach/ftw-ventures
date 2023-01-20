using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelBooking.Api.GraphQL;
using Ftw.Hotels.Common.WebAppBuilderExtensions;
using Ftw.Hotels.Common.GraphQLExtensions;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;

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
    .AddApplicationInsightsTelemetry(options: new ApplicationInsightsServiceOptions { ConnectionString = builder.Configuration["APPINSIGHTS:CONNECTIONSTRING"] })
    .AddGraphQLServer()
    .AddDiagnosticEventListener<ApplicationInsightsDiagnosticListener>()
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