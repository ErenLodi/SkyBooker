using Microsoft.EntityFrameworkCore;
using SkyBooker.API.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// 1. VERÝTABANI BAÐLANTISI
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// 2. JWT BEARER SÝSTEMÝ
// Bu kýsým, admin paneli gibi kilitli yerlere girerken bilet kontrolü yapar.
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = false,
        ValidateAudience = false,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("EreninCokGizliVeUzunSunucuSifresi123!"))
    };
});

// 3. AYRINTILI CORS AYARI (Azure - SmarterASP Köprüsü)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()   // Her yerden gelen isteðe izin ver (Azure dahil)
              .AllowAnyMethod()   // GET, POST, PUT, DELETE hepsine izin ver
              .AllowAnyHeader();  // Tüm baþlýklara izin ver
    });
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer(); // .NET 8/9 için Swagger desteði
builder.Services.AddSwaggerGen();           // Swagger arayüzü için

var app = builder.Build();

// 4. MÝDDLEWARE SIRALAMASI (Buradaki sýra hayati önem taþýr!)
if (app.Environment.IsDevelopment() || true) // Canlýda da swagger görmek istersen 'true' kalsýn
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// --- KRÝTÝK SIRALAMA BAÞLANGICI ---
app.UseRouting(); // Rotalarý belirle

app.UseCors("AllowAll"); // 1. Önce kapýyý aç (CORS)

app.UseAuthentication(); // 2. Kimlik sor (Biletin var mý?)
app.UseAuthorization();  // 3. Yetki kontrol et (Buraya girmeye hakkýn var mý?)
// --- KRÝTÝK SIRALAMA BÝTÝÞÝ ---

app.MapControllers();

app.Run();