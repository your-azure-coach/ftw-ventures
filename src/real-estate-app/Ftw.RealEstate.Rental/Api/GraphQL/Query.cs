using Ftw.RealEstate.Rental.Api.Types;

namespace Ftw.RealEstate.Rental.Api.GraphQL
{
    public class Query
    {
        public IEnumerable<HouseType> GetHouses()
            => GetRandomHouses();


        private IEnumerable<HouseType> GetRandomHouses()
        {
            var houses = Enumerable.Range(1, Random.Shared.Next(3, 8)).Select(index =>
                new HouseType { 
                     City = GetRandomCity(),
                     Description = GetRandomHouseDescription(),
                     Price = GetRandomPrice(500, 2500),
                     Type = GetRandomHouseType()
                }
            ).ToArray();
            return houses;
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
