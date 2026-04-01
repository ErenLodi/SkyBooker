using Microsoft.AspNetCore.Mvc;
using SkyBooker.Web.Models;
using System.Text.Json;
using System.Net.Http.Json; // İŞTE BİZİ KURTARACAK KÜTÜPHANE

namespace SkyBooker.Web.Controllers
{
    public class AuthController : Controller
    {
        private readonly HttpClient _httpClient;

        public AuthController(IConfiguration configuration)
        {
            _httpClient = new HttpClient();
            string apiUrl = configuration.GetValue<string>("ApiBaseUrl") ?? "http://erenlodi-001-site1.qtempurl.com/api/";
            _httpClient.BaseAddress = new Uri(apiUrl);
        }

        // =========================================================================
        // 1. GİRİŞ YAPMA İŞLEMİ (LOGIN)
        // =========================================================================
        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            try
            {
                // Bilgileri manuel string yerine, temiz bir C# objesi olarak hazırlıyoruz
                var loginData = new
                {
                    email = model.Email?.Trim(),
                    password = model.Password?.Trim()
                };

                // .NET'in kendi Postman'i! Bütün formatları ve başlıkları kusursuz ayarlar
                HttpResponseMessage response = await _httpClient.PostAsJsonAsync("Users/login", loginData);

                if (response.IsSuccessStatusCode)
                {
                    string responseText = await response.Content.ReadAsStringAsync();
                    string token = "";

                    // Eğer API bize token'ı {"token": "ey..."} gibi bir formatta gönderiyorsa onu ayıklıyoruz
                    if (responseText.Contains("{") && responseText.Contains("token", StringComparison.OrdinalIgnoreCase))
                    {
                        var result = JsonSerializer.Deserialize<Dictionary<string, string>>(responseText, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                        if (result != null && result.ContainsKey("token"))
                        {
                            token = result["token"];
                        }
                    }
                    else
                    {
                        // Sadece düz metin olarak gönderiyorsa
                        token = responseText.Trim('"');
                    }

                    // VIP Bilekliği cebe atıp Ana Sayfaya uçuyoruz
                    Response.Cookies.Append("JWToken", token, new CookieOptions { HttpOnly = true, Expires = DateTime.Now.AddHours(1) });
                    return RedirectToAction("Index", "Home");
                }

                ViewBag.Hata = $"HATA: {(int)response.StatusCode} - Lütfen e-posta ve şifrenizi kontrol edin.";
                return View(model);
            }
            catch (Exception ex)
            {
                ViewBag.Hata = "Sunucuya ulaşılamadı: " + ex.Message;
                return View(model);
            }
        }

        // =========================================================================
        // 2. ÇIKIŞ YAPMA İŞLEMİ (LOGOUT)
        // =========================================================================
        [HttpGet]
        public IActionResult Logout()
        {
            // Kullanıcının bilgisayarındaki anahtar (Token) çerezini siliyoruz
            Response.Cookies.Delete("JWToken");
            TempData["Basari"] = "Başarıyla çıkış yapıldı.";
            return RedirectToAction("Index", "Home");
        }

        // =========================================================================
        // 3. YENİ EKLENEN: KAYIT OLMA İŞLEMİ (REGISTER)
        // =========================================================================
        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Register(UserViewModel model)
        {
            try
            {
                // API'nin "Users" kapısına (Mutfağa) yeni müşterinin bilgilerini gönderiyoruz
                HttpResponseMessage response = await _httpClient.PostAsJsonAsync("Users", model);

                if (response.IsSuccessStatusCode)
                {
                    TempData["Basari"] = "Aramıza hoş geldin! Kayıt işlemi başarılı, lütfen giriş yapınız.";
                    return RedirectToAction("Login");
                }
                else
                {
                    ViewBag.Hata = "Kayıt başarısız oldu. API Hatası: " + (int)response.StatusCode;
                    return View(model);
                }
            }
            catch (Exception ex)
            {
                ViewBag.Hata = "Sunucuya ulaşılamadı: " + ex.Message;
                return View(model);
            }
        }
    }
}