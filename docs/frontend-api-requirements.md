# Frontend API Requirements

This document outlines all API endpoints required by the Scroll Flutter frontend application, organized by database table and corresponding screens. This will guide the backend API implementation to replace all mock data with real API calls.

## Overview

The Scroll app requires comprehensive API endpoints to support:
- Authentication and user management
- Content discovery and playback
- Subscription management
- User interactions (reviews, bookmarks, notes)
- Search and recommendations
- Social features (following authors/narrators)
- Trial usage tracking
- Settings and preferences

---

## 1. Authentication & User Management

### Database Tables: `users`, `sessions`, `accounts`, `verification_tokens`

#### Auth Screen (`auth_screen.dart`, `login_screen.dart`, `otp_verification_screen.dart`)
- `POST /api/auth/request-otp` - Request OTP for email
- `POST /api/auth/verify-otp` - Verify OTP and authenticate
- `POST /api/auth/resend-otp` - Resend OTP
- `POST /api/auth/refresh-token` - Refresh authentication token
- `POST /api/auth/logout` - Logout user
- `GET /api/auth/me` - Get current user info

#### Profile Management (`profile_screen.dart`, `finish_profile_screen.dart`)
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `POST /api/users/profile/avatar` - Upload profile avatar
- `GET /api/users/profile/stats` - Get user listening stats

#### Device Management (`manage_devices_screen.dart`)
- `GET /api/users/sessions` - Get active user sessions/devices
- `DELETE /api/users/sessions/:sessionId` - Logout specific device
- `DELETE /api/users/sessions` - Logout all devices

---

## 2. Content Management System

### Database Tables: `content`, `chapters`, `authors`, `narrators`, `categories`, `mood_categories`

#### Home Screen (`home_tab.dart`, `home_screen.dart`)
- `GET /api/content/featured` - Get featured content for home
- `GET /api/content/audiobook-of-week` - Get weekly featured audiobook
- `GET /api/content/recently-added` - Get recently added content
- `GET /api/mood-categories` - Get mood-based content categories
- `GET /api/mood-categories/:id/content` - Get content for specific mood

#### Content Discovery (`category_view_screen.dart`, `mood_screen.dart`)
- `GET /api/categories` - Get all content categories
- `GET /api/categories/:id` - Get specific category details
- `GET /api/categories/:id/content` - Get content in category
- `GET /api/content/:id` - Get detailed content information
- `GET /api/content/:id/chapters` - Get chapters for content

#### Content Playback (`chapter_screen.dart`, `playlist_screen.dart`)
- `GET /api/chapters/:id` - Get chapter details
- `GET /api/chapters/:id/audio-url` - Get chapter audio streaming URL
- `GET /api/chapters/:id/waveform` - Get audio waveform data
- `POST /api/content/:id/view` - Track content view
- `POST /api/content/:id/play` - Track content play

#### Authors & Narrators (`author_screen.dart`, `narrator_screen.dart`, `authors_list_screen.dart`, `narrators_list_screen.dart`)
- `GET /api/authors` - Get all authors (paginated)
- `GET /api/authors/:id` - Get author details
- `GET /api/authors/:id/content` - Get content by author
- `GET /api/narrators` - Get all narrators (paginated)
- `GET /api/narrators/:id` - Get narrator details
- `GET /api/narrators/:id/content` - Get content by narrator
- `GET /api/narrators/:id/voice-sample` - Get narrator voice sample

---

## 3. User Interactions & Progress

### Database Tables: `recently_played`, `bookmarks`, `notes`, `reviews`, `review_votes`

#### Recently Played & Progress (`home_tab.dart`, `library_tab.dart`)
- `GET /api/users/recently-played` - Get user's recently played content
- `POST /api/users/recently-played` - Update recently played item
- `PUT /api/users/recently-played/:id` - Update playback progress
- `DELETE /api/users/recently-played/:id` - Remove from recently played

#### Bookmarks (`bookmarks_screen.dart`)
- `GET /api/users/bookmarks` - Get user's bookmarked content
- `POST /api/users/bookmarks` - Add bookmark
- `DELETE /api/users/bookmarks/:id` - Remove bookmark
- `PUT /api/users/bookmarks/:id` - Update bookmark note

#### Notes System (`note_screen.dart`)
- `GET /api/users/notes` - Get user's notes
- `GET /api/content/:id/notes` - Get notes for specific content
- `POST /api/users/notes` - Create new note
- `PUT /api/users/notes/:id` - Update note
- `DELETE /api/users/notes/:id` - Delete note

