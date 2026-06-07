# Mobil Frontend Görev Dağılımı

Bu dokümanda, mobil uygulamanın kullanıcı arayüzü (UI) ve kullanıcı deneyimi (UX) görevleri listelenmektedir. Her grup üyesi, kendisine atanan ekranların tasarımı, implementasyonu ve kullanıcı etkileşimlerinden sorumludur.

## Grup Üyelerinin Mobil Frontend Görevleri

1. [Nuri Eren Lodi'nin Mobil Frontend Görevleri](Nuri-Eren-Lodi-Mobil-Frontend-Gorevleri.md)


---

## Genel Mobil Frontend Prensipleri

### 1. Tasarım Sistemi
* **Renk Paleti:** Tutarlı renk kullanımı (primary, secondary, error, success)
* **Tipografi:** Okunabilir font boyutları ve ağırlıkları
* **Spacing:** Tutarlı padding ve margin değerleri (8dp/8pt grid sistemi)
* **Iconography:** Standart icon seti kullanımı (Material Icons/SF Symbols)

### 2. Responsive Tasarım
* Farklı ekran boyutlarına uyum (phone, tablet)
* Landscape ve portrait mod desteği
* Safe area desteği (notch, status bar)

### 3. Kullanıcı Deneyimi (UX)
* **Loading States:** Skeleton screens, progress indicators
* **Error Handling:** Kullanıcı dostu hata mesajları
* **Empty States:** Boş durumlar için bilgilendirici mesajlar
* **Feedback:** Kullanıcı aksiyonlarına anında geri bildirim (toast, snackbar)

### 4. Erişilebilirlik (Accessibility)
* Content descriptions ve labels
* Touch target boyutları (min 44x44dp/pt)
* Screen reader ve yüksek kontrast desteği

### 5. Performans & Navigasyon
* Lazy loading (liste görünümleri için) ve Image optimization
* Tutarlı navigation pattern (bottom navigation)
* Real-time validation ve hata mesajlarının alan altında gösterilmesi