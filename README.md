# Ezgiler ve Marşlar

İslami ezgiler ve marşlar için geliştirilmiş, şarkı sözleri, akorlar ve müzik çalma özelliklerine sahip Flutter uygulaması.

## Özellikler

- İki albüm ve çoklu şarkı desteği
- Senkronize akor diyagramları ile şarkı sözleri görüntüleme
- Farklı pozisyon ve kapo seçenekleriyle interaktif akor diyagramları
- Metronom özelliği
- Otomatik şarkı sözü kaydırma
- Ayarlanabilir akor renkleri
- YouTube müzik entegrasyonu
- Son çalınan şarkıları takip etme
- Güzel arka planlarla koyu tema arayüzü

## Teknik Özellikler

- Çoklu platform desteği (Android, iOS, Web)
- Duyarlı tasarım
- Firebase entegrasyonu
- Derin bağlantı desteği
- Web için URL strateji yapılandırması
- Provider ile durum yönetimi
- GoRouter ile navigasyon
- SharedPreferences ile yerel depolama

## Başlangıç

### Gereksinimler

- Flutter SDK (en son sürüm)
- Dart SDK (en son sürüm)
- Flutter eklentili Android Studio / VS Code
- Firebase projesi (dağıtım için)

### Kurulum

1. Depoyu klonlayın:
```bash
git clone [repository-url]
cd Ezgi
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Firebase'i yapılandırın:
   - Yeni bir Firebase projesi oluşturun
   - Firebase konsolunda Android/iOS uygulamalarınızı ekleyin
   - Yapılandırma dosyalarını indirin ve yerleştirin:
     - Android için `google-services.json`
     - iOS için `GoogleService-Info.plist`

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Bağımlılıklar

Ana bağımlılıklar:
- `flutter_svg` - SVG varlık işleme için
- `provider` - Durum yönetimi için
- `go_router` - Navigasyon için
- `shared_preferences` - Yerel depolama için
- `just_audio` - Ses çalma için
- `url_launcher` - Harici URL işleme için
- `firebase_core` - Firebase entegrasyonu için
- `app_links` - Derin bağlantı desteği için

## Proje Yapısı

- `lib/` - Ana kaynak kodu
  - `main.dart` - Uygulama giriş noktası ve yönlendirme
  - `about.dart` - Hakkında ekranı
  - `songs.dart` - Şarkı listesi ekranı
  - `lyrics.dart` - Şarkı sözleri görüntüleme ekranı
  - `chords.dart` - Akor diyagram ekranı
  - `settings.dart` - Ayarlar ekranı
  - `chord_theory.dart` - Akor hesaplamaları ve teorisi
  - `shared.dart` - Paylaşılan yardımcı programlar
  - `web_utils.dart` - Web'e özel yardımcı programlar

## İletişim

Sorularınız, önerileriniz veya geri bildirimleriniz için:

- 📧 Email: [furkan@karaketir.com](mailto:furkan@karaketir.com)
- 🌐 Web: [furkankaraketir.com](https://furkankaraketir.com)
- 💬 GitHub: [@FurkanKaraketir](https://github.com/FurkanKaraketir)