#### Reviews & Ratings (`reviews_screen.dart`)
- `GET /api/content/:id/reviews` - Get reviews for content
- `GET /api/content/:id/review-summary` - Get review summary/stats
- `POST /api/content/:id/reviews` - Submit review
- `PUT /api/reviews/:id` - Update user's review
- `DELETE /api/reviews/:id` - Delete user's review
- `POST /api/reviews/:id/vote` - Vote on review (upvote/downvote)
- `DELETE /api/reviews/:id/vote` - Remove vote on review

---

## 4. Downloads & Offline Content

### Database Tables: `downloads`

#### Downloads Management (`downloads_screen.dart`)
- `GET /api/users/downloads` - Get user's downloaded content
- `POST /api/users/downloads` - Start content download
- `GET /api/users/downloads/:id/status` - Get download progress
- `DELETE /api/users/downloads/:id` - Cancel/remove download
- `GET /api/content/:id/download-info` - Get download size/quality options

---

## 5. Search & Discovery

### Database Tables: `search_history`

#### Search (`search_screen.dart`)
- `GET /api/search` - Global search (content, authors, narrators, chapters)
- `GET /api/search/suggestions` - Get search suggestions
- `GET /api/search/trending` - Get trending search topics
- `GET /api/search/popular-tags` - Get popular tags
- `GET /api/users/search-history` - Get user's search history
- `POST /api/users/search-history` - Save search query
- `DELETE /api/users/search-history` - Clear search history

---

## 6. Social Features

### Database Tables: `user_author_follows`, `user_narrator_follows`

#### Following System (`following_screen.dart`, `author_screen.dart`, `narrator_screen.dart`)
- `GET /api/users/following/authors` - Get followed authors
- `GET /api/users/following/narrators` - Get followed narrators
- `POST /api/authors/:id/follow` - Follow author
- `DELETE /api/authors/:id/follow` - Unfollow author
- `POST /api/narrators/:id/follow` - Follow narrator
- `DELETE /api/narrators/:id/follow` - Unfollow narrator
- `GET /api/users/following/updates` - Get updates from followed creators

---

## 7. Subscription Management

### Database Tables: `subscriptions`, `subscription_plans`, `subscription_history`, `trial_usage`, `trial_usage_sessions`

#### Subscription & Plans (`subscription_screen.dart`, `upgrade_plan_screen.dart`)
- `GET /api/subscription-plans` - Get available subscription plans
- `GET /api/users/subscription` - Get user's current subscription
- `POST /api/users/subscription/upgrade` - Upgrade subscription
- `POST /api/users/subscription/cancel` - Cancel subscription
- `PUT /api/users/subscription/payment-method` - Update payment method

#### Subscription History (`subscription_history_screen.dart`)
- `GET /api/users/subscription/history` - Get subscription billing history
- `GET /api/users/subscription/invoices` - Get invoices
- `GET /api/users/subscription/invoices/:id/download` - Download invoice

#### Trial Usage Tracking
- `GET /api/users/trial-usage` - Get trial usage statistics
- `POST /api/users/trial-usage/session` - Log trial usage session
- `GET /api/users/trial-usage/remaining` - Get remaining trial minutes

---

## 8. Notifications

### Database Tables: `notifications`

#### Notifications (`notifications_screen.dart`, `notification_area.dart`)
- `GET /api/users/notifications` - Get user notifications
- `PUT /api/users/notifications/:id/read` - Mark notification as read
- `DELETE /api/users/notifications/:id` - Dismiss notification
- `PUT /api/users/notifications/read-all` - Mark all notifications as read
- `DELETE /api/users/notifications` - Clear all notifications

---

## 9. User Preferences & Settings

### Database Tables: `user_preferences`

#### Settings & Preferences (`settings_tab.dart`, `settings_modals.dart`)
- `GET /api/users/preferences` - Get user preferences
- `PUT /api/users/preferences` - Update user preferences
- `PUT /api/users/preferences/theme` - Update theme preference
- `PUT /api/users/preferences/language` - Update language preference
- `PUT /api/users/preferences/audio` - Update audio settings (speed, quality)
- `PUT /api/users/preferences/notifications` - Update notification preferences

---

## 10. Audio Sessions & Playback

### Database Tables: `audio_sessions`

