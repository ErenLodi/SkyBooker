# PROJE ADI

> **Not:** Bu bölüm proje adı ile güncellenmelidir.

---

## Proje Hakkında

**Proje Tanımı:** 
> Projenin ne iş yaptığını anlatan bir paragraflık tanıtım metni buraya yazılacaktır.

**Örnek:** X isimli e-ticaret sitemiz, online alışveriş deneyimini kolay ve keyifli hale getirmek için tasarlandı. Geniş ürün yelpazemiz sayesinde müşterilerimize en iyi seçenekleri sunarken, kullanıcı dostu arayüzümüz ile de alışveriş yapmayı daha rahat hale getiriyoruz. Sitemizde yer alan ürünler, kaliteli ve güvenilir markaların en yeni ve trend ürünlerinden oluşuyor. Müşterilerimiz, aradıkları ürünleri hızlı ve kolay bir şekilde bulabilirken, aynı zamanda satın alma süreçlerinde de sorunsuz bir deneyim yaşayacaklar. Hızlı teslimat seçenekleri, güvenli ödeme sistemleri ve müşteri memnuniyetine önem veren satış sonrası hizmetlerimizle, X olarak müşterilerimizin beklentilerini en üst seviyede karşılamayı hedefliyoruz. Her zaman en iyi fiyatlarla, kaliteli ürünleri müşterilerimize sunmak için çalışıyoruz ve müşteri memnuniyeti bizim için her zaman önceliklidir. X e-ticaret sitemize hoş geldiniz, size hizmet vermek için sabırsızlanıyoruz.

**Proje Kategorisi:** 
> Projenin hangi alanda yapıldığını belirten bir kategori. Örnek: E-Ticaret, Sosyal Medya vb.

**Referans Uygulama:** 
> [Örnek Referans Uygulama](https://example.com)

---

## Proje Linkleri

- **REST API Adresi:** [api.yazmuh.com](https://api.yazmuh.com)
- **Web Frontend Adresi:** [frontend.yazmuh.com](https://frontend.yazmuh.com)

---

## Proje Ekibi

**Grup Adı:** 
> Belirlediğiniz grup adı buraya yazılacaktır.

**Ekip Üyeleri:** 
- Ali Tutar
- Veli Yılmaz
- Selami Demir
- Ayşe Kaya
- Fatma Öztürk
- Hayriye Şahin

---

## Dokümantasyon

Proje dokümantasyonuna aşağıdaki linklerden erişebilirsiniz:

1. [Gereksinim Analizi](Gereksinim-Analizi.md)
2. [REST API Tasarımı](API-Tasarimi.md)
3. [Backend](Rest-API.md)
4. [Web Front-End](WebFrontEnd.md)
5. [Mobil Front-End](MobilFrontEnd.md)
6. [Mobil Backend](MobilBackEnd.md)
7. [Video Sunum](Sunum.md)

---

## Projeyi Fork Etme ve Düzenleme

**ÖNEMLİ:** Bu projeyi kullanmak için fork yapmak zorunludur. Fork işlemini sadece grup lideri veya grup tarafından seçilen bir üye yapmalıdır.

### Fork Etme (Grup Lideri veya Seçilen Üye)

**Adım 1: Fork İşlemi**
1. GitHub'da proje sayfasına gidin
2. Sağ üst köşedeki **"Fork"** butonuna tıklayın
3. Fork'u kendi GitHub hesabınıza oluşturun

**Adım 2: Repo Adını Değiştirme**
1. Fork yaptıktan sonra, GitHub'da fork'u açın
2. **Settings** sekmesine gidin
3. **Repository name** bölümünden repo adını **proje adınız** ile değiştirin
4. **Rename** butonuna tıklayın

**Adım 3: Diğer Grup Üyelerini Collaborator Olarak Ekleme**
1. Fork'u yapan kişi, GitHub repo sayfasında **Settings** sekmesine gidin
2. Sol menüden **Collaborators** seçeneğine tıklayın
3. **Add people** butonuna tıklayın
4. Diğer grup üyelerinin GitHub kullanıcı adlarını veya email adreslerini girin
5. Her bir grup üyesini **collaborator** olarak ekleyin
6. Eklenen üyelere GitHub üzerinden davet gönderilecektir
7. Her grup üyesi email'deki daveti kabul etmelidir

**Adım 4: Projeyi Yerel Bilgisayara Clone Etme**
Fork'u yapan kişi ve collaborator olarak eklenen tüm grup üyeleri:

```bash
git clone https://github.com/fork-yapan-kisinin-kullanici-adi/proje-adi.git
```
### Projeyi Düzenleme

Fork yaptıktan sonra projeyi kendi bilgilerinizle güncellemeniz gerekmektedir:

1. **Proje Bilgilerini Güncelleme:**
   - `Readme.md` dosyasındaki proje adı, grup adı, ekip üyeleri
   - Proje tanımı ve kategorisi
   - Referans uygulama bilgisi

2. **Gereksinimleri Ekleme:**
   - `Gereksinim-Analizi.md` dosyasına kendi gereksinimlerinizi ekleyin
   - Her ekip üyesi için gereksinim dosyası oluşturun (örn: `Ali-Atabak-Gereksinimler.md`)
   - Gereksinim sayılarına dikkat edin (Gereksinim-Analizi.md dosyasındaki kurallara göre)

3. **Dokümantasyonu Güncelleme:**
   - Tüm dokümantasyon dosyalarını kendi projenize göre düzenleyin
   - Ekip üyelerinin görevlerini güncelleyin
   - API endpoint'lerini ve açıklamalarını kontrol edin

4. **Değişiklikleri Kaydetme:**
   ```bash
   git add .
   git commit -m "Proje bilgileri güncellendi"
   git push origin main
   ```

### Notlar

- **Fork işlemi:** Sadece grup lideri veya seçilen bir üye fork yapmalıdır. Tüm grup üyelerinin ayrı ayrı fork yapmasına gerek yoktur.
- **Collaborator ekleme:** Fork'u yapan kişi, diğer tüm grup üyelerini collaborator olarak eklemelidir.
- **Repo adı:** Fork yaptıktan sonra repo adını proje adınız ile değiştirmeyi unutmayın.
- **Tüm placeholder'ları değiştirin:** (örn: [Grup Üyesi 2], [Soyisim], PROJE ADI vb.) kendi bilgilerinizle değiştirin
- **Dokümantasyon:** Tüm dokümantasyon dosyalarını eksiksiz doldurun
- **Görev dağılımı:** Her ekip üyesi kendi görevlerini tamamlamalıdır
- **İşbirliği:** Collaborator olarak eklenen üyeler, projeye doğrudan commit ve push yapabilirler

---

## Notlar

- Tüm dokümantasyon dosyaları proje kök dizininde bulunmaktadır.
- Her dokümantasyon dosyası ilgili bölümün detaylı açıklamalarını içermektedir.
- Proje geliştirme sürecinde dokümantasyonlar güncel tutulmalıdır.