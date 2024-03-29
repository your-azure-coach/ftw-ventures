using Microsoft.EntityFrameworkCore;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelCatalog.Api.GraphQL;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;
using Ftw.Hotels.HotelCatalog.Data.Migrations;
using Ftw.Hotels.HotelCatalog.Data.Repositories;
using Ftw.Hotels.Common.WebAppBuilderExtensions;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Azure.Monitor.OpenTelemetry.Exporter;
using OpenTelemetry;
using Microsoft.ApplicationInsights;
using Ftw.Hotels.HotelCatalog.IoT;

var builder = WebApplication.CreateBuilder(args);

var runLocal = false;

#if DEBUG
    runLocal= true;
#endif

builder.Configuration.ConfigureConfiguration(runLocal);

builder.Logging.AddOpenTelemetry(
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("hotel-catalog")));

builder.Services.ConfigureLogging(builder.Configuration, runLocal, "hotel-catalog");
builder.Services.AddHostedService<RoomTemperatureGeneratorHostedService>();

builder.Services
#if DEBUG
    .AddDbContextFactory<HotelCatalogDbContext>(dbContextOptions => dbContextOptions.UseInMemoryDatabase("HotelCatalog"))
#else
    .AddDbContextFactory<HotelCatalogDbContext>(dbContextOptions => dbContextOptions.UseSqlServer(builder.Configuration["SQL:APP-HOTELS:CONNECTIONSTRING"]))
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS:CONNECTIONSTRING"]))
#endif
    .AddScoped<IHotelCatalogRepository, HotelCatalogRepository>()
    .AddScoped<IHotelCatalogService, HotelCatalogService>()
    .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies())
    .AddGraphQLServer()
    .AddInstrumentation(i => i.IncludeDocument = true)
    .AddFiltering()
    .AddQueryType<Query>()
    .AddMutationType<Mutation>()
    .AddSubscriptionType<Subscription>()
#if DEBUG
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelCatalog))
    .AddInMemorySubscriptions();
#else
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelCatalog).PublishToRedis(SchemaNames.Remote.HotelCatalog, sp => sp.GetRequiredService<ConnectionMultiplexer>()))
    .AddRedisSubscriptions(sp => sp.GetRequiredService<ConnectionMultiplexer>());
#endif

builder.Services.AddHttpResponseFormatter<ErrorHandlingExtension>();

var app = builder.Build();

app.MigrateDatabase();
app.UseWebSockets();
app.MapGraphQL();

app.Run();
