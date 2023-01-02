using StackExchange.Redis;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.HotelPricing.Api.GraphQL;
using Ftw.Hotels.Common.WebAppBuilderExtensions;

var builder = WebApplication.CreateBuilder(args);

#if DEBUG
    builder.Configuration.ConfigureConfiguration(runLocal: true);
    builder.Services.ConfigureGraphQL(runLocal: true, builder.Configuration, typeof(Query), SchemaNames.Remote.HotelPricing,  "./Api/Federation/RoomPriceExtension.graphql");
#else
    builder.Configuration.ConfigureConfiguration(runLocal: false);
    builder.Services.ConfigureGraphQL(runLocal: false, builder.Configuration, SchemaNames.Remote.HotelPricing, "./Api/Federation/RoomPriceExtension.graphql");
#endif

var app = builder.Build();

app.MapGraphQL();

app.Run();