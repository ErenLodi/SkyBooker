using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkyBooker.API.Data;
using SkyBooker.API.Models;
using Microsoft.AspNetCore.Authorization; // <-- BU KÜTÜPHANE ŞART!

namespace SkyBooker.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public UsersController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Users (Tüm kullanıcıları listeleme - Güvenlik için kilitli kalabilir)
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        // POST: api/Users (YENİ KAYIT / REGISTER)
        [HttpPost]
        [AllowAnonymous] // <-- İŞTE BU SATIR: Kimliksiz (No Auth) kayıt olabilmeyi sağlar!
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }

        // POST: api/Users/login (GİRİŞ YAP VE TOKEN AL)
        [HttpPost("login")]
        [AllowAnonymous] // <-- İŞTE BU SATIR: Kimliksiz (No Auth) giriş yapabilmeyi sağlar!
        public async Task<IActionResult> Login([FromBody] LoginDto loginBilgileri)
        {
            var user = await _context.Users.SingleOrDefaultAsync(u => u.Email == loginBilgileri.Email);

            if (user == null)
            {
                return Unauthorized("Bu e-posta adresine ait bir kullanıcı bulunamadı.");
            }

            // Şifre kontrolü
            if (user.PasswordHash != loginBilgileri.Password)
            {
                return Unauthorized("Şifre yanlış.");
            }

            // JWT Token Üretme İşlemi
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Name, user.FirstName)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("EreninCokGizliVeUzunSunucuSifresi123!"));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddHours(2),
                SigningCredentials = creds
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return Ok(new
            {
                message = "Giriş Başarılı!",
                token = tokenHandler.WriteToken(token)
            });
        }

        // Diğer metodlar (GetUser, PutUser, DeleteUser) genellikle [Authorize] gerektirir.
        // Eğer onlara da dışarıdan erişmek istersen başlarına [AllowAnonymous] ekleyebilirsin.

        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();
            return user;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id != user.Id) return BadRequest();
            _context.Entry(user).State = EntityState.Modified;
            try { await _context.SaveChangesAsync(); }
            catch (DbUpdateConcurrencyException) { if (!UserExists(id)) return NotFound(); else throw; }
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();
            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        private bool UserExists(int id) { return _context.Users.Any(e => e.Id == id); }
    }
}