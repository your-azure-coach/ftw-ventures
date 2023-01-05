namespace Ftw.RealEstate.Rental.Api.Types
{
    [GraphQLName("Apartment")]
    public class ApartmentType
    {
        public string City { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public bool HasBalcony { get; set; }
    }
}