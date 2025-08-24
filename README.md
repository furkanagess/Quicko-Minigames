# Quicko - Brain Training Games

<div align="center">
  <img src="assets/icon/quicko.png" alt="Quicko Logo" width="120" height="120">
  
  **A comprehensive brain training app featuring 12+ cognitive games**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue.svg)](https://flutter.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/)
</div>

## 🎮 Game Collection

### 🥇 Tier 1: Entry Level Games

- **Rock Paper Scissors** - Classic reflex game against AI
- **Higher or Lower** - Predict if the next number will be higher or lower
- **Color Hunt** - Find the target color while avoiding text-color confusion

### 🥈 Tier 2: Medium Difficulty Games

- **Find the Difference** - Spot the different colored square
- **Blind Sort** - Sort numbers without seeing the full sequence
- **Aim Trainer** - Hit targets as they appear randomly

### 🥉 Tier 3: Advanced Games

- **Aim Trainer** - Improve hand-eye coordination and reaction speed
- **Blind Sort** - Test your memory and logical thinking
- **Color Hunt** - Enhance visual perception and color recognition
- **Find Difference** - Sharpen attention to detail and observation skills
- **Higher or Lower** - Train probability and decision-making
- **Number Memory** - Boost working memory and concentration
- **Pattern Memory** - Strengthen visual memory and pattern recognition
- **Reaction Time** - Measure and improve response speed
- **Rock Paper Scissors** - Classic game with AI opponent
- **Twenty One** - Strategic number game (Blackjack variant)

### ✨ Key Features

- **🎯 12+ Brain Training Games** - Diverse cognitive challenges
- **📊 Progress Tracking** - Monitor your improvement over time
- **🏆 Leaderboards** - Compete with other players globally
- **⭐ Favorites System** - Save and quick-access your preferred games
- **🌍 Multi-Language Support** - Available in 11 languages
- **🎨 Dark/Light Theme** - Customizable appearance
- **🔊 Sound Effects** - Immersive audio experience
- **📱 Cross-Platform** - Works on mobile, web, and desktop
- **🔄 Offline Play** - No internet required for gameplay
- **📈 Achievement System** - Unlock achievements as you progress

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/furkanages/quicko_app.git
   cd quicko_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web --release
```

**Desktop:**

```bash
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

## 🏗️ Architecture

Quicko follows a clean, scalable architecture pattern:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── constants/          # App constants
│   ├── mixins/            # Reusable mixins
│   ├── providers/         # State management
│   ├── routes/            # Navigation
│   ├── services/          # Business logic
│   ├── theme/             # UI theming
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── aim_trainer/       # Aim training game
│   ├── blind_sort/        # Blind sorting game
│   ├── color_hunt/        # Color hunting game
│   ├── favorites/         # Favorites management
│   ├── feedback/          # User feedback system
│   ├── find_difference/   # Spot the difference game
│   ├── higher_lower/      # Higher or lower game
│   ├── home/              # Home screen
│   ├── leaderboard/       # Leaderboard system
│   ├── number_memory/     # Number memory game
│   ├── pattern_memory/    # Pattern memory game
│   ├── reaction_time/     # Reaction time game
│   ├── rps/               # Rock paper scissors game
│   ├── settings/          # App settings
│   └── twenty_one/        # Twenty one game
├── l10n/                  # Localization files
├── shared/                # Shared components
│   ├── models/           # Data models
│   └── widgets/          # Reusable widgets
└── main.dart             # App entry point
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.7.0+
- **Language**: Dart 3.0.0+
- **State Management**: Provider
- **Localization**: Flutter Localizations
- **Ads**: Google AdMob
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Firebase Crashlytics
- **In-App Purchases**: Flutter In-App Purchase
- **Audio**: AudioPlayers
- **Image Sharing**: Screenshot + Share Plus
- **HTTP**: HTTP Package
- **URL Handling**: URL Launcher

## 🌍 Localization

Quicko supports 11 languages:

- 🇺🇸 English
- 🇹🇷 Turkish
- 🇩🇪 German
- 🇪🇸 Spanish
- 🇫🇷 French
- 🇮🇹 Italian
- 🇧🇷 Portuguese (Brazil)
- 🇸🇦 Arabic
- 🇮🇳 Hindi
- 🇮🇩 Indonesian
- 🇦🇿 Azerbaijani

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🔧 Configuration

### Environment Setup

1. **Firebase Configuration**

   - Add `google-services.json` for Android
   - Add `GoogleService-Info.plist` for iOS

2. **AdMob Configuration**

   - Configure ad unit IDs in `lib/core/config/app_config.dart`

3. **In-App Purchase**
   - Set up product IDs in app stores
   - Configure in `lib/core/services/in_app_purchase_service.dart`

### Build Configuration

- **App Icons**: Configured via `flutter_launcher_icons.yaml`
- **Splash Screen**: Configured via `flutter_native_splash.yaml`
- **Localization**: Configured via `l10n.yaml`

## 📊 Performance

- **App Size**: ~15MB (APK)
- **Memory Usage**: ~50MB average
- **Startup Time**: <2 seconds
- **Frame Rate**: 60 FPS consistently

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter best practices
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Follow the existing code style

## 🐛 Bug Reports

If you find a bug, please create an issue with:

- **Platform**: Android/iOS/Web/Desktop
- **Version**: App version and OS version
- **Steps to reproduce**: Detailed steps
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Screenshots**: If applicable

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Copyright Notice

```
Copyright (c) 2024 Furkan Ağaç

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Material Design** - For design inspiration
- **Open Source Community** - For the libraries and tools
- **Beta Testers** - For valuable feedback and bug reports

## 📞 Contact

- **Developer**: Furkan Ağaç
- **Email**: quickogamehelp@gmail.com
- **Website**: [Coming Soon]
- **Support**: Create an issue on GitHub

## 📈 Roadmap

- [ ] Additional brain training games
- [ ] Social features and multiplayer
- [ ] Advanced analytics and insights
- [ ] Customizable difficulty levels
- [ ] Offline leaderboards
- [ ] Achievement sharing
- [ ] Daily challenges
- [ ] Progress export/import

---

<div align="center">
  <p>Made with ❤️ by <a href="https://github.com/furkanages">Furkan Ağaç</a></p>
  <p>⭐ Star this repository if you find it helpful!</p>
</div>
