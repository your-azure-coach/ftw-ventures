using Microsoft.EntityFrameworkCore;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelCatalog.Api.GraphQL;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;
using Ftw.Hotels.HotelCatalog.Data.Migrations;
using Ftw.Hotels.HotelCatalog.Data.Repositories;
using Ftw.Hotels.Common.WebAppBuilderExtensions;
using Ftw.Hotels.HotelCatalog;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.ApplicationInsights.DependencyCollector;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Azure.Monitor.OpenTelemetry.Exporter;
using OpenTelemetry;

var builder = WebApplication.CreateBuilder(args);

#if DEBUG
    builder.Configuration.ConfigureConfiguration(runLocal: true);
#else
    builder.Configuration.ConfigureConfiguration(runLocal: false);
#endif

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
    .AddInstrumentation(i => {
        i.RenameRootActivity = true;
        i.IncludeDocument = true;
    })
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
    .AddRedisSubscriptions();
#endif
    
builder.Logging.AddOpenTelemetry(
    b => b.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("HotelCatalog")));

var resourceAttributes = new Dictionary<string, object> {
    { "service.name", "hotel-catalog" },
    { "service.namespace", "ftw-ventures" }};

var resourceBuilder = ResourceBuilder.CreateDefault().AddAttributes(resourceAttributes);

builder.Services.AddOpenTelemetryTracing(
    t =>
    {
        t.SetResourceBuilder(resourceBuilder);
        t.AddHttpClientInstrumentation();
        t.AddSqlClientInstrumentation(o => { 
            o.SetDbStatementForText = true;
        });
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

app.MigrateDatabase();
app.UseWebSockets();
app.MapGraphQL();

app.Run();
