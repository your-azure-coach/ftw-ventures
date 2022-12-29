#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src/hotels-app
COPY ["Ftw.Hotels.SuperGraph.Api/Ftw.Hotels.SuperGraph.Api.csproj", "Ftw.Hotels.SuperGraph.Api/"]
RUN dotnet restore "Ftw.Hotels.SuperGraph.Api/Ftw.Hotels.SuperGraph.Api.csproj"
COPY . .
WORKDIR "/src/hotels-app/Ftw.Hotels.SuperGraph.Api"
RUN dotnet build "Ftw.Hotels.SuperGraph.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Ftw.Hotels.SuperGraph.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Ftw.Hotels.SuperGraph.Api.dll"]