#### Audio Player & Sessions
- `GET /api/users/audio-sessions` - Get active audio sessions
- `POST /api/users/audio-sessions` - Create audio session
- `PUT /api/users/audio-sessions/:id` - Update session progress
- `DELETE /api/users/audio-sessions/:id` - End audio session
- `GET /api/content/:id/playback-info` - Get playback information (quality options, etc.)

---

## 11. Support & Feedback

### Database Tables: `feedback`

#### Help & Support (`help_support_screen.dart`, `send_feedback_screen.dart`)
- `GET /api/support/faq` - Get FAQ content
- `POST /api/support/feedback` - Submit feedback/support request
- `GET /api/support/contact-info` - Get contact information
- `POST /api/support/contact` - Submit contact form

---

## 12. Static Content

#### Legal & Info (`privacy_policy_screen.dart`, `terms_of_service_screen.dart`, `about_screen.dart`)
- `GET /api/content/privacy-policy` - Get privacy policy
- `GET /api/content/terms-of-service` - Get terms of service
- `GET /api/content/about` - Get about page content
- `GET /api/content/app-info` - Get app version/build info

---

## API Response Patterns

### Standard Response Format
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Success message",
  "meta": {
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

### Error Response Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
```

### Pagination
Most list endpoints should support pagination with query parameters:
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 20, max: 100)
- `sort` - Sort field
- `order` - Sort order (asc/desc)

### Filtering & Search
Many endpoints should support filtering:
- `q` - Search query
- `category` - Filter by category
- `availability` - Filter by availability (free/premium/trial)
- `language` - Filter by language
- `rating` - Minimum rating filter

---

## Authentication & Authorization

### Authentication Headers
All protected endpoints require:
```
Authorization: Bearer <jwt_token>
```

### User Roles
- `USER` - Basic trial user
- `PREMIUM` - Premium subscriber
- `ADMIN` - Administrator
- `MODERATOR` - Content moderator

### Access Control
- Trial users: Limited access to premium content (15 minutes/month)
- Premium users: Full access to all content
- Admins: Access to admin endpoints
- Moderators: Access to content moderation endpoints

---

## Real-time Features (Future)

### WebSocket Events
For real-time features:
- `playback:sync` - Sync playback across devices
- `notification:new` - New notification received
- `download:progress` - Download progress update
- `session:expired` - Session expired notification

---

## File Upload Endpoints

### Media Uploads
- `POST /api/upload/avatar` - Upload user avatar
- `POST /api/upload/content-cover` - Upload content cover image
- `POST /api/upload/feedback-attachment` - Upload feedback attachment

### Upload Response Format
```json
{
  "success": true,
  "data": {
    "url": "https://cdn.scroll.app/uploads/avatar_123.jpg",
    "filename": "avatar_123.jpg",
    "size": 154620,
    "mimeType": "image/jpeg"
  }
}
```

---

## Caching Strategy

### Client-side Caching
- Content metadata: 1 hour
- User preferences: Until logout
- Categories and mood categories: 6 hours
- Search results: 30 minutes

### CDN Caching
- Audio files: Indefinite with versioning
- Cover images: 24 hours
- Static content: 1 week

---

## Rate Limiting

### API Rate Limits
- Authentication endpoints: 5 requests/minute
- Search endpoints: 30 requests/minute
- Content endpoints: 100 requests/minute
- General endpoints: 200 requests/minute

---

## Implementation Priority

### Phase 1 (High Priority)
1. Authentication & user management
2. Content discovery and basic playback
3. User preferences
4. Recently played and progress tracking

### Phase 2 (Medium Priority)
1. Reviews and ratings
2. Bookmarks and notes
3. Search functionality
4. Following system

### Phase 3 (Low Priority)
1. Download management
2. Advanced notifications
3. Social stats and sharing
4. Feedback system

---

## Testing Requirements

### Mock Data Migration
Each API endpoint should initially return the same structure as the current mock data to ensure smooth migration.

### Test Users
Maintain test users for different subscription states:
- `trial@example.com` - Trial user (8/15 minutes used)
- `premium@example.com` - Premium subscriber
- `free@example.com` - Expired trial user
- `new@example.com` - New trial user (2/15 minutes used)

### Error Scenarios
Test all error scenarios:
- Network errors
- Authentication failures
- Rate limiting
- Trial limit exceeded
- Content not available

---

This comprehensive API specification covers all frontend requirements and ensures a smooth transition from mock data to real API integration. Each endpoint should be implemented with proper error handling, validation, and security measures.