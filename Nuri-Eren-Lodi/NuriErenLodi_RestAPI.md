```markdown
# 3. Aşama: REST API Teslimi - Nuri Eren Lodi

**Video Kanıt Linki:** https://youtu.be/vNjATLEr3KQ

**REST API Canlı Domain Adresi:** http://erenlodi-001-site1.qtempurl.com

---

## Tamamlanan Gereksinimler (11/11)

Benim sorumluluğumdaki 11 gereksinimin tamamı canlı domain üzerinde test edilmiş ve başarılı sonuçlar alınmıştır.

### 1. Yeni Kullanıcı Kaydı Oluşturma
- **Yol:** `/api/Users`
- **Metot:** POST
- **Request Body (Örnek):**
```json
{
  "firstName": "Ahmet",
  "lastName": "Yilmaz",
  "email": "ahmet@example.com",
  "passwordHash": "123456"
}
```

### 2. Kullanıcı Girişi ve Token Alma
- **Yol:** `/api/Users/login`
- **Metot:** POST
- **Request Body:** Sadece `email` ve `password` gönderilir, geriye JWT Token döner.

### 3. Kullanıcı Profilini Güncelleme
- **Yol:** `/api/Users/{id}`
- **Metot:** PUT

### 4. Kullanıcı Hesabını Silme
- **Yol:** `/api/Users/{id}`
- **Metot:** DELETE

### 5. Yeni Uçuş Seferi Ekleme
- **Yol:** `/api/Flights`
- **Metot:** POST
- **Request Body (Örnek):**
```json
{
  "flightCode": "XQ-1234",
  "departure": "Antalya",
  "arrival": "İzmir",
  "price": 1450.00,
  "departureTime": "2026-04-15T14:00:00"
}
```

### 6. Uçuşları Arama / Listeleme
- **Yol:** `/api/Flights`
- **Metot:** GET

### 7. Uçuş Bilgilerini Güncelleme
- **Yol:** `/api/Flights/{id}`
- **Metot:** PUT

### 8. Uçuş Seferini İptal Etme
- **Yol:** `/api/Flights/{id}`
- **Metot:** DELETE

### 9. Bilet Rezervasyonu Oluşturma
- **Yol:** `/api/Reservations`
- **Metot:** POST
- **Request Body (Örnek):**
```json
{
  "flightId": 2,
  "passengerName": "Eren Lodi",
  "seatNumber": "14A",
  "reservationDate": "2026-03-16T12:00:00",
  "status": "Confirmed"
}
```

### 10. Geçmiş Rezervasyonları Görüntüleme
- **Yol:** `/api/Reservations`
- **Metot:** GET

### 11. Rezervasyon İptali
- **Yol:** `/api/Reservations/{id}`
- **Metot:** DELETE

---
*Not: API testlerinin tamamı Postman üzerinden yapılmış olup, JSON koleksiyon dosyası bu dizinde yer almaktadır.*