namespace SkyBooker.API.Models
{
    // Bu sınıf sadece giriş yaparken Postman'den gelecek e-posta ve şifreyi tutacak.
    public class LoginDto
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
