# Siraaj - Technical Information

## Project Overview

Siraaj is a comprehensive audiobook platform built with Flutter for the frontend and NestJS with Prisma for the backend. The platform supports audio streaming, user management, subscription services, and social features.

## Project Structure

### Root Directory
```
siraaj/
├── backend/          # NestJS backend application
├── frontend/         # Flutter mobile application
├── docs/            # Project documentation
└── tech-info.md     # This file
```

## Backend Structure (`/backend/`)

### Core Framework & Tools
- **NestJS**: Node.js framework for building scalable server-side applications
- **Prisma**: Modern database toolkit and ORM
- **PostgreSQL**: Primary database for storing all application data

### Key Directories
```
backend/
├── prisma/
│   ├── schema.prisma    # Database schema definition
│   ├── migrations/      # Database migration files
│   └── seed.ts         # Database seeding script
├── src/
│   ├── app.module.ts   # Main application module
│   ├── main.ts         # Application entry point
│   └── prisma/         # Prisma service integration
├── generated/          # Generated Prisma client
└── dist/              # Compiled TypeScript output
```

### Database Schema
The schema includes comprehensive models for:
- **User Management**: Users, profiles, authentication, subscriptions
- **Content Management**: Books, authors, narrators, categories, chapters
- **Audio System**: Audio files, waveform data for visualization
- **User Interactions**: Progress tracking, bookmarks, ratings, playlists
- **Business Logic**: Purchases, downloads, analytics

## Frontend Structure (`/frontend/`)

### Core Framework & Libraries
- **Flutter**: Google's UI toolkit for cross-platform development
- **Riverpod**: State management solution
- **go_router**: Declarative routing with deep linking support
- **just_audio**: Audio playback functionality

### Architecture Patterns
- **Provider Pattern**: State management using Riverpod providers
- **Service Layer**: Abstracted business logic and API calls
- **Widget Composition**: Reusable UI components following Flutter best practices

### Key Directories

#### `/lib/` - Main Application Code
```
lib/
├── main.dart           # Application entry point
├── data/              # Mock data and constants
├── models/            # Data models and state classes
├── providers/         # Riverpod providers for state management
├── router/            # Navigation and routing configuration
├── screens/           # UI screens and pages
├── services/          # Business logic and external integrations
├── theme/             # Design system and theming
└── widgets/           # Reusable UI components
```

#### Key Files & Their Purposes

**Entry Point & Configuration**
- `main.dart` - App initialization, theme setup, router configuration
- `router/app_router.dart` - Centralized routing with deep linking support

**State Management (`/providers/`)**
- `auth_provider.dart` - Authentication state and user session management
- `theme_provider.dart` - Theme switching (light/dark/system) functionality
- `audio_provider.dart` - Audio playback controls and state
- `locale_provider.dart` - Internationalization and language settings

**Services (`/services/`)**
- `token_service.dart` - JWT token management and secure storage
- `preferences_service.dart` - User preferences persistence
- `audio_service.dart` - Audio playback integration with platform services
- `deep_link_service.dart` - Deep linking URL generation and parsing

**Screens (`/screens/`)**
- `auth/` - Authentication flow (welcome, login, OTP verification)
- `home/` - Main app tabs (home, library, categories, settings)
- Individual content screens (profile, subscription, search, etc.)

**UI Components (`/widgets/`)**
- `app_bar/` - Custom app bar components
- `buttons/` - Standardized button components
- `cards/` - Content display cards
- `banners/` - Promotional and informational banners
- `text/` - Typography components following design system
- `waveform/` - Audio waveform visualization components

**Theme System (`/theme/`)**
- `app_theme.dart` - Main theme configuration
- `app_colors.dart` - Color palette definitions
- `app_text_styles.dart` - Typography scale
- `app_spacing.dart` - Spacing constants and layout standards
- `app_icons.dart` - Icon definitions and mappings

### Platform-Specific Configuration

#### Android (`/android/`)
- **Deep Linking**: Configured for `https://siraaj.app` and `siraaj://` schemes
- **Permissions**: Internet access for streaming and API calls
- **Build Configuration**: Gradle setup for release builds

#### iOS (`/ios/`)
- **Deep Linking**: URL schemes for universal links and custom schemes
- **Info.plist**: App metadata and platform-specific settings
- **Build Configuration**: Xcode project for App Store distribution

## Key Features & Implementation

### Authentication System
- **Email-based Authentication**: OTP verification flow
- **Token Management**: JWT tokens with automatic refresh
- **Persistent Sessions**: Secure token storage across app launches

### Audio Playback
- **Streaming Support**: Progressive audio loading
- **Background Playback**: Continues when app is in background
- **Waveform Visualization**: Visual representation of audio files
- **Playback Controls**: Speed adjustment, seeking, chapter navigation

### Navigation & Deep Linking
- **Declarative Routing**: URL-based navigation with go_router
- **Deep Link Support**: Direct links to specific content (books, authors, chapters)
- **Cross-Platform URLs**: Shareable links that work on web and mobile

### State Management
- **Reactive Updates**: Automatic UI updates when state changes
- **Persistent State**: User preferences and session data preservation
- **Async Operations**: Proper handling of network requests and loading states

### Theme System
- **Material Design 3**: Modern Material You theming
- **Multi-Theme Support**: Light, dark, and system themes
- **Consistent Spacing**: Standardized layout measurements
- **Typography Scale**: Hierarchical text styling

## Development Workflow

### Backend Development
1. **Database Changes**: Update `schema.prisma` and run migrations
2. **API Development**: Create controllers, services, and DTOs in NestJS
3. **Testing**: Unit and integration tests for all endpoints

### Frontend Development
1. **State Management**: Define providers for new features
2. **UI Development**: Create screens and widgets following design system
3. **Navigation**: Update router configuration for new screens
4. **Integration**: Connect UI to backend APIs through services

### Deployment Considerations
- **Backend**: Production deployment with proper environment variables
- **Database**: PostgreSQL with connection pooling and backup strategies
- **Frontend**: Platform-specific builds (Android APK/AAB, iOS IPA)
- **Deep Links**: Domain verification for universal links

## Security Features
- **Token-based Authentication**: JWT with secure storage
- **HTTPS Enforcement**: All API communications encrypted
- **Input Validation**: Comprehensive validation on both client and server
- **Deep Link Validation**: Secure handling of external URL schemes

## Performance Optimizations
- **Lazy Loading**: Screens and heavy components loaded on demand
- **Audio Caching**: Efficient audio file caching for offline playback
- **Image Optimization**: Proper image loading and caching strategies
- **Database Indexing**: Optimized queries with proper database indexes

This technical overview provides the foundation for understanding the Siraaj platform architecture and development approach.