using Microsoft.AspNetCore.Mvc;
using System;
using System.Text.Json;
using Ftw.Hotels.Common.Constants;
using Ftw.Hotels.SuperGraph.Api.Types;

namespace Ftw.Hotels.SuperGraph.Api.GraphQL
{
    public class Query
    {
        public async Task<WeatherInfoType> GetWeatherInfo([Service] IHttpClientFactory httpClientFactory, double longitude, double latitude)
        {
            using var httpClient = httpClientFactory.CreateClient(SchemaNames.Local.HotelWeather);
            var sLongitude = longitude.ToString("0.0000000000", System.Globalization.CultureInfo.InvariantCulture);
            var sLatitude = latitude.ToString("0.0000000000", System.Globalization.CultureInfo.InvariantCulture);
                
            var httpResult = await httpClient.GetByteArrayAsync($"/v1/forecast?latitude={sLatitude}&longitude={sLongitude}&current_weather=true&timezone=CET");
            var weatherResult = JsonDocument.Parse(httpResult).RootElement.GetProperty("current_weather");
            
            return new WeatherInfoType
            {
                Temperature = weatherResult.GetProperty("temperature").GetDouble(),
                WeatherCode = weatherResult.GetProperty("weathercode").GetInt16()
            };
        }
    }
}
