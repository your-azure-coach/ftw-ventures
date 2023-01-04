#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Ftw.RealEstate.Sales/Ftw.RealEstate.Sales.csproj", "Ftw.RealEstate.Sales/"]
RUN dotnet restore "Ftw.RealEstate.Sales/Ftw.RealEstate.Sales.csproj"
COPY . .
WORKDIR "/src/Ftw.RealEstate.Sales"
RUN dotnet build "Ftw.RealEstate.Sales.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ftw.RealEstate.Sales.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Ftw.RealEstate.Sales.dll"]