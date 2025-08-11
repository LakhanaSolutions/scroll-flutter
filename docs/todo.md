# TODO Items

This document tracks all TODO items throughout the Scroll Frontend codebase.

## Settings & Preferences

### TODO-001: Implement text size setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:240`
**Description**: Implement text size setting functionality
**Priority**: Medium

### TODO-002: Implement text size setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:256`
**Description**: Implement text size setting functionality (duplicate)
**Priority**: Medium

### TODO-003: Implement language setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:307`
**Description**: Implement language setting functionality
**Priority**: Medium

### TODO-004: Implement audio quality setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:386`
**Description**: Implement audio quality setting functionality
**Priority**: Medium

### TODO-005: Implement audio quality setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:420`
**Description**: Implement audio quality setting functionality (duplicate)
**Priority**: Medium

### TODO-006: Implement download quality setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:475`
**Description**: Implement download quality setting functionality
**Priority**: Medium

### TODO-007: Implement download quality setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:497`
**Description**: Implement download quality setting functionality (duplicate)
**Priority**: Medium

### TODO-008: Implement playback speed setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:549`
**Description**: Implement playback speed setting functionality
**Priority**: Medium

### TODO-009: Implement playback speed setting
**Location**: `lib/widgets/bottom_sheets/settings_modals.dart:563`
**Description**: Implement playback speed setting functionality (duplicate)
**Priority**: Medium

## Core Functionality

### TODO-010: Implement actual save functionality
**Location**: `lib/screens/note_screen.dart:161`
**Description**: Implement actual save functionality for notes
**Priority**: High

### TODO-011: Implement actual payment processing
**Location**: `lib/screens/upgrade_plan_screen.dart:532`
**Description**: Implement actual payment processing for subscription upgrades
**Priority**: High

### TODO-012: Replace with actual API call
**Location**: `lib/screens/privacy_policy_screen.dart:33`
**Description**: Replace mock privacy policy content with actual API call
**Priority**: Medium

### TODO-013: Implement profile submission functionality
**Location**: `lib/screens/finish_profile_screen.dart:40`
**Description**: Implement actual profile submission functionality for new users
**Priority**: High

### TODO-014: Implement logout functionality
**Location**: `lib/screens/finish_profile_screen.dart:50`
**Description**: Implement logout functionality in finish profile screen
**Priority**: Medium

### TODO-015: Replace with actual API call
**Location**: `lib/screens/help_support_screen.dart:62`
**Description**: Replace mock FAQ data with actual API call
**Priority**: Medium

### TODO-016: Open email client
**Location**: `lib/screens/help_support_screen.dart:326`
**Description**: Implement functionality to open email client for support
**Priority**: Low

### TODO-017: Open chat or phone
**Location**: `lib/screens/help_support_screen.dart:337`
**Description**: Implement functionality to open chat or phone for support
**Priority**: Low

### TODO-018: Implement actual feedback submission API call
**Location**: `lib/screens/send_feedback_screen.dart:88`
**Description**: Implement actual feedback submission API call
**Priority**: Medium

### TODO-019: Implement save functionality
**Location**: `lib/screens/profile_screen.dart:32`
**Description**: Implement save functionality for profile updates
**Priority**: High

### TODO-020: Navigate to landing page or show more info
**Location**: `lib/screens/auth/login_screen.dart:82`
**Description**: Implement navigation to landing page or show more info
**Priority**: Medium

### TODO-021: Replace with actual API call
**Location**: `lib/screens/terms_of_service_screen.dart:34`
**Description**: Replace mock terms of service content with actual API call
**Priority**: Medium

## Notifications & Settings

### TODO-022: Implement saving notification preferences
**Location**: `lib/screens/notifications_screen.dart:121`
**Description**: Implement saving notification preferences functionality
**Priority**: Medium

### TODO-023: Show time picker for quiet hours
**Location**: `lib/screens/notifications_screen.dart:325`
**Description**: Implement time picker for quiet hours functionality
**Priority**: Low

## Subscription & Device Management

### TODO-024: Navigate to manage subscription
**Location**: `lib/screens/subscription_history_screen.dart:404`
**Description**: Implement navigation to manage subscription
**Priority**: Medium

### TODO-025: Implement device logout
**Location**: `lib/screens/manage_devices_screen.dart:205`
**Description**: Implement device logout functionality
**Priority**: High

### TODO-026: Implement logout all devices
**Location**: `lib/screens/manage_devices_screen.dart:239`
**Description**: Implement logout all devices functionality
**Priority**: High

## Media & Content

### TODO-027: Implement voice sample playback
**Location**: `lib/screens/narrator_screen.dart:62`
**Description**: Implement voice sample playback functionality for narrators
**Priority**: Medium

---

## Summary

**Total TODO Items**: 27
- **High Priority**: 6 items
- **Medium Priority**: 18 items  
- **Low Priority**: 3 items

### Priority Breakdown

#### High Priority (6 items)
- Save functionality (notes, profile)
- Payment processing
- Profile submission
- Device management (logout functionality)

#### Medium Priority (18 items)
- Settings implementation (text size, language, audio quality, download quality, playback speed)
- API integration (privacy policy, help support, terms of service, feedback)
- Navigation improvements
- Notification preferences
- Voice sample playback

#### Low Priority (3 items)
- External app integration (email, chat, phone)
- Time picker for quiet hours

### Recommended Development Order

1. **Phase 1**: Complete high-priority core functionality items (TODO-010, TODO-011, TODO-013, TODO-019, TODO-025, TODO-026)
2. **Phase 2**: Implement API integrations (TODO-012, TODO-015, TODO-018, TODO-021)
3. **Phase 3**: Add settings functionality (TODO-001 through TODO-009)
4. **Phase 4**: Enhance user experience features (remaining medium priority items)
5. **Phase 5**: Complete nice-to-have features (low priority items)