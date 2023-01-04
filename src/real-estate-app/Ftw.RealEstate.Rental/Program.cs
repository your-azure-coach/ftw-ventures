using Ftw.RealEstate.Rental.Api.GraphQL;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddGraphQLServer()
    .InitializeOnStartup()
    .AddQueryType<Query>();

var app = builder.Build();

app.UseHttpsRedirection();
app.MapGraphQL();
app.Run();