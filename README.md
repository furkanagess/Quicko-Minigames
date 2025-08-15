# Quicko App

A Flutter application featuring various brain training games and activities.

## 🎮 Features

- Multiple brain training games
- AdMob integration for monetization
- Multi-language support
- Dark/Light theme support
- Leaderboard system
- Achievement system

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd quicko_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure environment variables (see [Configuration Guide](CONFIGURATION.md))

4. Run the app:

```bash
# Using the provided script
./scripts/run.sh -p android -e development

# Or manually
flutter run --dart-define=ENVIRONMENT=development
```

## 🔧 Configuration

This app uses environment variables to manage sensitive data like AdMob IDs. See the [Configuration Guide](CONFIGURATION.md) for detailed instructions.

### Quick Configuration

For development:

```bash
flutter run --dart-define=ENVIRONMENT=development
```

For production:

```bash
flutter run --dart-define=ENVIRONMENT=production
```

## 📱 Building

### Using Scripts

Build for Android (Production):

```bash
./scripts/build.sh -p android -e production -t release
```

Build for iOS (Production):

```bash
./scripts/build.sh -p ios -e production -t release
```

### Manual Building

```bash
# Android
flutter build apk --release --dart-define=ENVIRONMENT=production

# iOS
flutter build ios --release --dart-define=ENVIRONMENT=production

# Web
flutter build web --release --dart-define=ENVIRONMENT=production
```

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── constants/        # App constants
│   ├── providers/        # State management
│   ├── routes/          # App routing
│   ├── services/        # Business logic services
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
├── features/            # Feature modules
│   ├── aim_trainer/     # Aim trainer game
│   ├── blind_sort/      # Blind sort game
│   ├── color_hunt/      # Color hunt game
│   ├── favorites/       # Favorites feature
│   ├── find_difference/ # Find difference game
│   ├── higher_lower/    # Higher lower game
│   ├── home/           # Home screen
│   ├── leaderboard/    # Leaderboard feature
│   ├── number_memory/  # Number memory game
│   ├── pattern_memory/ # Pattern memory game
│   ├── reaction_time/  # Reaction time game
│   ├── rps/            # Rock paper scissors game
│   ├── settings/       # Settings feature
│   └── twenty_one/     # Twenty one game
├── l10n/               # Localization
└── shared/             # Shared components
    ├── models/         # Shared models
    └── widgets/        # Shared widgets
```

## 🔐 Security

- AdMob IDs and other sensitive data are managed through environment variables
- Configuration files are excluded from version control
- Different configurations for development and production environments

## 📚 Documentation

- [Configuration Guide](CONFIGURATION.md) - Detailed configuration instructions
- [Flutter Documentation](https://docs.flutter.dev/)
- [Google AdMob Documentation](https://developers.google.com/admob)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
