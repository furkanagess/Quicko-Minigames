# Quicko App - Environment Configuration Setup Summary

Bu doküman, Quicko uygulamasında AdMob ID'leri gibi hassas bilgilerin güvenli bir şekilde yönetilmesi için kurulan yapının özetini içerir.

## 🎯 Amaç

AdMob ID'leri gibi kullanıcıyla paylaşılmaması gereken hassas bilgileri güvenli bir şekilde yönetmek ve farklı environment'larda (development/production) farklı konfigürasyonlar kullanabilmek.

## 🏗️ Kurulan Yapı

### 1. AppConfig Sınıfı

- **Dosya**: `lib/core/config/app_config.dart`
- **Amaç**: Merkezi konfigürasyon yönetimi
- **Özellikler**:
  - Singleton pattern
  - Environment-based configuration
  - Platform-specific AdMob ID'leri
  - Debug logging

### 2. Environment Variables

- **Yöntem**: `String.fromEnvironment()` kullanımı
- **Avantajlar**:
  - Build time'da değerler inject edilir
  - Runtime'da değişmez
  - Güvenli (kod içinde görünmez)

### 3. Platform-Specific Configuration

- **Android**: `android/app/build.gradle.kts`
- **iOS**: `ios/Flutter/Debug.xcconfig` ve `ios/Flutter/Release.xcconfig`

### 4. Build Scripts

- **Run Script**: `scripts/run.sh`
- **Build Script**: `scripts/build.sh`
- **Özellikler**:
  - Colored output
  - Parameter validation
  - Environment-specific configuration
  - Platform support

## 🔧 Kullanım

### Development Mode

```bash
# Android
./scripts/run.sh -p android -e development

# iOS
./scripts/run.sh -p ios -e development

# Web
./scripts/run.sh -p web -e development
```

### Production Mode

```bash
# Android
./scripts/build.sh -p android -e production -t release

# iOS
./scripts/build.sh -p ios -e production -t release
```

### Manual Usage

```bash
flutter run --dart-define=ENVIRONMENT=development --dart-define=ANDROID_APP_ID=your_id
```

## 📁 Dosya Yapısı

```
quicko_app/
├── lib/
│   └── core/
│       └── config/
│           └── app_config.dart          # Ana konfigürasyon sınıfı
├── android/
│   └── app/
│       └── build.gradle.kts             # Android konfigürasyonu
├── ios/
│   └── Flutter/
│       ├── Debug.xcconfig               # iOS Debug konfigürasyonu
│       └── Release.xcconfig             # iOS Release konfigürasyonu
├── scripts/
│   ├── run.sh                          # Run script
│   └── build.sh                        # Build script
├── .env.example                        # Örnek environment dosyası
├── CONFIGURATION.md                    # Detaylı konfigürasyon rehberi
└── README.md                           # Güncellenmiş README
```

## 🔐 Güvenlik Önlemleri

1. **Environment Variables**: Hassas bilgiler kod içinde hardcoded değil
2. **Gitignore**: `.env` dosyaları git'e commit edilmez
3. **Platform Separation**: Android ve iOS için ayrı konfigürasyonlar
4. **Environment Separation**: Development ve production için ayrı ID'ler

## 🎨 Özellikler

### AppConfig Sınıfı

- ✅ Singleton pattern
- ✅ Environment detection
- ✅ Platform detection
- ✅ Debug logging
- ✅ Type safety
- ✅ Error handling

### Build Scripts

- ✅ Colored output
- ✅ Parameter validation
- ✅ Help system
- ✅ Error handling
- ✅ Cross-platform support

### Configuration Management

- ✅ Development/Production separation
- ✅ Test AdMob IDs for development
- ✅ Production AdMob IDs for production
- ✅ Platform-specific configuration
- ✅ Build-time injection

## 🚀 Avantajlar

1. **Güvenlik**: Hassas bilgiler kod içinde görünmez
2. **Esneklik**: Farklı environment'lar için farklı konfigürasyonlar
3. **Kolaylık**: Script'ler ile kolay build ve run
4. **Maintainability**: Merkezi konfigürasyon yönetimi
5. **Debugging**: Debug modunda detaylı logging
6. **Scalability**: Yeni environment'lar kolayca eklenebilir

## 📝 Sonraki Adımlar

1. **Environment Variables**: Gerçek AdMob ID'lerini environment variable olarak ayarlayın
2. **CI/CD**: Build script'lerini CI/CD pipeline'ına entegre edin
3. **Monitoring**: Production'da AdMob performansını izleyin
4. **Documentation**: Takım üyelerine yeni yapıyı tanıtın

## 🔍 Test

Yapıyı test etmek için:

```bash
# Development mode test
./scripts/run.sh -p android -e development

# Production mode test
./scripts/build.sh -p android -e production -t debug
```

Debug loglarında konfigürasyon bilgilerini görebilirsiniz.

## 📚 Kaynaklar

- [Flutter Environment Variables](https://docs.flutter.dev/deployment/environment-variables)
- [Google AdMob Documentation](https://developers.google.com/admob)
- [Flutter AdMob Plugin](https://pub.dev/packages/google_mobile_ads)
