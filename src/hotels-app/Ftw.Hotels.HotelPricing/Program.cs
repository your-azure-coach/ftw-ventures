using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelPricing.Api.GraphQL;

var builder = WebApplication.CreateBuilder(args);

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS_CONNECTIONSTRING"]))
#endif
    .AddGraphQLServer()
    .AddQueryType<Query>()
    .InitializeOnStartup() 
#if DEBUG
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelPricing).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomPriceExtension.graphql"));
#else
    .PublishSchemaDefinition(
        s => s.SetName(SchemaNames.Remote.HotelPricing).IgnoreRootTypes().AddTypeExtensionsFromFile("./Api/Federation/RoomPriceExtension.graphql").PublishToRedis(SchemaNames.Remote.HotelPricing, sp => sp.GetRequiredService<ConnectionMultiplexer>())); 
#endif

var app = builder.Build();

app.MapGraphQL();

app.Run();