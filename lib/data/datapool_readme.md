# Datapool.json Documentation

This document provides comprehensive documentation for the `datapool.json` file, which contains all mock data required by the Siraaj/Scroll Flutter application screens.

## File Structure Overview

The `datapool.json` file is organized into several main sections:

### 1. **Core Data Collections**
Global data entities used across multiple screens:
- `notifications` - System notifications and alerts
- `authors` - Author profiles and information  
- `narrators` - Voice artist/narrator profiles
- `categories` - Content categories (Fiqh, Aqeedah, etc.)
- `moods` - Mood-based content collections

### 2. **Screen-Specific Data**
Under the `screens` object, data is organized by screen name:
- `homepage` - Home tab data (featured content, recommendations, etc.)
- `search` - Search-related data (recent searches, trending, tags)
- `library` - User library data (recently played, downloads, notes)
- `reviews` - Review system data (sample reviews, statistics)
- `content` - Books, podcasts, and chapters data
- `following` - User follow relationships
- `bookmarks` - Bookmarked content references

---

## Detailed Section Documentation

### Core Data Collections

#### `notifications`
**Purpose**: App-wide notifications and alerts  
**Used by**: NotificationsListScreen, HomeTab (notification badge)  
**Fields**:
- `id` (string): Unique identifier
- `title` (string): Notification headline
- `message` (string): Notification body text
- `type` (string): Notification type - "warning", "info", "success", "error"
- `isDismissible` (boolean): Whether user can dismiss
- `actionText` (string): Optional action button text

#### `authors`
**Purpose**: Author profiles and biographical information  
**Used by**: AuthorsListScreen, AuthorScreen, content detail screens  
**Fields**:
- `id` (string): Unique identifier (matches MockData.getMockAuthors())
- `name` (string): Full author name
- `slug` (string): URL-friendly identifier
- `bio` (string): Detailed biographical information
- `imageUrl` (string|null): Profile image URL
- `nationality` (string): Author's nationality
- `birthYear` (string): Year of birth
- `genres` (array): List of specialization areas
- `awards` (array): List of awards/recognitions
- `socialLinks` (array): Social media handles
- `quote` (string): Signature quote from the author
- `totalBooks` (number): Total number of published works
- `isFollowing` (boolean): User's follow status

#### `narrators`
**Purpose**: Voice artist profiles and capabilities  
**Used by**: NarratorsListScreen, NarratorScreen, content detail screens  
**Fields**:
- `id` (string): Unique identifier (matches MockData.getMockNarrators())
- `name` (string): Full narrator name
- `slug` (string): URL-friendly identifier
- `bio` (string): Professional background
- `imageUrl` (string|null): Profile image URL
- `languages` (array): Languages spoken
- `genres` (array): Content specialization areas
- `awards` (array): Professional recognitions
- `socialLinks` (array): Social media handles
- `experienceYears` (number): Years of experience
- `voiceDescription` (string): Voice quality description
- `totalNarrations` (number): Total narrated content
- `isFollowing` (boolean): User's follow status
- `gender` (string): "Male", "Female", etc. for filtering

#### `categories`
**Purpose**: Content organization and filtering  
**Used by**: CategoriesTab, CategoryViewScreen, content filtering  
**Fields**:
- `id` (string): Unique identifier (matches MockData.getIslamicCategories())
- `name` (string): Category display name
- `slug` (string): URL-friendly identifier
- `iconPath` (string): Path to category icon
- `imageUrl` (string|null): Optional category image
- `itemCount` (number): Number of items in category
- `listeningHours` (string): Total listening time available
- `description` (string): Category explanation

#### `moods`
**Purpose**: Mood-based content discovery  
**Used by**: HomeTab (mood selector), MoodScreen  
**Fields**:
- `id` (string): Unique identifier (matches MockData.getMoodCategories())
- `name` (string): Mood category name
- `slug` (string): URL-friendly identifier
- `emoji` (string): Mood representation emoji
- `description` (string): Mood explanation
- `books` (array): Sample books using basic unified book format

