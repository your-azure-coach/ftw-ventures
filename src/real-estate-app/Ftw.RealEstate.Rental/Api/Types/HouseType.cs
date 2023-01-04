namespace Ftw.RealEstate.Rental.Api.Types
{
    [GraphQLName("House")]
    public class HouseType
    {
        public string City { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string Type { get; set; }
    }
}