# Quicko Minigames

<div align="center">
  <img src="assets/logo/quality_icon.png" alt="Quicko Minigames" width="120" height="120">
  
  **A comprehensive brain training app featuring 10+ cognitive games**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue.svg)](https://flutter.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/)
</div>

## 🎮 Game Collection

- **Find the Difference** - Spot the different colored square
- **Blind Sort** - Sort numbers without seeing the full sequence
- **Aim Trainer** - Hit targets as they appear randomly
- **Color Hunt** - Enhance visual perception and color recognition
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
- **📱 Cross-Platform** - Works on iOS and Android
- **📈 Achievement System** - Unlock achievements as you progress

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
- 🇷🇺 Russian

## 📊 Performance

- **App Size**: ~15MB (APK)
- **Memory Usage**: ~50MB average
- **Startup Time**: <2 seconds
- **Frame Rate**: 60 FPS consistently

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

## 📞 Contact

- **Developer**: Furkan Caglar
- **Email**: quickogamehelp@gmail.com

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
  <p>Made with ❤️ by <a href="https://github.com/furkanages">Furkan Caglar</a></p>
  <p>⭐ Star this repository if you find it helpful!</p>
</div>
