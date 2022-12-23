using System.Buffers.Text;
using System.ComponentModel.DataAnnotations;

namespace Ftw.Hotels.HotelCatalog.Data.Models
{
    public class Country: BaseEntity
    {
        [Required]
        [MaxLength(2)]
        public string Code { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        public ICollection<Hotel> Hotels { get; set; } = new List<Hotel>();
    }
}
