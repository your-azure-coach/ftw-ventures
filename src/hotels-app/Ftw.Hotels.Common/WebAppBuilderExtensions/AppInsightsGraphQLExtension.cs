using HotChocolate.Execution.Instrumentation;
using HotChocolate.Execution;
using Microsoft.IdentityModel.Abstractions;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Http;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;

namespace Ftw.Hotels.Common.WebAppBuilderExtensions
{
    public class AppInsightsGraphQLExtension: ExecutionDiagnosticEventListener
    {
        private readonly TelemetryClient _telemetryClient;

        public AppInsightsGraphQLExtension(TelemetryClient telemetryClient)
        {
            _telemetryClient = telemetryClient;
        }

        public override IDisposable ExecuteRequest(IRequestContext context)
        {
            return new RequestScope(_telemetryClient, context);
        }

        private class RequestScope : IDisposable
        {
            private TelemetryClient _telemetryClient;
            private IRequestContext _context;
            private IOperationHolder<RequestTelemetry> _operation;
            private bool _disposed = false;

            public RequestScope(TelemetryClient telemetryClient, IRequestContext context)
            {
                _telemetryClient = telemetryClient;
                _context = context;

                var httpContext = GetHttpContextFrom(context);

                if (httpContext == null) return;

                // Create a new request
                var requestTelemetry = new RequestTelemetry()
                {
                    Name = $"{httpContext.Request.Method} {httpContext.Request.GetUri().GetLeftPart(UriPartial.Path)}",
                    Url = new Uri(httpContext.Request.GetUri().AbsoluteUri)
                };

                requestTelemetry.Context.Operation.Id = GetOperationIdFrom(httpContext);
                requestTelemetry.Context.Operation.ParentId = GetOperationIdFrom(httpContext);
                requestTelemetry.Properties.Add("GraphQL Query", context.Request.Query?.ToString());

                // Start the operation, and store it
                _operation = _telemetryClient.StartOperation(requestTelemetry);
            }

            public void Dispose()
            {
                if (_disposed)
                    return;

                var httpContext = GetHttpContextFrom(_context);
                if (httpContext == null) return;


                // handle any final request logging here (GraphQL query errors, success, etc)
                //if (_context.Result is IQueryResult queryResult && queryResult.Errors?.Count == 0)
                //{
                //    HandleErrors(queryResult.Errors);
                //    _operation.Telemetry.Success = false;
                //    _operation.Telemetry.ResponseCode = "500";
                //}
                //else
                //{
                //    _operation.Telemetry.Success = true;
                //    _operation.Telemetry.ResponseCode = "200";
                //}

                // Then stop the operation. This completes the request.
                _telemetryClient.StopOperation(_operation);
                _disposed = true;
            }

            private HttpContext GetHttpContextFrom(IRequestContext context)
            {
                if (!context.ContextData.ContainsKey("HttpContext"))
                    return null;

                return context.ContextData["HttpContext"] as HttpContext;
            }

            private string GetOperationIdFrom(HttpContext context)
            {
                return context.TraceIdentifier;
            }

            private void HandleErrors(IReadOnlyCollection<IError> errors)
            {
                foreach (var error in errors)
                {
                    if (error.Exception == null)
                    {
                        var exceptionTelemetry = new ExceptionTelemetry();
                        exceptionTelemetry.Message = error.Message;
                        _telemetryClient.TrackException(exceptionTelemetry);
                    }
                    else
                    {
                        _telemetryClient.TrackException(error.Exception);
                    }
                }
            }
        }
    }
}
