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
using Ftw.Hotels.Common.GraphQLExtensions;

/*
    TODO's
    - Add Dataloaders instead of simple resolvers
    - Only retrieve parents / childs when requested  
    - Add Fluent Validations
    - Add Testing
 */

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
    .AddApplicationInsightsTelemetry(options: new ApplicationInsightsServiceOptions { ConnectionString = builder.Configuration["APPINSIGHTS:CONNECTIONSTRING"] })
    .AddGraphQLServer()
    .AddDiagnosticEventListener<ApplicationInsightsDiagnosticListener>()
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
    




var app = builder.Build();

app.MigrateDatabase();
app.UseWebSockets();
app.MapGraphQL();

app.Run();
