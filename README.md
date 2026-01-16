# CepteÖde - Abonelik Takip Uygulaması

CepteÖde, aylık aboneliklerinizi, faturalarınızı ve düzenli harcamalarınızı tek bir yerden kolayca takip etmenizi sağlayan modern bir mobil uygulamadır.

## 📱 Proje Tanıtım Videosu

> **Not:** Projenin çalışır halini görmek için aşağıdaki videoyu izleyebilirsiniz.

<!-- Buraya video linkini ekleyin. Örnek: [![Video Başlığı](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID) -->
[Proje Tanıtım Videosu - İzlemek için Tıklayın](assets/Mobilproje.mp4)

## ✨ Özellikler

- **Kullanıcı İşlemleri:**
  - Güvenli Giriş ve Kayıt Ol (Firebase Auth)
  - Şifremi Unuttum özelliği
  - Beni Hatırla seçeneği

- **Abonelik Yönetimi:**
  - Mevcut abonelikleri listeleme
  - Yeni abonelik ekleme (Netflix, Spotify, YouTube Premium vb.)
  - Özel kategori oluşturma
  - Aylık ve yıllık gider takibi

- **Raporlama ve Analiz:**
  - Gider dağılımını gösteren grafikler
  - Kategori bazlı harcama analizi
  - Aylık bütçe limiti belirleme ve takip

- **Kullanıcı Deneyimi:**
  - Modern ve şık tasarım (Koyu Mod)
  - Kullanıcı dostu arayüz
  - Çoklu dil desteği (Türkçe/İngilizce)

## 🛠 Kullanılan Teknolojiler

Bu proje aşağıdaki teknolojiler kullanılarak geliştirilmiştir:

- **Framework:** [Flutter](https://flutter.dev/)
- **Dil:** [Dart](https://dart.dev/)
- **Backend & Database:** [Firebase](https://firebase.google.com/)
  - Firebase Authentication (Kimlik Doğrulama)
  - Cloud Firestore (Veritabanı)
- **Diğer Paketler:**
  - `fl_chart`: Grafik ve raporlamalar için
  - `google_fonts`: Modern tipografi için
  - `intl`: Tarih ve para birimi formatlama için

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

1. **Projeyi Klonlayın:**
   ```bash
   git clone https://github.com/kullaniciadi/cepte-ode.git
   cd cepte-ode
   ```

2. **Paketleri Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Firebase Kurulumu:**
   - Firebase konsolunda yeni bir proje oluşturun.
   - `lib/firebase_options.dart` dosyasını kendi proje bilgilerinizle güncelleyin.
   > **Dikkat:** Güvenlik nedeniyle API anahtarları bu repoda paylaşılmamıştır. Uygulamanın çalışması için kendi Firebase yapılandırmanızı eklemeniz gerekmektedir.

4. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

## 📸 Ekran Görüntüleri

<!-- Ekran görüntülerini buraya ekleyebilirsiniz -->
| Giriş Ekranı | Ana Sayfa | Raporlar |
|:---:|:---:|:---:|
| ![Login](screenshots/login.png) | ![Home](screenshots/home.png) | ![Reports](screenshots/reports.png) |
