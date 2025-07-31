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
8. [Trial Usage Tracking](#trial-usage-tracking)
9. [Search & Discovery](#search--discovery)
10. [Feedback & Support](#feedback--support)
11. [Relationships Overview](#relationships-overview)
12. [Indexes & Performance](#indexes--performance)

## Authentication & User Management

### Core Authentication Tables

**Users Table**
- **Purpose**: Core user entity storing account information and profile data
- Primary user entity with BetterAuth compatibility
- Supports both email/password and OAuth authentication
- Includes profile information (name, bio, nationality)
- Tracks user state (isNew, isActive, lastLoginAt)
- Links to all user-related data (subscriptions, progress, bookmarks, etc.)

**Sessions Table**
- **Purpose**: Manages active user login sessions with security tracking
- Manages user sessions with expiration dates
- Tracks device and browser information for security
- Supports multiple concurrent sessions across devices
- Includes IP address and user agent for audit trails

**Accounts Table**
- **Purpose**: Links user accounts to external OAuth providers (Google, Apple, etc.)
- Stores OAuth provider connections and tokens
- Handles refresh tokens and provider-specific data
- Enables social login functionality
- Maintains provider account relationships

**Verification Tokens Table**
- **Purpose**: Handles secure email verification and password reset workflows
- Stores time-limited verification tokens
- Supports email verification during registration
- Enables secure password reset functionality
- Automatic cleanup of expired tokens

### User Roles
- `USER`: Standard user with basic access
- `PREMIUM`: Paid subscriber with premium content access
- `ADMIN`: Full administrative access
- `MODERATOR`: Content moderation capabilities

## Content Management System

### Core Content Tables

**Content Table**
- **Purpose**: Central repository for all audio content (audiobooks, podcasts, series)
- Stores core metadata: title, description, duration, ratings
- Manages content types (BOOK, PODCAST, AUDIOBOOK, SERIES)
- Handles availability levels (FREE, PREMIUM, TRIAL, PAID)
- SEO optimization with slugs, tags, and keywords
- Tracks engagement metrics (views, listening hours, ratings)

**Chapters Table**
- **Purpose**: Individual chapters or episodes within content items
- Hierarchical structure with chapter numbering and ordering
- Audio-specific metadata (duration, file URLs, transcripts)
- Links to primary narrators for chapter-specific voice artists
- Supports different chapter statuses (DRAFT, PUBLISHED, ARCHIVED)

**Waveform Table**
- **Purpose**: Stores audio visualization data for interactive player controls
- Contains normalized peak values for waveform rendering
- Configurable sample rate and resolution for different quality needs
- One-to-one relationship with chapters for efficient loading
- Enables users to visually navigate through audio content

**Authors Table**
- **Purpose**: Content creators and book authors with rich profile information
- Stores biographical data, nationality, birth year, awards
- Social media links and external website connections
- Follower system for user engagement (uses `followersCount` field)
- Genre specialization and book count tracking

**Narrators Table**
- **Purpose**: Voice artists who narrate audiobook content
- Professional information: experience, voice description, languages
- Rating system for narrator quality assessment
- Genre specialization and narration portfolio
- Social links and verification status
- Follower system (uses `followersCount` field)

**Categories Table**
- **Purpose**: Hierarchical content organization system (genres, topics, themes)
- Parent-child relationships for nested categorization
- Visual elements: icons, colors, images for UI representation
- Metadata tracking: item counts, listening hours, popularity
- Featured category support for promotional content

**Mood Categories Table**
- **Purpose**: Emotion-based content grouping for personalized recommendations
- Mood-driven discovery (relaxing, energetic, educational, etc.)
- Visual representation with emojis and colors
- Helps users find content matching their current mood or activity

### Junction Tables

**ContentAuthor Table**
- **Purpose**: Links content to multiple authors with role definitions
- Supports role specifications (primary, co-author, contributor)
- Sort ordering for proper author attribution display
- Many-to-many relationship between content and authors

**ContentNarrator Table**
- **Purpose**: Associates content with voice artists and narrators
- Role-based assignments (primary, secondary, guest narrator)
- Supports multiple narrators per content item
- Sort ordering for proper narrator credit display

**ContentCategory Table**
- **Purpose**: Categorizes content into multiple genres and topics
- Enables content to belong to multiple categories simultaneously
- Simple many-to-many relationship without additional metadata

**MoodContent Table**
- **Purpose**: Associates content with mood-based categories for discovery
- Enables mood-driven content recommendations
- Sort ordering for featured content within mood categories

**UserAuthorFollow Table**
- **Purpose**: User subscription system for following favorite authors
- Tracks when users started following specific authors
- Enables notifications for new releases from followed authors

**UserNarratorFollow Table**
- **Purpose**: User subscription system for following favorite narrators
- Similar to author follows but for voice artists
- Supports narrator-based content discovery and notifications

## User Interaction & Progress Tracking

**Recently Played Table**
- **Purpose**: Tracks user listening progress and session history across all content
- Position tracking in seconds with percentage completion
- Playback speed preferences and session duration logging
- Enables "continue listening" functionality and progress synchronization
- Marks completed content and calculates listening statistics

**Downloads Table**
- **Purpose**: Manages offline content downloads for premium users
- Tracks download status, progress, and file management
- Quality settings and local file path storage
- File size tracking for storage management
- Supports pause/resume download functionality

**Bookmarks Table**
- **Purpose**: User-saved content for quick access and personal library management
- Enables users to bookmark favorite content items
- Optional personal notes for each bookmark
- Quick access functionality for saved content

**Reviews Table**
- **Purpose**: User rating and review system for content quality assessment
- 1-5 star rating system with optional written reviews
- Public/private visibility controls for user privacy
- One review per user per content item (unique constraint)
- Aggregated ratings used for content recommendation algorithms
- Connected to ReviewVote table for community feedback

**Review Votes Table**
- **Purpose**: Community voting system for reviews (upvotes/downvotes)
- Users can vote on any review except their own
- One vote per user per review (unique constraint)
- Supports UPVOTE and DOWNVOTE vote types
- Enables community-driven review quality assessment

**Notes Table**
- **Purpose**: Personal annotation system for timestamped notes during listening
- Timestamp-based annotations linked to specific audio positions
- Multiple note types: personal thoughts, highlights, bookmarks
- Private note system for individual learning and reference
- Uses `noteContent` field to store the actual note text (renamed to avoid naming conflicts)

## Subscription & Payment System

**Subscription Plans Table**
- **Purpose**: Defines available subscription tiers and pricing structures
- Flexible plan definitions with monthly/yearly billing cycles
- Feature lists and limitation specifications for each tier
- Stripe integration with external price IDs for payment processing

**User Subscriptions Table**
- **Purpose**: Manages active user subscriptions and billing relationships
- Current subscription status tracking (ACTIVE, CANCELED, EXPIRED, etc.)
- Billing period management and renewal dates
- Stripe customer and subscription ID linking for payment processing

**Subscription History Table**
- **Purpose**: Complete audit trail of all billing transactions and subscription changes
- Transaction tracking with external payment references
- Historical billing data for customer service and disputes
- Financial reporting and analytics data

## Audio Player & Session Management

**Audio Sessions Table**
- **Purpose**: Manages active audio playback sessions across multiple devices
- Real-time playback state synchronization between devices
- Quality preferences and volume settings per session
- Device-specific metadata for optimized playback experience

## Notifications & Communication

**Notifications Table**
- **Purpose**: In-app notification system for user engagement and communication
- Multiple notification types (informational, promotional, system alerts)
- Scheduling support for future notifications and campaigns
- Read/unread status tracking and notification archival

## User Preferences & Settings

**User Preferences Table**
- **Purpose**: Comprehensive user settings and personalization preferences
- Theme preferences (light, dark, system default)
- Language and localization settings
- Audio playback defaults (speed, volume, auto-play)
- Notification preferences and privacy controls
- Content filtering and parental control settings

## Trial Usage Tracking

**Trial Usage Table**
- **Purpose**: Tracks trial users' premium content usage with monthly limits
- Manages the 15-minute monthly allowance for accessing premium content
- Automatically resets usage counters monthly (every 30 days)
- Tracks current month and year for proper usage period management
- Configurable monthly limit (default: 15 minutes)
- Links to detailed session tracking for audit purposes

**Trial Usage Sessions Table**
- **Purpose**: Individual premium content listening sessions for trial users
- Granular tracking of when and what premium content was accessed
- Records exact start and end positions for accurate time calculation
- Stores content and chapter titles for historical reference
- Enables detailed usage analytics and reporting
- Supports usage pattern analysis for business intelligence

### Trial Usage Business Logic
- **Monthly Reset**: Usage counters reset on the same day each month (30-day cycle)
- **Content Access**: Trial users can listen to premium content until limit is reached
- **Graceful Degradation**: When limit exceeded, premium features are disabled
- **Usage Calculation**: Time is calculated based on actual playback position changes
- **Session Tracking**: Each listening session is recorded with precise timing
- **Historical Data**: Past usage sessions are retained for user statistics

## Search & Discovery

**Search History Table**
- **Purpose**: User search behavior tracking for personalization and analytics
- Query history for improved search suggestions
- Applied filter tracking for better user experience
- Result count logging for search optimization
- Data used for personalized content recommendations

## Feedback & Support

**Feedback Table**
- **Purpose**: User feedback collection and customer support ticket management
- Multiple feedback categories (bug reports, feature requests, general inquiries)
- Priority classification and status tracking workflow
- Admin assignment system for support team management
- Device information capture for technical issue resolution

## Relationships Overview

### Key Relationships

1. **User ↔ Content**: Many-to-many through various interaction tables
2. **Content ↔ Authors/Narrators**: Many-to-many with role specifications
3. **Content ↔ Categories**: Many-to-many hierarchical relationships
4. **User ↔ Subscriptions**: One-to-many with history tracking
5. **Content ↔ Chapters**: One-to-many hierarchical structure
6. **AudioFile ↔ Waveform**: One-to-one relationship for audio visualization data

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