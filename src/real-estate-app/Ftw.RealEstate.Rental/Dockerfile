#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Ftw.RealEstate.Rental/Ftw.RealEstate.Rental.csproj", "Ftw.RealEstate.Rental/"]
RUN dotnet restore "Ftw.RealEstate.Rental/Ftw.RealEstate.Rental.csproj"
COPY . .
WORKDIR "/src/Ftw.RealEstate.Rental"
RUN dotnet build "Ftw.RealEstate.Rental.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ftw.RealEstate.Rental.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Ftw.RealEstate.Rental.dll"]