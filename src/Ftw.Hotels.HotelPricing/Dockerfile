#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Ftw.Hotels.HotelPricing/Ftw.Hotels.HotelPricing.csproj", "Ftw.Hotels.HotelPricing/"]
RUN dotnet restore "Ftw.Hotels.HotelPricing/Ftw.Hotels.HotelPricing.csproj"
COPY . .
WORKDIR "/src/Ftw.Hotels.HotelPricing"
RUN dotnet build "Ftw.Hotels.HotelPricing.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ftw.Hotels.HotelPricing.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Ftw.Hotels.HotelPricing.dll"]