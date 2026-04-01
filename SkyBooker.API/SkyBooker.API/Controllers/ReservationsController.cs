using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkyBooker.API.Data;
using SkyBooker.API.Models;
using System.Security.Claims; // <-- KİMLİK OKUMAK İÇİN EKLENDİ
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SkyBooker.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ReservationsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ReservationsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // =========================================================
        // 1. GEÇMİŞ REZERVASYONLARI GÖRÜNTÜLEME (Güvenlikli)
        // =========================================================
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Reservation>>> GetReservations()
        {
            // Giriş yapan kişinin e-postasını ve ID'sini token'dan buluyoruz
            var userEmail = User.FindFirst(ClaimTypes.Email)?.Value;
            var userIdString = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            int userId = 0;
            int.TryParse(userIdString, out userId);

            // Eğer giriş yapan kişi ADMIN ise sistemdeki TÜM biletleri görsün
            if (userEmail == "admin@skybooker.com")
            {
                return await _context.Reservations.ToListAsync();
            }

            // Normal bir müşteri ise SADECE KENDİ ID'SİNE ait biletleri görsün!
            return await _context.Reservations.Where(r => r.UserId == userId).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Reservation>> GetReservation(int id)
        {
            var reservation = await _context.Reservations.FindAsync(id);

            if (reservation == null)
            {
                return NotFound();
            }

            return reservation;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutReservation(int id, Reservation reservation)
        {
            if (id != reservation.Id)
            {
                return BadRequest();
            }

            _context.Entry(reservation).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReservationExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // =========================================================
        // 2. YENİ BİLET ALMA (Bileti Kullanıcıya Mühürleme)
        // =========================================================
        [HttpPost]
        public async Task<ActionResult<Reservation>> PostReservation(Reservation reservation)
        {
            // Bilet alınırken, o biletin üstüne "Bu bilet şu ID'li kişiye ait" mührünü basıyoruz!
            var userIdString = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (int.TryParse(userIdString, out int userId))
            {
                reservation.UserId = userId; // Bileti sahiplendir
            }

            _context.Reservations.Add(reservation);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetReservation", new { id = reservation.Id }, reservation);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReservation(int id)
        {
            var reservation = await _context.Reservations.FindAsync(id);
            if (reservation == null)
            {
                return NotFound();
            }

            _context.Reservations.Remove(reservation);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ReservationExists(int id)
        {
            return _context.Reservations.Any(e => e.Id == id);
        }
    }
}