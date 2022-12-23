using System.ComponentModel.DataAnnotations;

namespace Ftw.Hotels.HotelCatalog.Api.Types
{
    [GraphQLName("Country")]
    public class CountryType
    {
        public string Code { get; set; }
        public string Name { get; set; }
        public IEnumerable<HotelType> Hotels { get; set; }
    }
}
