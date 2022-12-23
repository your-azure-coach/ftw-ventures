

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ftw.Hotels.HotelCatalog.Data.Models
{
    public class Room: BaseEntity
    {
        [Required]
        [MaxLength(50)]
        public string Number { get; set; }
        public int Floor { get; set; }
        public int Capacity { get; set; }
        
        [ForeignKey("HotelId")]
        public Hotel Hotel { get; set; }
        public Guid HotelId { get; set; }
    }
}
