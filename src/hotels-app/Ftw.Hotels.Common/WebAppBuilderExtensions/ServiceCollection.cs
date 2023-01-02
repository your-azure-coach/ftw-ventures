using Ftw.Hotels.Common.Constants;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using StackExchange.Redis;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ftw.Hotels.Common.WebAppBuilderExtensions
{
    public static class ServiceCollection
    {
        public static IServiceCollection ConfigureGraphQL(this IServiceCollection services, bool runLocal, IConfigurationBuilder builder, Type queryType, string schemaName, string typeExtensionsFilePath)
        {
            var configuration = builder.Build();
            if (runLocal)
            {
                services
                    .AddGraphQLServer()
                    .AddQueryType(queryType)
                    .InitializeOnStartup()
                    .PublishSchemaDefinition(
                        s => s
                            .SetName(schemaName)
                            .IgnoreRootTypes()
                            .AddTypeExtensionsFromFile(typeExtensionsFilePath));
            }
            else
            {
                services
                    .AddSingleton(ConnectionMultiplexer.Connect(configuration["REDIS:CONNECTIONSTRING"]))
                    .AddGraphQLServer()
                    .AddQueryType(queryType)
                    .InitializeOnStartup()
                    .PublishSchemaDefinition(
                        s => s
                            .SetName(schemaName)
                            .IgnoreRootTypes()
                            .AddTypeExtensionsFromFile(typeExtensionsFilePath)
                            .PublishToRedis(SchemaNames.Remote.HotelPricing, sp => sp.GetRequiredService<ConnectionMultiplexer>()));
            }
            return services;
        }
    }
}
