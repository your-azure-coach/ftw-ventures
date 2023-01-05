using Ftw.RealEstate.Rental.Api.Types;

namespace Ftw.RealEstate.Rental.Api.GraphQL
{
    public class Query
    {
        public IEnumerable<ApartmentType> GetApartments()
            => GetRandomApartments();


        private IEnumerable<ApartmentType> GetRandomApartments()
        {
            var houses = Enumerable.Range(1, Random.Shared.Next(3, 8)).Select(index =>
                new ApartmentType { 
                     City = GetRandomCity(),
                     Description = GetRandomApartmentDescription(),
                     Price = GetRandomPrice(500, 2500),
                     HasBalcony = (Random.Shared.Next(0,2) == 1)
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
