using Microsoft.EntityFrameworkCore;
using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelCatalog.Api.GraphQL;
using Ftw.Hotels.HotelCatalog.Api.Services;
using Ftw.Hotels.HotelCatalog.Data.DbContexts;
using Ftw.Hotels.HotelCatalog.Data.Migrations;
using Ftw.Hotels.HotelCatalog.Data.Repositories;

/*
    TODO's
    - Add Dataloaders instead of simple resolvers
    - Only retrieve parents / childs when requested  
    - Add Fluent Validations
    - Add Testing
 */

var builder = WebApplication.CreateBuilder(args);

builder.Services
#if DEBUG
    .AddDbContextFactory<HotelCatalogDbContext>(dbContextOptions => dbContextOptions.UseInMemoryDatabase("HotelCatalog"))
#else
    .AddDbContextFactory<HotelCatalogDbContext>(dbContextOptions => dbContextOptions.UseSqlServer(builder.Configuration["SQL_CONNECTIONSTRING"]))
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS_CONNECTIONSTRING"]))
#endif
    .AddScoped<IHotelCatalogRepository, HotelCatalogRepository>()
    .AddScoped<IHotelCatalogService, HotelCatalogService>()
    .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies())
    .AddGraphQLServer()
    .InitializeOnStartup()
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
