# Siraaj - Technical Information

## Project Overview

Siraaj is a comprehensive audiobook and Islamic learning platform built with Flutter. The platform supports premium audio streaming, subscription management with trial restrictions, user progress tracking, and sophisticated content access controls.

## Project Structure

### Root Directory
```
siraaj/frontend/
├── lib/                 # Main application code
├── android/            # Android platform configuration
├── ios/               # iOS platform configuration
├── docs/              # Project documentation
├── assets/            # Static assets (audio samples, images)
└── pubspec.yaml       # Dependencies and project configuration
```

## Frontend Architecture

### Core Framework & Libraries
- **Flutter**: Google's UI toolkit for cross-platform development
- **Riverpod**: Advanced state management solution with providers
- **go_router**: Declarative routing with deep linking support
- **just_audio**: Professional audio playback functionality
- **audio_service**: Background audio playback with native controls
- **shared_preferences**: Persistent local storage
- **google_fonts**: Typography system integration

### Architecture Patterns
- **Provider Pattern**: State management using Riverpod providers
- **Service Layer**: Abstracted business logic and external integrations
- **Widget Composition**: Reusable UI components following Flutter best practices
- **Repository Pattern**: Data layer abstraction with mock data system

### Key Directories

#### `/lib/` - Main Application Code
```
lib/
├── main.dart              # Application entry point
├── data/                  # Mock data and business logic constants
├── models/                # Data models and state classes
├── providers/             # Riverpod providers for state management
├── router/                # Navigation and routing configuration
├── screens/               # UI screens and pages
├── services/              # Business logic and platform integrations
├── theme/                 # Complete design system and theming
└── widgets/               # Reusable UI components library
```

#### Advanced Directory Structure

**State Management (`/providers/`)**
- `auth_provider.dart` - User authentication and session management
- `theme_provider.dart` - Dynamic theme switching (light/dark/system)
- `audio_provider.dart` - Advanced audio playback controls and state
- `subscription_provider.dart` - **NEW**: Trial usage tracking and premium access control
- `locale_provider.dart` - Internationalization and language settings

**Services (`/services/`)**
- `token_service.dart` - Secure JWT token management and storage
- `preferences_service.dart` - User preferences persistence layer
- `audio_service.dart` - Native audio playback with background support
- `deep_link_service.dart` - Deep linking URL generation and parsing

**Screens (`/screens/`)**
- `auth/` - Complete authentication flow (welcome, login, OTP verification)
- `home/` - Main navigation tabs (home, library, categories, settings)
- `chapter_screen.dart` - **ENHANCED**: Premium content with trial restrictions
- `playlist_screen.dart` - **ENHANCED**: Trial-aware content access controls
- `subscription_screen.dart` - **ENHANCED**: Trial feature descriptions

**Enhanced UI Components (`/widgets/`)**
- `trial/` - **NEW**: Trial user experience components
  - `glimpse_into_premium_stats.dart` - Usage tracking and upgrade prompts
- `banners/` - Premium upgrade banners with trial-aware visibility
- `buttons/` - Action buttons with trial access restrictions
- `waveform/` - Audio visualization with interaction controls
- `premium/` - Premium content sections with access gating

## Key Features & Advanced Implementation

### Authentication System
- **Email-based Authentication**: Streamlined OTP verification flow
- **Token Management**: JWT tokens with automatic refresh mechanisms
- **Persistent Sessions**: Secure token storage across app launches
- **User Roles**: Trial, Premium, and Free user distinctions

### Premium Content & Trial System

#### **Trial Usage Tracking**
- **Monthly Allowance**: 15 minutes of premium content per 30-day cycle
- **Granular Tracking**: Session-based usage monitoring
- **Automatic Reset**: Monthly usage counter reset functionality
- **Usage Analytics**: Detailed tracking for business intelligence

#### **Database Schema Integration**
```sql
-- Trial Usage Tracking Tables
TrialUsage {
  userId: String (unique)
  minutesUsed: Int (0-15 monthly limit)
  maxMinutes: Int (configurable, default 15)
  currentMonth/Year: Int (reset tracking)
  lastResetAt: DateTime
}

TrialUsageSession {
  trialUsageId: String
  contentId: String
  minutesListened: Int
  sessionDate: DateTime
  contentTitle: String (historical reference)
}
```

#### **Access Control System**
- **Content Gating**: Premium content locked when trial limit exceeded
- **Progressive Disclosure**: Trial users see premium content but with restrictions
- **Graceful Degradation**: Disabled controls with clear upgrade messaging

### Advanced Audio System

#### **Playback Features**
- **Streaming Support**: Progressive audio loading with caching
- **Background Playback**: Continuous playback with native media controls
- **Waveform Visualization**: Interactive audio visualization
- **Advanced Controls**: Speed adjustment, precise seeking, chapter navigation

#### **Trial Restrictions**
- **Seekbar Interaction**: Disabled for premium content when trial limit reached
- **Skip Controls**: Forward/backward buttons restricted for trial users
- **Note Taking**: Add note functionality gated for premium content
- **Timestamp Navigation**: Bottom sheet timestamps disabled for trial users

### Enhanced Navigation & Deep Linking

#### **Routing System**
- **Declarative Routing**: URL-based navigation with go_router
- **Deep Link Support**: Direct links to content (books, authors, chapters, playlists)
- **Cross-Platform URLs**: Universal links for web and mobile sharing
- **Protected Routes**: Subscription-aware navigation guards

#### **Route Examples**
```dart
// Content access routes
/home/playlist/:contentId
/home/chapter/:chapterId/:contentId
/home/subscription (trial upgrade flows)

// Deep linking support
https://siraaj.app/content/premium-book-id
siraaj://chapter/chapter-id/content-id
```

