using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelPricing.Api.GraphQL;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("appsettings.json", optional: false);
builder.Configuration.AddJsonFile("appsettings.local.json", optional: true);
builder.Configuration.AddEnvironmentVariables();
#if DEBUG
#else
builder.Configuration.AddAzureAppConfiguration(builder.Configuration["APPCONFIG--CONNECTIONSTRING"]);
#endif

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS--CONNECTIONSTRING"]))
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