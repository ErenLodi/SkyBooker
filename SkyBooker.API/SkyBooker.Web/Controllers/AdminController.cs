using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.Text.Json;
using SkyBooker.Web.Models;
using System.IdentityModel.Tokens.Jwt; // <-- Token okumak için eklenen kütüphane

namespace SkyBooker.Web.Controllers
{
    public class AdminController : Controller
    {
        private readonly HttpClient _httpClient;

        public AdminController(IConfiguration configuration)
        {
            _httpClient = new HttpClient();
            string apiUrl = configuration.GetValue<string>("ApiBaseUrl") ?? "http://erenlodi-001-site1.qtempurl.com/api/";
            _httpClient.BaseAddress = new Uri(apiUrl);
            _httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
        }

        // =========================================================
        // YENİ GÜVENLİK KAPISI: Hem Token var mı, hem de ADMIN mi?
        // =========================================================
        private bool TokenEkleVeAdminKontrolEt()
        {
            var token = Request.Cookies["JWToken"];
            if (string.IsNullOrEmpty(token)) return false;

            try
            {
                // Cüzdandaki Token'ı açıp içine bakıyoruz
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);

                // İçinden e-posta adresini buluyoruz
                var emailClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "email" || c.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress");

                // E-posta adresi admin@skybooker.com DEĞİLSE kapıdan kov!
                if (emailClaim == null || emailClaim.Value != "admin@skybooker.com")
                {
                    return false;
                }

                // Kişi Admin ise, API'ye yapacağımız istekler için bilekliği takıyoruz
                _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                return true;
            }
            catch
            {
                return false; // Token bozuksa reddet
            }
        }

        // =========================================================
        // 1. ADMİN ANA SAYFASI: Uçuşları Listeleme
        // =========================================================
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfayı görüntülemek için Yönetici (Admin) yetkiniz olmalıdır.";
                return RedirectToAction("Index", "Home");
            }

            List<FlightViewModel> flights = new List<FlightViewModel>();
            try
            {
                HttpResponseMessage response = await _httpClient.GetAsync("Flights");
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync();
                    if (data != "[]")
                    {
                        flights = JsonSerializer.Deserialize<List<FlightViewModel>>(data, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["Hata"] = "Bağlantı hatası: " + ex.Message;
            }

            return View(flights);
        }

        // =========================================================
        // 2. UÇUŞ SİLME İŞLEMİ (Tek tıkla iptal)
        // =========================================================
        [HttpPost]
        public async Task<IActionResult> UcusSil(int id)
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfa sadece yöneticilere özeldir.";
                return RedirectToAction("Index", "Home");
            }

            try
            {
                // API'deki kilitli DELETE kapısını çalıyoruz
                HttpResponseMessage response = await _httpClient.DeleteAsync($"Flights/{id}");
                if (response.IsSuccessStatusCode)
                {
                    TempData["Basari"] = "Uçuş başarıyla silindi ve sistemden kaldırıldı!";
                }
                else
                {
                    TempData["Hata"] = "Silme işlemi başarısız. API Hatası: " + (int)response.StatusCode;
                }
            }
            catch (Exception ex)
            {
                TempData["Hata"] = "Hata: " + ex.Message;
            }

            // İşlem bitince sayfayı yenile (Admin ana sayfasına dön)
            return RedirectToAction("Index");
        }

        // =========================================================
        // 3. YENİ UÇUŞ EKLEME (GET: Formu Aç, POST: Kaydet)
        // =========================================================
        [HttpGet]
        public IActionResult UcusEkle()
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfa sadece yöneticilere özeldir.";
                return RedirectToAction("Index", "Home");
            }
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> UcusEkle(FlightViewModel model)
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfa sadece yöneticilere özeldir.";
                return RedirectToAction("Index", "Home");
            }

            try
            {
                // API'nin Flights kapısına yeni uçuş verisini POST ediyoruz
                HttpResponseMessage response = await _httpClient.PostAsJsonAsync("Flights", model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Basari"] = $"✈️ {model.FlightCode} kodlu yeni uçuş başarıyla sisteme eklendi!";
                    return RedirectToAction("Index"); // İşlem bitince uçuş listesine geri dön
                }
                else
                {
                    TempData["Hata"] = "Uçuş eklenemedi. API Hatası: " + (int)response.StatusCode;
                }
            }
            catch (Exception ex)
            {
                TempData["Hata"] = "Bağlantı hatası: " + ex.Message;
            }

            // Hata çıkarsa formu kullanıcının girdiği verilerle birlikte tekrar göster
            return View(model);
        }

        // =========================================================
        // 4. UÇUŞ GÜNCELLEME (GET: Formu Doldur, POST: Değişiklikleri Kaydet)
        // =========================================================
        [HttpGet]
        public async Task<IActionResult> UcusDuzenle(int id)
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfa sadece yöneticilere özeldir.";
                return RedirectToAction("Index", "Home");
            }

            FlightViewModel flight = null;
            try
            {
                // Düzenlenecek uçuşun mevcut bilgilerini API'den çekiyoruz
                HttpResponseMessage response = await _httpClient.GetAsync($"Flights/{id}");
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync();
                    flight = JsonSerializer.Deserialize<FlightViewModel>(data, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                }
            }
            catch (Exception ex)
            {
                TempData["Hata"] = "Bağlantı hatası: " + ex.Message;
                return RedirectToAction("Index");
            }

            if (flight == null)
            {
                TempData["Hata"] = "Düzenlenecek uçuş bulunamadı veya silinmiş.";
                return RedirectToAction("Index");
            }

            return View(flight); // Mevcut bilgileri form sayfasına gönder
        }

        [HttpPost]
        public async Task<IActionResult> UcusDuzenle(FlightViewModel model)
        {
            if (!TokenEkleVeAdminKontrolEt())
            {
                TempData["Hata"] = "Erişim Reddedildi! Bu sayfa sadece yöneticilere özeldir.";
                return RedirectToAction("Index", "Home");
            }

            try
            {
                // API'nin kilitli PUT kapısını kullanarak değişiklikleri gönderiyoruz
                HttpResponseMessage response = await _httpClient.PutAsJsonAsync($"Flights/{model.Id}", model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Basari"] = $"✈️ {model.FlightCode} kodlu uçuş başarıyla güncellendi!";
                    return RedirectToAction("Index");
                }
                else
                {
                    TempData["Hata"] = "Güncelleme başarısız. API Hatası: " + (int)response.StatusCode;
                }
            }
            catch (Exception ex)
            {
                TempData["Hata"] = "Bağlantı hatası: " + ex.Message;
            }

            return View(model); // Hata varsa formu kullanıcının girdiği son haliyle geri ver
        }
    }
}