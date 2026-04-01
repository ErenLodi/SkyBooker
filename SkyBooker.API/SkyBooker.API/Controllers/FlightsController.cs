using Microsoft.AspNetCore.Authorization;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkyBooker.API.Data;
using SkyBooker.API.Models;

namespace SkyBooker.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class FlightsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public FlightsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // =========================================================
        // 1. UÇUŞLARI LİSTELEME VE ARAMA (Herkese Açık)
        // =========================================================
        [HttpGet]
        [AllowAnonymous]
        public async Task<ActionResult<IEnumerable<Flight>>> GetFlights([FromQuery] string? departure, [FromQuery] string? arrival)
        {
            // Uçuşları veritabanından sorgulanabilir olarak alıyoruz
            var query = _context.Flights.AsQueryable();

            // Eğer kullanıcı kalkış şehri girdiyse, filtrele (Büyük/küçük harf duyarsız)
            if (!string.IsNullOrWhiteSpace(departure))
            {
                query = query.Where(f => f.Departure.ToLower().Contains(departure.ToLower()));
            }

            // Eğer kullanıcı varış şehri girdiyse, filtrele
            if (!string.IsNullOrWhiteSpace(arrival))
            {
                query = query.Where(f => f.Arrival.ToLower().Contains(arrival.ToLower()));
            }

            return await query.ToListAsync();
        }

        // =========================================================
        // DİĞER CRUD İŞLEMLERİ (Sadece Token'ı olanlara / Yöneticilere açık)
        // =========================================================

        [HttpGet("{id}")]
        public async Task<ActionResult<Flight>> GetFlight(int id)
        {
            var flight = await _context.Flights.FindAsync(id);
            if (flight == null) return NotFound();
            return flight;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutFlight(int id, Flight flight)
        {
            if (id != flight.Id) return BadRequest();
            _context.Entry(flight).State = EntityState.Modified;

            try { await _context.SaveChangesAsync(); }
            catch (DbUpdateConcurrencyException) { if (!FlightExists(id)) return NotFound(); else throw; }

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult<Flight>> PostFlight(Flight flight)
        {
            _context.Flights.Add(flight);
            await _context.SaveChangesAsync();
            return CreatedAtAction("GetFlight", new { id = flight.Id }, flight);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFlight(int id)
        {
            var flight = await _context.Flights.FindAsync(id);
            if (flight == null) return NotFound();

            _context.Flights.Remove(flight);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        private bool FlightExists(int id)
        {
            return _context.Flights.Any(e => e.Id == id);
        }
    }
}