### **Unified Book Format**
**Purpose**: Single book data structure used across all screens  
**Used by**: All screens that display book/content information  

#### Core Fields (Always Include):
- `id` (string): Unique identifier
- `title` (string): Book/content title
- `slug` (string): URL-friendly identifier
- `author` (string): Author name for display
- `coverUrl` (string): Book cover image URL
- `rating` (number): Average rating (0.0-5.0)
- `duration` (string): Total listening time (e.g., "45h 30m")
- `categories` (array): Content categories/tags

#### Detailed Fields (For Content Detail Views):
- `authorId` (string): Reference to author ID in authors collection
- `type` (string): "book" or "podcast"
- `availability` (string): "glimpse" or "premium"
- `chapterCount` (number): Number of chapters/episodes
- `description` (string): Detailed content description
- `narrators` (array): Array of narrator IDs
- `language` (string): Content language
- `isBookmarked` (boolean): User bookmark status
- `isPremium` (boolean): Premium content flag

#### Progress/Playback Fields (For Library/History):
- `progress` (number): Listening progress (0.0-1.0)
- `playedWhen` (string): Last played timestamp
- `playedMinutes` (number): Minutes listened in last session
- `isFinished` (boolean): Whether user completed the content
- `narrator` (string): Primary narrator name for display

#### Download Fields (For Offline Content):
- `downloadSize` (string): File size (e.g., "4.2 GB")
- `isDownloading` (boolean): Currently downloading status
- `downloadProgress` (number): Download progress (0.0-1.0)

**Usage Guidelines**: Include only the fields relevant to each screen context. For example, list views need only core fields, while detail views include all relevant fields, and library views add progress fields.

---

## Screen-Specific Data Documentation

### `screens.homepage`
**Purpose**: Data for the main home screen/tab  
**Maps to**: HomeTab widget  

#### `audiobookOfTheWeek`
Featured weekly content highlighting:
- Single book object using unified book format with `isPremium` field
- Used for prominent banner display
- Maps to MockData.getAudiobookOfTheWeek()

#### `continueListening`
User's partially completed content:
- Array of book objects using unified format with `progress` field (0.0-1.0)
- Enables personalized "continue where you left off" functionality
- Maps to MockData.getContinueListening()

#### `recommendedBooks`
Personalized content suggestions:
- Array of book objects using basic unified format
- Algorithm-based recommendations
- Maps to MockData.getRecommendedBooks()

#### `premiumFeatures`
Premium subscription benefits list:
- Array of strings describing premium features
- Used in premium banners and upgrade prompts
- Maps to MockData.getPremiumFeatures()

#### `topShelfBooks`
Popular/featured content:
- Array of book objects using basic unified format
- Curated selection of high-quality content
- Maps to MockData.getShelfBooks()

### `screens.search`
**Purpose**: Search functionality support  
**Maps to**: SearchScreen widget  

#### `recentSearches`
User's search history:
- Array of recent search terms
- Maps to MockData.getRecentSearches()

#### `trendingTopics`
Currently popular search terms:
- Community-driven trending searches
- Maps to MockData.getTrendingTopics()

#### `popularTags`
Content tagging system:
- Frequently used content tags
- Maps to MockData.getPopularTags()

### `screens.library`
**Purpose**: User's personal content library  
**Maps to**: LibraryTab widget  

#### `recentlyPlayed`
Recently accessed content:
- Array of book objects using unified format with playback fields (playedWhen, playedMinutes, progress, isFinished, narrator)
- Includes playback timestamps and completion status
- Maps to MockData.getRecentlyPlayed()

#### `downloads`
Offline content management:
- Array of book objects using unified format with download fields (downloadSize, isDownloading, downloadProgress, narrator)
- Download status, file sizes, progress tracking
- Maps to MockData.getDownloadedBooks()

