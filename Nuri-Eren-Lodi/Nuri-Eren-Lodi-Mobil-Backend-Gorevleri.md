# ⚙️ Nuri Eren Lodi - Mobil Backend (REST API) Görevleri Raporu

Mobil uygulamanın veri tutarlılığı ve iş mantığı, uzak sunucuda barındırılan **.NET Core REST API** ve **MSSQL** veritabanına `http` paketi üzerinden uçtan uca güvenli isteklerle bağlanmıştır.

---

## 🛠️ Entegre Edilen REST API Operasyonları

### 1. Güvenli Kimlik Doğrulama (Auth)
* `POST /api/Users/login` üzerinden JWT Token mekanizması mobil tarafa entegre edildi.
* Başarılı giriş sonrası, arka planda API'ye gizli bir GET isteği atılarak kullanıcının veritabanındaki `ID` numarası çekilmiş ve global hafızada güvenle saklanmıştır.

### 2. Bilet ve Rezervasyon Otomasyonu
* **Bilet Kesme:** Seçilen uçuş için `POST /api/Reservations` isteği atılarak veritabanında yeni rezervasyon kaydı oluşturuldu.
* **Bilet İptali:** `DELETE /api/Reservations/{id}` isteğiyle iptal işlemi bulut veritabanına işlendi.

### 3. Süper Admin Uçuş Yönetimi (CRUD)
* Mobil Admin Paneli üzerinden API'ye bağlanılarak;
  * `POST /api/Flights` (Yeni uçuş ekleme)
  * `PUT /api/Flights/{id}` (Uçuş fiyat/bilgi güncelleme)
  * `DELETE /api/Flights/{id}` (Uçuş seferi silme) operasyonları başarıyla kodlanmıştır.

---

## 🎬 Kanıt Videosu
> *İsteklerin REST API'ye gittiği ve veritabanı işleminin gerçekleştiği net olarak videoda gösterilmiştir.*
> 
> **YouTube / Drive Linki:** [(https://youtu.be/Ldo2upX8OyQ)]