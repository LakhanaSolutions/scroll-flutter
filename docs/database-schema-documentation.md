# Siraaj Database Schema Documentation

## Overview

This document describes the comprehensive database schema for the Siraaj audiobook and learning platform. The schema is designed for PostgreSQL and includes BetterAuth compatibility for authentication and session management.

## Table of Contents

1. [Authentication & User Management](#authentication--user-management)
2. [Content Management System](#content-management-system)
3. [User Interaction & Progress Tracking](#user-interaction--progress-tracking)
4. [Subscription & Payment System](#subscription--payment-system)
5. [Audio Player & Session Management](#audio-player--session-management)
6. [Notifications & Communication](#notifications--communication)
7. [User Preferences & Settings](#user-preferences--settings)
8. [Search & Discovery](#search--discovery)
9. [Feedback & Support](#feedback--support)
10. [Relationships Overview](#relationships-overview)
11. [Indexes & Performance](#indexes--performance)

## Authentication & User Management

### Core Authentication Tables

**Users Table**
- Primary user entity with BetterAuth compatibility
- Supports both email/password and OAuth authentication
- Includes profile information (name, bio, nationality)
- Tracks user state (isNew, isActive, lastLoginAt)

**Sessions Table**
- Manages user sessions with expiration
- Tracks device and browser information
- Supports multiple concurrent sessions

**Accounts Table**
- Links users to external OAuth providers
- Stores OAuth tokens and provider-specific data

**Verification Tokens**
- Handles email verification and password reset flows
- Time-limited tokens with expiration

### User Roles
- `USER`: Standard user with basic access
- `PREMIUM`: Paid subscriber with premium content access
- `ADMIN`: Full administrative access
- `MODERATOR`: Content moderation capabilities

## Content Management System

### Core Content Tables

**Content Table**
- Central table for all audio content (books, podcasts, series)
- Rich metadata including duration, ratings, view counts
- Support for multiple content types and availability levels
- SEO-friendly with slugs, tags, and keywords

**Chapters Table**
- Individual chapters/episodes within content
- Audio metadata and transcript support
- Hierarchical structure with chapter numbering

**Authors & Narrators**
- Separate entities for content creators and voice artists
- Rich profile information including bios, awards, social links
- Rating and follower systems

**Categories & Mood Categories**
- Hierarchical category system for content organization
- Mood-based content grouping for personalized recommendations
- Featured and sorting capabilities

### Junction Tables
- `ContentAuthor`: Many-to-many relationship with role support
- `ContentNarrator`: Links content to voice artists
- `ContentCategory`: Content categorization
- `MoodContent`: Mood-based content associations
- `UserAuthorFollow`: User following system for authors
- `UserNarratorFollow`: User following system for narrators

## User Interaction & Progress Tracking

**Recently Played**
- Tracks user listening history and progress
- Position tracking in seconds with percentage completion
- Playback speed and session duration tracking

**Downloads**
- Offline content management
- Download progress and file size tracking
- Quality settings and local file paths

**Bookmarks**
- User-saved content with optional notes
- Quick access to favorite content

**Reviews**
- User ratings and reviews (1-5 stars)
- Public/private visibility controls
- Aggregated ratings for content

**Notes System**
- Personal notes and highlights during listening
- Timestamp-based annotations
- Different note types (personal, highlight, thought)

## Subscription & Payment System

**Subscription Plans**
- Flexible plan definitions with pricing
- Feature and limitation specifications
- Stripe integration with external IDs

**User Subscriptions**
- Current subscription status and billing periods
- Stripe customer and subscription linking
- Cancellation and renewal management

**Subscription History**
- Complete billing and payment history
- Transaction tracking with external references
- Audit trail for billing disputes

## Audio Player & Session Management

**Audio Sessions**
- Current playback state and position tracking
- Multi-device session support
- Quality and volume preferences
- Device-specific metadata

## Notifications & Communication

**Notifications**
- In-app notification system
- Multiple notification types (info, warning, promotion)
- Scheduling support for future notifications
- Read/unread and archival states

## User Preferences & Settings

**User Preferences**
- Comprehensive user settings management
- Theme, language, and display preferences
- Audio playback defaults
- Notification preferences
- Privacy and content settings

## Search & Discovery

**Search History**
- User search query tracking
- Filter and result count logging
- Personalization and recommendation data

## Feedback & Support

**Feedback System**
- User feedback and support requests
- Multiple feedback types (bug reports, feature requests)
- Priority and status tracking
- Admin assignment and notes

## Relationships Overview

### Key Relationships

1. **User ↔ Content**: Many-to-many through various interaction tables
2. **Content ↔ Authors/Narrators**: Many-to-many with role specifications
3. **Content ↔ Categories**: Many-to-many hierarchical relationships
4. **User ↔ Subscriptions**: One-to-many with history tracking
5. **Content ↔ Chapters**: One-to-many hierarchical structure

### Cascade Behaviors

- User deletion cascades to all user-generated content and sessions
- Content deletion cascades to chapters and user interactions
- Soft deletion patterns for critical data (content, users)

## Indexes & Performance

### Primary Indexes

1. **Content Discovery**
   - `content(type, availability, status)`
   - `content(isPremium, isFeatured)`
   - `content(publishedAt)`

2. **User Activity**
   - `recently_played(userId, lastPlayedAt)`
   - `notifications(userId, isRead, createdAt)`
   - `search_history(userId, createdAt)`

3. **Content Relationships**
   - `content_authors(contentId, sortOrder)`
   - `chapters(contentId, chapterNumber)`
   - `categories(parentId, sortOrder)`

### Performance Considerations

- UUID/CUID primary keys for distributed systems
- Proper indexing for common query patterns
- JSON fields for flexible metadata storage
- Decimal precision for financial data

## BetterAuth Integration

The schema is designed to be compatible with BetterAuth:

1. **Standard Authentication Fields**: Compatible with BetterAuth's expected user/session structure
2. **OAuth Support**: Account linking for social login providers
3. **Session Management**: Token-based session handling
4. **Verification System**: Email verification and password reset flows

## Migration Strategy

### Initial Setup
1. Create database and install PostgreSQL extensions
2. Run Prisma migrations to create schema
3. Seed initial data (categories, subscription plans)
4. Set up BetterAuth configuration

### Data Migration
1. User data migration with role assignment
2. Content import with proper categorization
3. Subscription data transfer with billing history
4. Audio progress and user preferences migration

## Scaling Considerations

1. **Horizontal Scaling**: UUID primary keys support sharding
2. **Read Replicas**: Query routing for read-heavy operations
3. **Caching Strategy**: Redis integration for frequently accessed data
4. **File Storage**: External storage for audio files and images
5. **Search Engine**: Elasticsearch integration for advanced search

## Security & Privacy

1. **Data Encryption**: Sensitive fields encrypted at rest
2. **Access Control**: Row-level security policies
3. **Audit Logging**: Change tracking for critical operations
4. **GDPR Compliance**: User data export and deletion capabilities
5. **Rate Limiting**: API throttling and abuse prevention

## Future Enhancements

1. **Social Features**: Friend systems and content sharing
2. **Analytics**: Detailed listening analytics and insights
3. **Recommendations**: ML-based content recommendation engine
4. **Live Content**: Real-time streaming and live events
5. **Gamification**: Achievement and progress tracking systems