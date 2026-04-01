namespace SkyBooker.Web.Models
{
    public class FlightViewModel
    {
        public int Id { get; set; }
        public string FlightCode { get; set; } = string.Empty;
        public string Departure { get; set; } = string.Empty;
        public string Arrival { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public DateTime DepartureTime { get; set; }
    }
}
