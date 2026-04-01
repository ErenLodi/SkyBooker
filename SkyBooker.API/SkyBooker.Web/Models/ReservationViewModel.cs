namespace SkyBooker.Web.Models
{
    public class ReservationViewModel
    {
        public int Id { get; set; }
        public int FlightId { get; set; }
        public string PassengerName { get; set; } = string.Empty;
        public string SeatNumber { get; set; } = string.Empty;
        public DateTime ReservationDate { get; set; }
        public string Status { get; set; } = string.Empty;
    }
}