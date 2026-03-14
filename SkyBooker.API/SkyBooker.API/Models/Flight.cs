using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema; // Bu yeni geldi (Veritabanı şeması için)

namespace SkyBooker.API.Models
{
    public class Flight
    {
        [Key]
        public int Id { get; set; }
        public string FlightCode { get; set; } = string.Empty;
        public string Departure { get; set; } = string.Empty;
        public string Arrival { get; set; } = string.Empty;

        [Column(TypeName = "decimal(18,2)")] // İşte Microsoft'un istediği ayar: 18 basamaklı sayı, virgülden sonra 2 hane kuruş!
        public decimal Price { get; set; }

        public DateTime DepartureTime { get; set; }
    }
}