#### `notes`
User-generated notes and annotations:
- Array of note objects with unique data structure
- Personal notes, highlights, and questions
- Linked to specific content and timestamps
- Custom data structure not in MockData

### `screens.reviews`
**Purpose**: Content review and rating system  
**Maps to**: ReviewsScreen widget  

#### `sampleReviews`
User-generated content reviews:
- Individual review objects with voting system
- Maps to MockData.getMockReviews()

#### `reviewSummary`
Aggregated rating statistics:
- Average ratings and distribution
- Maps to MockData.getReviewSummary()

### `screens.content`
**Purpose**: Books, podcasts, and chapter data  
**Maps to**: PlaylistScreen, ChapterScreen, content detail screens  

#### `books`
Complete book/podcast objects:
- Array of book objects using unified format with detailed fields (authorId, type, availability, chapterCount, description, narrators, language, isBookmarked, isPremium)
- Full content metadata including narrators, chapters, etc.
- Maps to MockData.getCategoryContent()

#### `chapters`
Individual chapter/episode data:
- Playback progress, narrator assignments, status tracking
- Maps to MockData.getMockChapters()

### `screens.following`
**Purpose**: User's follow relationships  
**Maps to**: FollowingScreen widget  

Contains arrays of followed author and narrator IDs:
- `followedAuthors`: Array of author IDs user is following
- `followedNarrators`: Array of narrator IDs user is following
- Maps to MockData.getFollowedAuthors() and MockData.getFollowedNarrators()

### `screens.bookmarks`
**Purpose**: User's bookmarked content  
**Maps to**: BookmarksScreen widget  

Contains array of bookmarked content IDs:
- `bookmarkedContent`: Array of content IDs user has bookmarked
- References content from other sections by ID

---

## Data Relationships and Cross-References

### Key Relationships:
1. **Content → Authors**: Books reference author IDs from the `authors` collection
2. **Content → Narrators**: Books reference narrator IDs from the `narrators` collection  
3. **Content → Categories**: Books belong to categories from the `categories` collection
4. **User Data → Content**: Bookmarks, following, and library reference content by ID
5. **Reviews → Content**: Reviews are linked to specific content items

### ID Referencing System:
- All entities use consistent ID patterns (e.g., "author_1", "narrator_2", "fiqh_1")
- Cross-references maintain referential integrity
- Slug fields provide URL-friendly alternatives to IDs

---

## Usage Guidelines for Backend Developers

### API Endpoint Mapping:
Each data section maps to specific API endpoints:

1. **GET /api/notifications** → `notifications`
2. **GET /api/authors** → `authors`
3. **GET /api/narrators** → `narrators`
4. **GET /api/categories** → `categories`
5. **GET /api/moods** → `moods`
6. **GET /api/home/featured** → `screens.homepage`
7. **GET /api/search/suggestions** → `screens.search`
8. **GET /api/user/library** → `screens.library`
9. **GET /api/content/{id}/reviews** → `screens.reviews`
10. **GET /api/content** → `screens.content`
11. **GET /api/user/following** → `screens.following`
12. **GET /api/user/bookmarks** → `screens.bookmarks`

### Data Requirements:
- All timestamps should be ISO 8601 format in production
- File sizes should be human-readable (e.g., "4.2 GB")
- Progress values should be decimals between 0.0 and 1.0
- URLs should be absolute paths to assets
- All arrays should handle empty states gracefully

### Filtering and Search:
- Support filtering by language, genre, narrator gender, content type
- Implement full-text search across titles, authors, descriptions
- Maintain search history and trending calculations
- Support tag-based content discovery

---

## Update Notes

**Last Updated**: January 2025  
**Version**: 1.0  
**Corresponds to**: MockData.dart implementation in Flutter app

This datapool structure ensures comprehensive coverage of all screen data requirements while maintaining clean separation of concerns and enabling efficient API development.