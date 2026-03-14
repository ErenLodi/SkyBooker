using System;
using System.ComponentModel.DataAnnotations;

namespace SkyBooker.API.Models
{
    public class Reservation
    {
        [Key]
        public int Id { get; set; }
        public int FlightId { get; set; }
        public string PassengerName { get; set; } = string.Empty;
        public string SeatNumber { get; set; } = string.Empty;
        public DateTime ReservationDate { get; set; } = DateTime.Now;
        public string Status { get; set; } = "Confirmed";
    }
}
