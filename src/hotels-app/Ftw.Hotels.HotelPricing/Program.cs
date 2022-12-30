using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelPricing.Api.GraphQL;
using Azure.Identity;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("appsettings.json", optional: false);
builder.Configuration.AddJsonFile("appsettings.local.json", optional: true);
builder.Configuration.AddEnvironmentVariables();
#if DEBUG
#else
builder.Configuration.AddAzureAppConfiguration(options =>
{
    var credential = new ChainedTokenCredential(new AzureCliCredential(), new ManagedIdentityCredential("90e944db-c471-486c-a734-3a2d35034121"));
    var uri = new Uri(builder.Configuration["APPCONFIG:URI"]);
    var refreshRate = Convert.ToDouble(builder.Configuration["APPCONFIG:REFRESHRATE_IN_SECONDS"]);

    options.Connect(uri, credential);
    options.ConfigureKeyVault(keyVault => keyVault.SetCredential(credential));
    options.UseFeatureFlags(flagOptions => flagOptions.CacheExpirationInterval = TimeSpan.FromSeconds(refreshRate));
});
#endif

builder.Services
#if DEBUG
#else
    .AddSingleton(ConnectionMultiplexer.Connect(builder.Configuration["REDIS:CONNECTIONSTRING"]))
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