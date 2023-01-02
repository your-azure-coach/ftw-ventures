using Azure.Identity;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ftw.Hotels.Common.WebAppBuilder
{
    public static class Configuration
    {
        public static IConfigurationBuilder ConfigureConfiguration(this IConfigurationBuilder builder, bool runLocal)
        {
            builder.AddJsonFile("appsettings.json", optional: false);
            if (runLocal)
            {
                builder.AddJsonFile("appsettings.local.json", optional: true);
            }
            else
            {
                builder.AddEnvironmentVariables();
                var configuration = builder.Build();
                builder.AddAzureAppConfiguration(options =>
                {
                    var credential = new ChainedTokenCredential(new AzureCliCredential(), new ManagedIdentityCredential());
                    var uri = new Uri(configuration["APPCONFIG:URI"]);
                    var refreshRate = Convert.ToDouble(configuration["APPCONFIG:REFRESHRATE_IN_SECONDS"]);

                    options.Connect(uri, credential);
                    options.ConfigureKeyVault(keyVault => keyVault.SetCredential(credential));
                    options.UseFeatureFlags(flagOptions => flagOptions.CacheExpirationInterval = TimeSpan.FromSeconds(refreshRate));
                });
            }
                
            return builder;
        }
    }
}
