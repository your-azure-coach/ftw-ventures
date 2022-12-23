namespace Ftw.Hotels.SuperGraph.Api.Types
{
    [GraphQLName("WeatherInfo")]
    public class WeatherInfoType
    {
        public double Temperature { get; set; }
        public int WeatherCode { get; set; }
    }
}
