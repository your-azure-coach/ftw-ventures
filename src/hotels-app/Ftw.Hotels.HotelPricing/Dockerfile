FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
COPY . .
RUN dotnet restore ./src/hotels-app/Ftw.Hotels.Pricing
RUN dotnet publish ./src/hotels-app/Ftw.Hotels.Pricing -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
EXPOSE 80
COPY --from=build /app/publish /app
ENTRYPOINT ["dotnet", "/app/Ftw.Hotels.Pricing.dll"]