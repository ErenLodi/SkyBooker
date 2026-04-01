using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using SkyBooker.Web.Models;
using System.IdentityModel.Tokens.Jwt;

namespace SkyBooker.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly HttpClient _httpClient;

        public HomeController(IConfiguration configuration)
        {
            _httpClient = new HttpClient();
            string apiUrl = configuration.GetValue<string>("ApiBaseUrl") ?? "http://erenlodi-001-site1.qtempurl.com/api/";
            _httpClient.BaseAddress = new Uri(apiUrl);

            // Sunucu güvenliği ve doğru veri formatı için gerekli başlıklar
            _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
            _httpClient.DefaultRequestHeaders.Accept.Clear();
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        // 1. ANA SAYFA: Uçuş Listeleme ve Arama (Herkese Açık)
        public async Task<IActionResult> Index(string kalkis, string varis)
        {
            List<FlightViewModel> flights = new List<FlightViewModel>();
            _httpClient.DefaultRequestHeaders.Authorization = null;

            try
            {
                string url = "Flights";
                if (!string.IsNullOrEmpty(kalkis) || !string.IsNullOrEmpty(varis))
                    url += $"?departure={Uri.EscapeDataString(kalkis ?? "")}&arrival={Uri.EscapeDataString(varis ?? "")}";

                HttpResponseMessage response = await _httpClient.GetAsync(url);
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync();
                    if (data != "[]")
                        flights = JsonSerializer.Deserialize<List<FlightViewModel>>(data, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                }
            }
            catch (Exception ex) { ViewBag.HataMesaji = "Bağlantı Hatası: " + ex.Message; }

            return View(flights);
        }

        // 2. BİLET ALMA FORMU (GET)
        [HttpGet]
        public IActionResult BiletAl(int ucusId)
        {
            var token = Request.Cookies["JWToken"];
            if (string.IsNullOrEmpty(token))
            {
                TempData["Hata"] = "Bilet almak için önce giriş yapmalısınız!";
                return RedirectToAction("Login", "Auth");
            }
            ViewBag.UcusId = ucusId;
            return View();
        }

        // 3. BİLET ALMA İŞLEMİ (POST)
        [HttpPost]
        public async Task<IActionResult> BiletAl(int FlightId, string PassengerName, string SeatNumber)
        {
            var token = Request.Cookies["JWToken"];
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var yeniRezervasyon = new { flightId = FlightId, passengerName = PassengerName, seatNumber = SeatNumber, reservationDate = DateTime.Now, status = "Confirmed" };

            try
            {
                HttpResponseMessage response = await _httpClient.PostAsJsonAsync("Reservations", yeniRezervasyon);
                if (response.IsSuccessStatusCode)
                    TempData["Basari"] = "Biletiniz başarıyla alındı!";
                else
                    TempData["Hata"] = "Hata oluştu. Kod: " + (int)response.StatusCode;
            }
            catch (Exception ex) { TempData["Hata"] = ex.Message; }

            return RedirectToAction("Index");
        }

        // 4. BİLETLERİMİ LİSTELE (GET)
        [HttpGet]
        public async Task<IActionResult> Biletlerim()
        {
            var token = Request.Cookies["JWToken"];
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            List<ReservationViewModel> biletler = new List<ReservationViewModel>();

            try
            {
                HttpResponseMessage response = await _httpClient.GetAsync("Reservations");
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync();
                    biletler = JsonSerializer.Deserialize<List<ReservationViewModel>>(data, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new List<ReservationViewModel>();
                }
            }
            catch (Exception ex) { ViewBag.Hata = ex.Message; }

            return View(biletler);
        }

        // 5. BİLET İPTAL ET (POST) - 404 Hatasını Çözen Metot
        [HttpPost]
        public async Task<IActionResult> BiletIptal(int id)
        {
            var token = Request.Cookies["JWToken"];
            if (string.IsNullOrEmpty(token)) return RedirectToAction("Login", "Auth");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            try
            {
                HttpResponseMessage response = await _httpClient.DeleteAsync($"Reservations/{id}");
                if (response.IsSuccessStatusCode)
                    TempData["Basari"] = "Biletiniz başarıyla iptal edildi.";
                else
                    TempData["Hata"] = "İptal başarısız. API Hatası: " + (int)response.StatusCode;
            }
            catch (Exception ex) { TempData["Hata"] = "Bağlantı hatası: " + ex.Message; }

            return RedirectToAction("Biletlerim");
        }

        // 6. PROFİLİMİ GÖRÜNTÜLE (GET)
        [HttpGet]
        public async Task<IActionResult> Profilim()
        {
            int userId = GetUserIdFromToken();
            if (userId == 0) return RedirectToAction("Login", "Auth");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", Request.Cookies["JWToken"]);

            try
            {
                HttpResponseMessage response = await _httpClient.GetAsync($"Users/{userId}");
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync();
                    var user = JsonSerializer.Deserialize<UserViewModel>(data, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    return View(user);
                }
            }
            catch (Exception ex) { TempData["Hata"] = ex.Message; }

            return RedirectToAction("Index");
        }

        // 7. PROFİL GÜNCELLE (POST)
        [HttpPost]
        public async Task<IActionResult> Profilim(UserViewModel model)
        {
            int userId = GetUserIdFromToken();
            if (userId == 0 || userId != model.Id) return RedirectToAction("Login", "Auth");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", Request.Cookies["JWToken"]);

            try
            {
                HttpResponseMessage response = await _httpClient.PutAsJsonAsync($"Users/{model.Id}", model);
                if (response.IsSuccessStatusCode)
                {
                    TempData["Basari"] = "Profil bilgileriniz başarıyla güncellendi.";
                    return RedirectToAction("Profilim");
                }
                TempData["Hata"] = "Güncelleme başarısız: " + (int)response.StatusCode;
            }
            catch (Exception ex) { TempData["Hata"] = "Bağlantı hatası: " + ex.Message; }

            return View(model);
        }

        // 8. HESAP SİL (POST)
        [HttpPost]
        public async Task<IActionResult> HesapSil()
        {
            int userId = GetUserIdFromToken();
            if (userId == 0) return RedirectToAction("Login", "Auth");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", Request.Cookies["JWToken"]);

            try
            {
                HttpResponseMessage response = await _httpClient.DeleteAsync($"Users/{userId}");
                if (response.IsSuccessStatusCode)
                {
                    Response.Cookies.Delete("JWToken");
                    TempData["Basari"] = "Hesabınız başarıyla silindi.";
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex) { TempData["Hata"] = "Bağlantı hatası: " + ex.Message; }

            return RedirectToAction("Profilim");
        }

        // YARDIMCI METOT: Token'dan ID Çıkarma
        private int GetUserIdFromToken()
        {
            var token = Request.Cookies["JWToken"];
            if (string.IsNullOrEmpty(token)) return 0;
            try
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                var idClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "nameid" || c.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier");
                return idClaim != null ? int.Parse(idClaim.Value) : 0;
            }
            catch { return 0; }
        }
    }
}