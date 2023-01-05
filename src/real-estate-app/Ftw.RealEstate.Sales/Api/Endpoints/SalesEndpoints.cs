using Ftw.RealEstate.Sales.Api.Schemas;

namespace Ftw.RealEstate.Sales.Api.Endpoints
{
    public static class SalesEndpoints
    {
        public static WebApplication MapSalesEndpoints(this WebApplication app)
        {
            var routes = app.MapGroup("/sales").WithTags("Sales");

            routes.MapGet("/houses", GetHouses)
                .WithName("GET houses")
                .WithDisplayName("Get all houses that are for sale");

            routes.MapGet("/apartments", GetApartments)
                .WithName("GET apartments")
                .WithDisplayName("Get all apartments that are for sale");

            return app;
        }
        private static IEnumerable<HouseDto> GetHouses(HttpContext context)
        {
            var houses = Enumerable.Range(1, Random.Shared.Next(3, 8)).Select(index =>
                new HouseDto
                (
                    GetRandomCity(),
                    GetRandomHouseDescription(),
                    GetRandomPrice(300000, 2100000),
                    GetRandomHouseType()
                )).ToArray();
            return houses;
        }

        private static IEnumerable<ApartmentDto> GetApartments(HttpContext context)
        {
            var apartments = Enumerable.Range(1, Random.Shared.Next(3, 8)).Select(index =>
                new ApartmentDto
                (
                    GetRandomCity(),
                    GetRandomApartmentDescription(),
                    GetRandomPrice(100000,1200000),
                    Random.Shared.Next(2) == 1
                )).ToArray();
            return apartments;
        }

        private static string GetRandomCity()
        {
            var cities = new[]
            {
                "Brussels", "Rome", "Paris", "Barcelona", "Stockholm", "Dublin", "Riga", "Berlin"
            };
            return cities[Random.Shared.Next(cities.Length)];
        }

        private static double GetRandomPrice(int min, int max)
        {
            return Random.Shared.Next(min, max);
        }

        private static string GetRandomHouseDescription()
        {
            var descriptions = new[]
            {
                "Spacious modern farmhouse", "Cozy cottage with white picket fence", "Luxurious Mediterranean villa", "Mid-century ranch with pool", "Bright and airy beachfront bungalow", "Rustic cabin-style with fireplace", "Chic urban loft with city views", "Modern mid-century with flat roof"
            };
            return descriptions[Random.Shared.Next(descriptions.Length)];
        }

        private static string GetRandomApartmentDescription()
        {
            var descriptions = new[]
            {
                "Modern studio with city views" , "Spacious one-bedroom with ample storage", "Luxurious high-rise with city views" , "Chic penthouse with rooftop deck", "Cozy two-bedroom in historic building" , "Contemporary one-bedroom with pool access", "Large two-bedroom with mountain views" , "Stylish studio in walkable neighborhood"
            };
            return descriptions[Random.Shared.Next(descriptions.Length)];
        }

        private static string GetRandomHouseType()
        {
            var houseTypes = new[]
            {
                "Villa", "Town Home", "Co-Housing", "Ranch", "Housebarn", "Cottage", "Bungalow", "Tiny Home"
            };
            return houseTypes[Random.Shared.Next(houseTypes.Length)];
        }
    }
}
