using Microsoft.Extensions.DependencyInjection;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Azure.Monitor.OpenTelemetry.Exporter;
using Microsoft.Extensions.Configuration;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;

namespace Ftw.Hotels.Common.WebAppBuilderExtensions
{
    public static class LoggingExtension
    {
        public static IServiceCollection ConfigureLogging(this IServiceCollection services, IConfiguration configuration, bool runLocal, string apiName)
        {
            var resourceAttributes = new Dictionary<string, object> {
                { "service.name", apiName },
                { "service.namespace", "ftw-ventures" }
            };

            var resourceBuilder = ResourceBuilder.CreateDefault().AddAttributes(resourceAttributes);

            if (runLocal == false)
            {
                services.AddApplicationInsightsTelemetry(options: new ApplicationInsightsServiceOptions { ConnectionString = configuration["APPINSIGHTS:CONNECTIONSTRING"] });
            }

            services.AddOpenTelemetryTracing(
                t =>
                {
                    t.SetResourceBuilder(resourceBuilder);
                    t.AddHttpClientInstrumentation();
                    t.AddSqlClientInstrumentation(o => {
                        o.SetDbStatementForText = true;
                    });
                    t.AddAspNetCoreInstrumentation();
                    t.AddHotChocolateInstrumentation();
                    if (runLocal)
                    {
                        t.AddConsoleExporter();
                    }
                    else
                    { 
                        t.AddAzureMonitorTraceExporter(m => m.ConnectionString = configuration["APPINSIGHTS:CONNECTIONSTRING"]);
                    }
                }
            );

            return services;
        }
    }
}
