# ⚙️ SkyBooker - REST API Proje Görevleri Raporu

**Öğrenci:** Nuri Eren Lodi - 2221032036  
**Üniversite:** Süleyman Demirel Üniversitesi - Bilgisayar Mühendisliği  

---

## 🌐 REST API Yayın Adresi (Base URL)
**API URL:** [http://erenlodi-001-site1.qtempurl.com/api/](http://erenlodi-001-site1.qtempurl.com/api/)

---

## 🎥 Postman API Test ve Kanıt Videosu
Aşağıdaki videoda, Postman üzerinden canlı domaindeki API uç noktalarına (Endpoints) istek atılmış; JWT Token kullanımı, başarılı statü kodları (200 OK, 201 Created) ve veritabanı yansımaları net bir şekilde gösterilmiştir.

> **YouTube Video Linki:** [(https://www.youtube.com/watch?v=vNjATLEr3KQ)]

---

## 🚀 API Metotları ve Yol Haritası (Endpoints)

Tüm metotlar JSON formatında veri alışverişi yapmaktadır. Güvenli alanlar (Rezervasyon, Profil) için **Bearer Token** zorunludur.

### 1. Uçuş İşlemleri (Flights)
* **GET `/Flights`**: Tüm uçuşları listeler. (Parametreler: `departure`, `arrival`)
* **Açıklama:** Veritabanındaki aktif uçuş verilerini döndürür.

### 2. Kimlik Doğrulama (Auth)
* **POST `/Auth/Register`**: Yeni kullanıcı kaydı oluşturur. (Body: `FirstName`, `LastName`, `Email`, `Password`)
* **POST `/Auth/Login`**: Kullanıcı girişi sağlar ve **JWT Token** döndürür. (Body: `Email`, `Password`)

### 3. Rezervasyon İşlemleri (Reservations - [Authorize])
* **GET `/Reservations`**: Giriş yapmış kullanıcının kendi biletlerini listeler.
* **POST `/Reservations`**: Yeni bilet oluşturur. (Body: `FlightId`, `PassengerName`, `SeatNumber`)
* **DELETE `/Reservations/{id}`**: ID'si verilen rezervasyonu sistemden siler (İptal).

### 4. Kullanıcı Profil Yönetimi (Users - [Authorize])
* **GET `/Users/{id}`**: Kullanıcının profil bilgilerini getirir.
* **PUT `/Users/{id}`**: Profil bilgilerini (ad, soyad, e-posta) günceller.
* **DELETE `/Users/{id}`**: Kullanıcı hesabını ve bağlı tüm verileri siler.

---

## 📂 Postman Koleksiyonu
API testlerinde kullanılan tüm request'lerin yer aldığı JSON koleksiyonu, GitHub reposundaki aynı klasörde (`SkyBooker_Postman_Collection.json`) yer almaktadır.