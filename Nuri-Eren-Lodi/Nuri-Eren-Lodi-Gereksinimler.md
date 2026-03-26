1. Kullanıcı Yönetimi (Auth & User) 

1. Yeni Kullanıcı Kaydı Oluşturma 
API Metodu: POST /api/users/register 
Açıklama: Sisteme yeni bir yolcunun ad, soyad, e-posta ve şifre bilgileriyle kayıt olmasını sağlar. 

2. Kullanıcı Girişi ve Token Alma 
API Metodu: POST /api/auth/login 
Açıklama: Kayıtlı kullanıcının e-posta ve şifresiyle giriş yapıp, işlem yapabilmesi için JWT (JSON Web Token) almasını sağlar. 

3. Kullanıcı Profilini Güncelleme 
API Metodu: PUT /api/users/{id} 
Açıklama: Kullanıcının telefon numarası, doğum tarihi veya şifre gibi kişisel bilgilerini değiştirmesine olanak tanır. 

4. Kullanıcı Hesabını Silme 
API Metodu: DELETE /api/users/{id} 
Açıklama: Kullanıcının talebi üzerine hesabını ve kişisel verilerini sistemden kalıcı olarak siler. 

2. Uçuş Yönetimi (Flight Management) 

5. Yeni Uçuş Seferi Ekleme (Admin) 
API Metodu: POST /api/flights 
Açıklama: Sisteme kalkış/varış havalimanı, tarih, saat ve fiyat bilgilerini içeren yeni bir uçuş seferi ekler. 

6. Uçuşları  Arama 
API Metodu: GET /api/flights 
Açıklama: Kullanıcının kalkış ve varış noktasına göre uygun uçuşları filtreleyip listelemesini sağlar. 

7. Uçuş Bilgilerini Güncelleme (Rötar/Fiyat) 
API Metodu: PUT /api/flights/{id} 
Açıklama: Bir uçuşun kalkış saatini (rötar durumu) veya bilet fiyatını güncellemeyi sağlar. 

8. Uçuş Seferini İptal Etme 
API Metodu: DELETE /api/flights/{id} 
Açıklama: Planlanan bir uçuş seferini sistemden kaldırır veya iptal statüsüne çeker. 

3. Rezervasyon İşlemleri (Booking) 

9. Bilet Rezervasyonu Oluşturma 
API Metodu: POST /api/reservations 
Açıklama: Seçilen uçuş için kullanıcı adına, koltuk numarası ve bagaj bilgisiyle rezervasyon kaydı oluşturur. 

10. Geçmiş Rezervasyonları Görüntüleme 
API Metodu: GET /api/reservations/my-reservations 
Açıklama: Giriş yapmış kullanıcının daha önce satın aldığı veya rezerve ettiği tüm biletleri listeler. 

11. Rezervasyon İptali 
API Metodu: DELETE /api/reservations/{id} 
Açıklama: Kullanıcının yaklaşan bir uçuş için yaptığı rezervasyonu iptal etmesini sağlar. 
