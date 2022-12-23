using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ftw.Hotels.HotelCatalog.Data.Models
{
    public class Hotel : BaseEntity
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        [MaxLength(200)]
        public string Description { get; set; }
        public int Stars { get; set; }

        [ForeignKey("CountryId")]
        public Country Country { get; set; }
        public Guid CountryId { get; set; }

        public string City { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }

        public ICollection<Room> Rooms { get; set; } = new List<Room>();
    }
}
