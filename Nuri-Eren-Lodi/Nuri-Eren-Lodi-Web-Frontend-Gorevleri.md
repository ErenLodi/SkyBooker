# ✈️ SkyBooker - Web Frontend Proje Görevleri Raporu

**Öğrenci:** Nuri Eren Lodi - 2221032036
**Üniversite:** Süleyman Demirel Üniversitesi - Bilgisayar Mühendisliği  

---

## 🌐 Canlı Uygulama Adresi (Domain)
**Frontend URL:** [https://skybooker-web-h7c6duc4frakgndh.westeurope-01.azurewebsites.net/](https://skybooker-web-h7c6duc4frakgndh.westeurope-01.azurewebsites.net/)

---

## 🎥 Proje Kanıt ve Fonksiyonellik Videosu
Aşağıdaki videoda, Azure üzerinde yayında olan Frontend projesinin SmarterASP.NET üzerindeki API katmanına canlı olarak bağlandığı, verileri başarıyla çektiği ve veritabanı işlemlerini (CRUD) gerçekleştirdiği test edilerek kanıtlanmıştır.

> **YouTube Video Linki:** [(https://www.youtube.com/watch?v=VIFWuUX_SJ4)]

---

## 🛠️ Gerçekleştirilen Web Frontend Görev Detayları

Bu projede Web Frontend katmanı Azure üzerinde, API katmanı ise SmarterASP.NET üzerinde **Distributed (Dağıtık)** mimaride çalışmaktadır.

### 1. Dinamik Uçuş Listeleme (API Connection)
* **Açıklama:** Ana sayfa açıldığında API üzerinden `GET /api/Flights` metodu çağrılır ve uçuşlar tabloya dinamik olarak dökülür.
* **Kanıt:** Videoda ana sayfa yenilendiğinde verilerin canlı olarak geldiği görülmektedir.

### 2. Gelişmiş Arama ve Filtreleme
* **Açıklama:** Kullanıcı kalkış ve varış noktası girerek API'ye sorgu parametreleri gönderir.
* **Kanıt:** Videoda "Antalya" araması yapıldığında listenin süzüldüğü gösterilmiştir.

### 3. JWT Tabanlı Kullanıcı Oturumu (Auth Entegrasyonu)
* **Açıklama:** Kayıt ve giriş işlemleri API üzerinden yapılır. Başarılı girişte dönen JWT Token, tarayıcı çerezlerinde saklanarak güvenli alanlara erişim sağlanır.

### 4. Bilet Rezervasyon ve Veritabanı Kaydı
* **Açıklama:** Seçilen uçuş için `POST /api/Reservations` metoduyla bilet oluşturulur.
* **Kanıt:** Videoda bilet alındıktan sonra "Biletlerim" sayfasına verinin düştüğü ve veritabanında oluştuğu gösterilmiştir.

### 5. Kullanıcı Profil Yönetimi (CRUD - Update/Delete)
* **Açıklama:** Kullanıcı bilgilerini güncelleyebilir (`PUT`) veya hesabını silebilir (`DELETE`).
* **Kanıt:** Videoda profil bilgilerinin değiştirilip başarıyla kaydedildiği doğrulanmıştır.

### 6. Rezervasyon İptal Sistemi
* **Açıklama:** Kullanıcı aldığı bileti `DELETE /api/Reservations/{id}` metoduyla iptal edebilir.
---