### State Management Architecture

#### **Subscription Provider System**
```dart
// Core subscription state management
SubscriptionState {
  status: SubscriptionStatus (freeTrial/premium/free)
  trialUsage: TrialUsageData?
  canAccessPremiumContent: bool
  shouldShowPremiumAds: bool
}

// Granular provider optimization
- isFreeTrialProvider
- isPremiumProvider
- canAccessPremiumContentProvider
- trialUsageDataProvider
```

#### **Trial Usage Management**
- **Real-time Updates**: Live usage tracking during playback
- **Persistent State**: Trial usage preserved across app sessions
- **Reactive UI**: Automatic updates when trial limits change
- **Error Handling**: Graceful handling of usage calculation edge cases

### Premium User Experience

#### **GlimpseIntoPremiumStats Widget**
- **Usage Visualization**: Progress bars and statistics display
- **Multiple Layouts**: Full dashboard and compact FloatingActionButton versions
- **Upgrade Integration**: Seamless flow to subscription pages
- **Responsive Design**: Adapts to different screen sizes and orientations

#### **Content Access Patterns**
```dart
// PlaylistScreen: Hide Play/Download for trial users
if (isFreeTrial && isPremiumContent && !hasRemainingTime) {
  // Show locked content message
  // Display upgrade prompts
  // Hide action buttons
}

// ChapterScreen: Comprehensive control restrictions
if (isTrialUserOnPremiumContent && noTimeRemaining) {
  // Disable seekbar interaction
  // Disable skip buttons (visual feedback)
  // Disable note-taking functionality
  // Disable timestamp navigation
  // Show FloatingActionButton with trial stats
}
```

### Theme System & Design

#### **Material Design 3 Implementation**
- **Dynamic Color**: Material You color system
- **Multi-Theme Support**: Light, dark, and system preference themes
- **Consistent Spacing**: Standardized layout measurements
- **Typography Scale**: Hierarchical text styling with semantic naming

#### **Trial-Aware UI Components**
- **Disabled States**: Visual feedback for restricted premium features
- **Progressive Enhancement**: Clear upgrade paths throughout the app
- **Accessibility**: Screen reader support for trial restriction messaging
- **Color Coding**: Visual indicators for premium vs. free content

### Platform-Specific Configuration

#### **Android (`/android/`)**
- **Audio Permissions**: WAKE_LOCK, FOREGROUND_SERVICE, MEDIA_PLAYBACK permissions
- **Audio Service**: Background audio service declaration
- **Deep Linking**: Configured for `https://siraaj.app` and `siraaj://` schemes
- **Build Configuration**: Gradle setup with audio optimization

#### **iOS (`/ios/`)**
- **Audio Session**: Background audio capability configuration
- **Deep Linking**: URL schemes for universal links
- **Info.plist**: Platform-specific audio and networking permissions
- **Build Configuration**: Xcode project for App Store distribution

## Development Workflow

### Feature Development Process
1. **State Design**: Define providers and state models for new features
2. **UI Development**: Create screens and widgets following design system
3. **Access Control**: Implement subscription-aware logic
4. **Navigation**: Update router configuration for new flows
5. **Testing**: Verify trial restrictions and premium access patterns

### Trial System Testing

#### **Test User Accounts**
The following test accounts are available in development mode (OTP: `123456` for all):

- **trial@example.com**: Trial user with 8/15 minutes used (53% usage)
- **premium@example.com**: Premium subscriber with unlimited access
- **free@example.com**: Free user (trial expired, no premium access)
- **new@example.com**: New trial user with 2/15 minutes used (13% usage)

#### **Testing Scenarios**
- **Usage Limits**: Verify 15-minute monthly restrictions
- **UI States**: Test disabled controls and upgrade flows
- **Edge Cases**: Handle usage calculation and reset scenarios
- **Cross-Platform**: Ensure consistent behavior on Android and iOS
- **Subscription Flows**: Test transitions between trial/premium/free states

### Code Quality Standards
- **State Immutability**: All state changes through proper copying
- **Error Handling**: Comprehensive error boundaries and fallbacks
- **Performance**: Optimized rebuilds with selective providers
- **Accessibility**: Screen reader support and semantic markup

## Security & Performance

### Security Features
- **Token-based Authentication**: JWT with secure storage
- **Input Validation**: Comprehensive validation throughout the app
- **Deep Link Validation**: Secure handling of external URL schemes
- **Premium Content Protection**: Server-side validation for content access

### Performance Optimizations
- **Selective Rebuilds**: Granular provider system prevents unnecessary rebuilds
- **Audio Caching**: Efficient streaming with progressive loading
- **Image Optimization**: Lazy loading and memory management
- **Trial Calculations**: Optimized usage tracking with minimal overhead

### Memory Management
- **Provider Lifecycle**: Proper disposal of audio and state providers
- **Audio Resources**: Efficient cleanup of audio sessions
- **Widget Optimization**: Const constructors and widget reuse patterns

## Deployment & Distribution

### Build Configuration
- **Release Builds**: Optimized Flutter builds for production
- **Code Signing**: Platform-specific signing for app stores
- **Asset Optimization**: Compressed audio samples and images
- **Performance Monitoring**: Crash reporting and analytics integration

### Feature Flags
- **Trial Limits**: Configurable usage limits (15-minute default)
- **Premium Features**: Toggleable premium functionality
- **UI Experiments**: A/B testing for subscription conversion

This comprehensive technical overview documents the complete Siraaj platform architecture with detailed focus on the advanced trial user restriction system and premium content access controls.