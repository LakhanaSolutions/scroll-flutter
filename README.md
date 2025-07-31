# Siraaj - Islamic Audiobook Platform

A comprehensive audiobook and Islamic learning platform built with Flutter, offering premium content with trial-based access controls and sophisticated subscription management.

## Project Overview

Siraaj is an audiobook platform specializing in Islamic content, featuring works by classical scholars like Imam Ahmed Raza Khan Barelvi, Shaykh Abdul Qadir Jilani, and contemporary Islamic scholars. The platform includes sophisticated trial usage tracking, premium content access controls, and a comprehensive audio streaming system.

## Key Features

- **Premium Content System**: 15-minute monthly trial allowance for premium content
- **Advanced Audio Player**: Background playback, waveform visualization, speed controls
- **Trial Usage Tracking**: Granular session-based usage monitoring with monthly resets  
- **Content Library**: Classical and contemporary Islamic works, Quranic commentary, Hadith collections
- **User Progress Tracking**: Bookmarks, notes, recently played, and download management
- **Authentication**: Email-based auth with OTP verification and JWT token management

## Tech Stack

- **Flutter**: Cross-platform mobile development
- **Riverpod**: State management with provider architecture
- **go_router**: Declarative routing with deep linking
- **just_audio + audio_service**: Professional audio playback with background support
- **PostgreSQL**: Database with comprehensive schema for content and user management

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Test Accounts (Development)

- `trial@example.com` - Trial user (8/15 minutes used)
- `premium@example.com` - Premium subscriber  
- `free@example.com` - Free user (trial expired)
- `new@example.com` - New trial user (2/15 minutes used)

All accounts use OTP: `123456`

## Project Structure

```
lib/
├── main.dart              # App entry point
├── data/                  # Mock data and constants
├── models/                # Data models and state classes  
├── providers/             # Riverpod state management
├── router/                # Navigation configuration
├── screens/               # UI screens and pages
├── services/              # Business logic and integrations
├── theme/                 # Design system and theming
└── widgets/               # Reusable UI components
```

## Documentation

See `/docs/` for detailed documentation:
- `tech-info.md` - Comprehensive technical architecture
- `schema-documentation.md` - Database schema and relationships
- `features.md` - Pending features and bug fixes
- `sunni.md` - Islamic content library reference

For Flutter development resources, visit the [official documentation](https://docs.flutter.dev/).
