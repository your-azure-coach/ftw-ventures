using Ftw.RealEstate.Sales.Api.Endpoints;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(
    s =>
    {
        s.SwaggerDoc("v1", new()
            {
                Title = "Sales API",
                Version = "v1",
                Contact = new OpenApiContact()
                {
                    Name = "Toon Vanhoutte",
                    Email = "toon@yourazurecoach.com"
                }
            }
        );
        s.AddServer(new()
            {
                Url = $"http://{Environment.ExpandEnvironmentVariables("%WEBSITE_SITE_NAME%")}.azurewebsites.net"
            }
        );
    }
);

var app = builder.Build();

app.UseHttpsRedirection();
app.UseSwagger();
app.UseSwaggerUI();

app.MapSalesEndpoints();

app.Run();
