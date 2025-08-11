// Mock data for Siraaj app - Phase 1 UI implementation
// In Phase 2, this will be replaced with actual API calls

import 'package:flutter/material.dart';

enum NotificationType { info, warning, success, error }

/// Review data model for content reviews
class ReviewData {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String reviewText;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final bool isUserUpvoted;
  final bool isUserDownvoted;
  final bool isOwnReview;

  ReviewData({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    this.isUserUpvoted = false,
    this.isUserDownvoted = false,
    this.isOwnReview = false,
  });
}

/// Review summary data for content
class ReviewSummaryData {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count
  final ReviewData? userReview;

  ReviewSummaryData({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    this.userReview,
  });
}

class NotificationData {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isDismissible;
  final String? actionText;
  final VoidCallback? onAction;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isDismissible = true,
    this.actionText,
    this.onAction,
  });
}

class BookData {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;
  final String duration;
  final bool isPremium;
  final List<String> categories;
  final double? progress; // For continue listening feature (0.0 to 1.0)

  BookData({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    required this.duration,
    this.isPremium = false,
    required this.categories,
    this.progress,
  });
}

class MoodCategory {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<BookData> books;

  MoodCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.books,
  });
}

class CategoryData {
  final String id;
  final String name;
  final IconData? icon;
  final String? iconPath; // Path to PNG icon asset
  final String? imageUrl;
  final int itemCount;
  final String listeningHours;
  final String description;

  CategoryData({
    required this.id,
    required this.name,
    this.icon, // Made optional to support iconPath
    this.iconPath, // PNG icon path
    this.imageUrl,
    required this.itemCount,
    required this.listeningHours,
    required this.description,
  });
}

class RecentlyPlayedData {
  final String id;
  final String title;
  final String narrator;
  final String coverUrl;
  final DateTime playedWhen;
  final int playedMinutes;
  final bool isFinished;
  final double progress; // 0.0 to 1.0

  RecentlyPlayedData({
    required this.id,
    required this.title,
    required this.narrator,
    required this.coverUrl,
    required this.playedWhen,
    required this.playedMinutes,
    this.isFinished = false,
    this.progress = 0.0,
  });
}

class DownloadedBookData {
  final String id;
  final String title;
  final String narrator;
  final String coverUrl;
  final String downloadSize;
  final bool isDownloading;
  final double downloadProgress; // 0.0 to 1.0

  DownloadedBookData({
    required this.id,
    required this.title,
    required this.narrator,
    required this.coverUrl,
    required this.downloadSize,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
  });
}

enum ContentType { book, podcast }
enum AvailabilityType { glimpse, premium }
enum ChapterStatus { notPlayed, playing, paused, completed }

class AuthorData {
  final String id;
  final String name;
  final String bio;
  final String? imageUrl;
  final String nationality;
  final String birthYear;
  final List<String> genres;
  final List<String> awards;
  final List<String> socialLinks;
  final bool isFollowing;
  final String quote;
  final int totalBooks;

  AuthorData({
    required this.id,
    required this.name,
    required this.bio,
    this.imageUrl,
    required this.nationality,
    required this.birthYear,
    required this.genres,
    required this.awards,
    required this.socialLinks,
    this.isFollowing = false,
    required this.quote,
    required this.totalBooks,
  });
}

class NarratorData {
  final String id;
  final String name;
  final String bio;
  final String? imageUrl;
  final List<String> languages;
  final List<String> genres;
  final List<String> awards;
  final List<String> socialLinks;
  final bool isFollowing;
  final int experienceYears;
  final String voiceDescription;
  final int totalNarrations;
  final String gender;

  NarratorData({
    required this.id,
    required this.name,
    required this.bio,
    this.imageUrl,
    required this.languages,
    required this.genres,
    required this.awards,
    required this.socialLinks,
    this.isFollowing = false,
    required this.experienceYears,
    required this.voiceDescription,
    required this.totalNarrations,
    required this.gender,
  });
}

class ChapterData {
  final String id;
  final String title;
  final String description;
  final String duration;
  final int chapterNumber;
  final ChapterStatus status;
  final String? pausedAt; // e.g., "15:30" if paused
  final String narratorId;
  final double progress; // 0.0 to 1.0

  ChapterData({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.chapterNumber,
    this.status = ChapterStatus.notPlayed,
    this.pausedAt,
    required this.narratorId,
    this.progress = 0.0,
  });
}

class ContentItemData {
  final String id;
  final String title;
  final String author;
  final AuthorData authorData;
  final String coverUrl;
  final ContentType type;
  final AvailabilityType availability;
  final double rating;
  final String duration;
  final int chapterCount;
  final String description;
  final List<NarratorData> narrators;
  final List<ChapterData> chapters;
  final bool isBookmarked;
  final String language;

  ContentItemData({
    required this.id,
    required this.title,
    required this.author,
    required this.authorData,
    required this.coverUrl,
    required this.type,
    required this.availability,
    required this.rating,
    required this.duration,
    required this.chapterCount,
    required this.description,
    required this.narrators,
    required this.chapters,
    this.isBookmarked = false,
    required this.language,
  });
}

class MockData {
  // Mock notifications
  static List<NotificationData> getNotifications() {
    return [
      NotificationData(
        id: '1',
        title: 'Trial Ending Soon',
        message: 'Your trial expires in 3 days. Upgrade to Premium!',
        type: NotificationType.warning,
        actionText: 'Upgrade Now',
      ),
      NotificationData(
        id: '2',
        title: 'Special Offer',
        message: 'Get 50% off Premium subscription this week only!',
        type: NotificationType.info,
        actionText: 'Learn More',
      ),
    ];
  }

  // Mock books for shelf
  static List<BookData> getShelfBooks() {
    return [
      BookData(
        id: '1',
        title: 'Kanz ul Iman',
        author: 'Imam Ahmed Raza Khan Barelvi',
        coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Kanz+ul+Iman',
        rating: 4.9,
        duration: '45h 30m',
        categories: ['Quran', 'Translation', 'Barelvi'],
      ),
      BookData(
        id: '2',
        title: 'Jaa al-Haq',
        author: 'Allama Kaukab Noorani Okarvi',
        coverUrl: 'https://via.placeholder.com/150x200/2196F3/white?text=Jaa+al+Haq',
        rating: 4.8,
        duration: '12h 45m',
        categories: ['Islamic Jurisprudence', 'Barelvi'],
      ),
      BookData(
        id: '3',
        title: 'Bahaar-e-Shariat',
        author: 'Maulana Amjad Ali Azmi',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Bahaar+Shariat',
        rating: 4.7,
        duration: '28h 15m',
        categories: ['Fiqh', 'Islamic Law', 'Barelvi'],
      ),
    ];
  }

  // Mock mood categories
  static List<MoodCategory> getMoodCategories() {
    return [
      MoodCategory(
        id: '1',
        name: 'Strengthen Your Iman',
        emoji: '🤲',
        description: 'Strengthen your faith with inspiring Sunni content',
        books: getShelfBooks().take(2).toList(),
      ),
      MoodCategory(
        id: '2',
        name: 'Islamic Jurisprudence',
        emoji: '⚖️',
        description: 'Learn Islamic law and Fiqh from Sunni scholars',
        books: getShelfBooks().skip(1).take(2).toList(),
      ),
      MoodCategory(
        id: '3',
        name: 'Spiritual Guidance',
        emoji: '🌅',
        description: 'Find peace and spiritual enlightenment',
        books: getShelfBooks().take(1).toList(),
      ),
      MoodCategory(
        id: '4',
        name: 'Barelvi Teachings',
        emoji: '🕌',
        description: 'Traditional Sunni Barelvi Islamic teachings',
        books: getShelfBooks().skip(2).take(1).toList(),
      ),
      MoodCategory(
        id: '5',
        name: 'Children\'s Islamic Education',
        emoji: '👶',
        description: 'Islamic education for kids in Sunni tradition',
        books: getShelfBooks().take(2).toList(),
      ),
      MoodCategory(
        id: '6',
        name: 'Stories of Awliya & Saints',
        emoji: '✨',
        description: 'Inspiring tales of Sufi saints and righteous people',
        books: getShelfBooks().skip(1).toList(),
      ),
    ];
  }

  // Mock premium features
  static List<String> getPremiumFeatures() {
    return [
      'Listen offline, anytime',
      'Immerse without interruptions',
      'Access exclusive premium libraries',
      'Seamlessly continue across all devices',
      'Be the first to discover new content',
      'Experience crystal-clear audio quality',
    ];
  }

  // Mock audiobook of the week
  static BookData getAudiobookOfTheWeek() {
    return BookData(
      id: 'aotw',
      title: 'Fatawa Razvia',
      author: 'Imam Ahmed Raza Khan Barelvi',
      coverUrl: 'https://via.placeholder.com/300x400/9C27B0/white?text=Fatawa+Razvia',
      rating: 4.9,
      duration: '85h 30m',
      isPremium: true,
      categories: ['Fatawa', 'Islamic Law', 'Barelvi', 'Featured'],
    );
  }

  // Mock continue listening books - personalization
  static List<BookData> getContinueListening() {
    return [
      BookData(
        id: 'continue1',
        title: 'Seerat-un-Nabi',
        author: 'Allama Shibli Nomani',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Seerat+Nabi',
        rating: 4.7,
        duration: '32h 15m',
        progress: 0.65, // 65% complete
        categories: ['Biography', 'Prophet', 'History'],
      ),
      BookData(
        id: 'continue2',
        title: 'Tafseer-e-Naeemi',
        author: 'Mufti Ahmed Yaar Khan',
        coverUrl: 'https://via.placeholder.com/150x200/E91E63/white?text=Tafseer+Naeemi',
        rating: 4.8,
        duration: '125h 45m',
        progress: 0.23, // 23% complete
        categories: ['Tafseer', 'Quran', 'Commentary'],
      ),
      BookData(
        id: 'continue3',
        title: 'Fiqh-e-Hanafi',
        author: 'Imam Abu Hanifa',
        coverUrl: 'https://via.placeholder.com/150x200/3F51B5/white?text=Fiqh+Hanafi',
        rating: 4.9,
        duration: '68h 20m',
        progress: 0.42, // 42% complete
        categories: ['Fiqh', 'Islamic Law', 'Hanafi'],
      ),
    ];
  }

  // Mock recommended books based on listening history
  static List<BookData> getRecommendedBooks() {
    return [
      BookData(
        id: 'rec1',
        title: 'Malfuzat-e-Ala Hazrat',
        author: 'Imam Ahmed Raza Khan',
        coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Malfuzat',
        rating: 4.8,
        duration: '28h 15m',
        categories: ['Malfuzat', 'Spiritual', 'Barelvi'],
      ),
      BookData(
        id: 'rec2',
        title: 'Hadaiq-e-Bakhshish',
        author: 'Imam Ahmed Raza Khan',
        coverUrl: 'https://via.placeholder.com/150x200/FF5722/white?text=Hadaiq',
        rating: 4.9,
        duration: '15h 30m',
        categories: ['Poetry', 'Naat', 'Spiritual'],
      ),
      BookData(
        id: 'rec3',
        title: 'Bahar-e-Shariat',
        author: 'Maulana Amjad Ali Azmi',
        coverUrl: 'https://via.placeholder.com/150x200/607D8B/white?text=Bahar+Shariat',
        rating: 4.7,
        duration: '42h 45m',
        categories: ['Fiqh', 'Islamic Law', 'Hanafi'],
      ),
    ];
  }

  // Mock Islamic categories
  static List<CategoryData> getIslamicCategories() {
    return [
      CategoryData(
        id: '1',
        name: 'Fiqh',
        // Previous icon: Icons.balance_rounded
        iconPath: 'assets/icons/icons8-allah-100.png',
        itemCount: 48,
        listeningHours: '156h',
        description: 'Islamic jurisprudence and legal rulings',
      ),
      CategoryData(
        id: '2',
        name: 'Aqeedah',
        // Previous icon: Icons.star_rounded
        iconPath: 'assets/icons/icons8-islam-100.png',
        itemCount: 32,
        listeningHours: '98h',
        description: 'Islamic creed and beliefs',
      ),
      CategoryData(
        id: '3',
        name: 'Quran',
        // Previous icon: Icons.menu_book_rounded
        iconPath: 'assets/icons/icons8-quran-100.png',
        itemCount: 67,
        listeningHours: '234h',
        description: 'Quran recitation and tafseer',
      ),
      CategoryData(
        id: '4',
        name: 'Kids',
        // Previous icon: Icons.child_care_rounded
        iconPath: 'assets/icons/icons8-lotus-100.png',
        itemCount: 25,
        listeningHours: '45h',
        description: 'Islamic content for children',
      ),
      CategoryData(
        id: '5',
        name: 'Women',
        // Previous icon: Icons.female_rounded
        iconPath: 'assets/icons/icons8-muslim-woman-100.png',
        itemCount: 19,
        listeningHours: '67h',
        description: 'Content specifically for Muslim women',
      ),
      CategoryData(
        id: '6',
        name: 'Hadith',
        // Previous icon: Icons.format_quote_rounded
        iconPath: 'assets/icons/icons8-letter-100.png',
        itemCount: 41,
        listeningHours: '123h',
        description: 'Prophetic traditions and sayings',
      ),
      CategoryData(
        id: '7',
        name: 'Seerah',
        // Previous icon: Icons.person_rounded
        iconPath: 'assets/icons/icons8-dome-100.png',
        itemCount: 28,
        listeningHours: '89h',
        description: 'Biography of Prophet Muhammad (PBUH)',
      ),
      CategoryData(
        id: '8',
        name: 'Dua & Dhikr',
        // Previous icon: Icons.favorite_rounded
        iconPath: 'assets/icons/icons8-prayer-100.png',
        itemCount: 15,
        listeningHours: '32h',
        description: 'Supplications and remembrance',
      ),
    ];
  }

  // Mock recently played books
  static List<RecentlyPlayedData> getRecentlyPlayed() {
    return [
      RecentlyPlayedData(
        id: '1',
        title: 'Kanz ul Iman',
        narrator: 'Allama Muhammad Ilyas Qadri',
        coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Kanz+ul+Iman',
        playedWhen: DateTime.now().subtract(const Duration(hours: 2)),
        playedMinutes: 45,
        progress: 0.3,
      ),
      RecentlyPlayedData(
        id: '2',
        title: 'Jaa al-Haq',
        narrator: 'Maulana Tariq Jameel',
        coverUrl: 'https://via.placeholder.com/150x200/2196F3/white?text=Jaa+al+Haq',
        playedWhen: DateTime.now().subtract(const Duration(days: 1)),
        playedMinutes: 120,
        progress: 1.0,
        isFinished: true,
      ),
      RecentlyPlayedData(
        id: '3',
        title: 'Bahaar-e-Shariat',
        narrator: 'Dr. Muhammad Tahir ul Qadri',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Bahaar+Shariat',
        playedWhen: DateTime.now().subtract(const Duration(days: 3)),
        playedMinutes: 180,
        progress: 0.7,
      ),
    ];
  }

  // Mock downloaded books
  static List<DownloadedBookData> getDownloadedBooks() {
    return [
      DownloadedBookData(
        id: '1',
        title: 'Fatawa Razvia',
        narrator: 'Allama Muhammad Ilyas Qadri',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Fatawa+Razvia',
        downloadSize: '4.2 GB',
      ),
      DownloadedBookData(
        id: '2',
        title: 'Tafseer Kanz ul Iman',
        narrator: 'Dr. Muhammad Tahir ul Qadri',
        coverUrl: 'https://via.placeholder.com/150x200/9C27B0/white?text=Tafseer+Kanz',
        downloadSize: '3.8 GB',
      ),
      DownloadedBookData(
        id: '3',
        title: 'Seerat un Nabi',
        narrator: 'Maulana Tariq Jameel',
        coverUrl: 'https://via.placeholder.com/150x200/F44336/white?text=Seerat+Nabi',
        downloadSize: '2.1 GB',
        isDownloading: true,
        downloadProgress: 0.65,
      ),
    ];
  }

  // Mock authors
  static List<AuthorData> getMockAuthors() {
    return [
      AuthorData(
        id: 'author_1',
        name: 'Imam Ahmed Raza Khan Barelvi',
        bio: 'Imam Ahmed Raza Khan (1856-1921) was a renowned Islamic scholar, jurist, and reformer from India. He founded the Barelvi movement and wrote over 1000 books on various Islamic subjects. His most famous work is the Quranic translation "Kanz ul Iman".',
        nationality: 'Indian',
        birthYear: '1856',
        genres: ['Fiqh', 'Quran Translation', 'Islamic Law', 'Sufism'],
        awards: ['Ala Hazrat', 'Mujaddid of 14th Century'],
        socialLinks: [],
        quote: 'The light of Islam will spread to every corner of the world.',
        totalBooks: 1050,
        isFollowing: true,
      ),
      AuthorData(
        id: 'author_2',
        name: 'Allama Kaukab Noorani Okarvi',
        bio: 'Allama Kaukab Noorani Okarvi (1930-2016) was a prominent Pakistani Islamic scholar and orator. He was known for his passionate defense of traditional Sunni beliefs and practices, and authored numerous books on Islamic jurisprudence.',
        nationality: 'Pakistani',
        birthYear: '1930',
        genres: ['Islamic Jurisprudence', 'Contemporary Issues', 'Sunni Theology'],
        awards: ['Sitara-e-Imtiaz', 'Global Islamic Personality Award'],
        socialLinks: [],
        quote: 'Islam is the religion of love, peace, and brotherhood.',
        totalBooks: 85,
        isFollowing: true,
      ),
      AuthorData(
        id: 'author_3',
        name: 'Maulana Ashraf Ali Thanvi',
        bio: 'Maulana Ashraf Ali Thanvi (1863-1943) was an Islamic scholar from the Indian subcontinent. He authored over 800 books and was known for his expertise in Islamic jurisprudence, spirituality, and reform.',
        nationality: 'Indian',
        birthYear: '1863',
        genres: ['Fiqh', 'Tasawwuf', 'Islamic Ethics', 'Tafseer'],
        awards: ['Hakeem ul-Ummat', 'Mujaddid-e-Millat'],
        socialLinks: [],
        quote: 'True knowledge is that which benefits in both worlds.',
        totalBooks: 800,
      ),
      AuthorData(
        id: 'author_4',
        name: 'Maulana Amjad Ali Azmi',
        bio: 'Maulana Amjad Ali Azmi (1882-1941) was a distinguished Islamic scholar and author of the famous book "Bahaar-e-Shariat". He was a student of Imam Ahmed Raza Khan and contributed significantly to Islamic jurisprudence.',
        nationality: 'Indian',
        birthYear: '1882',
        genres: ['Fiqh', 'Islamic Law', 'Hanafi Jurisprudence'],
        awards: ['Faqeeh-e-Azam', 'Master of Islamic Law'],
        socialLinks: [],
        quote: 'Following the Shariah is the path to success in both worlds.',
        totalBooks: 45,
      ),
    ];
  }

  // Mock narrators
  static List<NarratorData> getMockNarrators() {
    return [
      NarratorData(
        id: 'narrator_1',
        name: 'Allama Muhammad Ilyas Qadri',
        bio: 'Allama Muhammad Ilyas Qadri is the founder and spiritual leader of Dawat-e-Islami. He is known for his efforts in Islamic education and spiritual reformation, inspiring millions worldwide through his teachings.',
        languages: ['Urdu', 'Arabic', 'English'],
        genres: ['Islamic Studies', 'Spiritual Reformation', 'Character Building'],
        awards: ['Spiritual Leader Award', 'Excellence in Da\'wah'],
        socialLinks: ['@dawateislami'],
        experienceYears: 30,
        voiceDescription: 'Inspiring, clear, and spiritually uplifting with excellent Urdu pronunciation',
        totalNarrations: 85,
        isFollowing: true,
        gender: 'Male',
      ),
      NarratorData(
        id: 'narrator_2',
        name: 'Maulana Tariq Jameel',
        bio: 'Maulana Tariq Jameel is a renowned Pakistani Islamic scholar and preacher. He is known for his soft-spoken, humble approach to Islamic teaching and his ability to connect with people from all walks of life.',
        languages: ['Urdu', 'Arabic', 'English'],
        genres: ['Spiritual Guidance', 'Character Development', 'Islamic Ethics'],
        awards: ['Sitara-e-Imtiaz', 'Global Peace Ambassador'],
        socialLinks: ['@tariqjameel'],
        experienceYears: 35,
        voiceDescription: 'Gentle, compassionate, and deeply moving with clear articulation',
        totalNarrations: 120,
        isFollowing: true,
        gender: 'Male',
      ),
      NarratorData(
        id: 'narrator_3',
        name: 'Dr. Muhammad Tahir ul Qadri',
        bio: 'Dr. Muhammad Tahir ul Qadri is a Pakistani Islamic scholar, author, and peace activist. He has written over 1000 books and is known for his scholarly approach to Islam and his efforts in promoting interfaith dialogue.',
        languages: ['Urdu', 'Arabic', 'English', 'Persian'],
        genres: ['Islamic Scholarship', 'Peace Studies', 'Interfaith Dialogue'],
        awards: ['Oslo Peace Prize Nominee', 'Outstanding Scholar Award'],
        socialLinks: ['@DrTahirulQadri'],
        experienceYears: 40,
        voiceDescription: 'Scholarly, authoritative, and eloquent with multi-lingual expertise',
        totalNarrations: 95,
        gender: 'Male',
      ),
      NarratorData(
        id: 'narrator_4',
        name: 'Pir Syed Naseeruddin Naseer Gilani',
        bio: 'Pir Syed Naseeruddin Naseer Gilani is a prominent Sufi master and Islamic scholar. He is known for his deep spiritual insights and his role in preserving traditional Islamic teachings.',
        languages: ['Urdu', 'Arabic', 'Persian'],
        genres: ['Sufism', 'Spiritual Guidance', 'Traditional Islamic Studies'],
        awards: ['Sufi Master Recognition', 'Spiritual Excellence Award'],
        socialLinks: [],
        experienceYears: 45,
        voiceDescription: 'Spiritually profound, melodious, and deeply contemplative',
        totalNarrations: 75,
        gender: 'Male',
      ),
      NarratorData(
        id: 'narrator_5',
        name: 'Qaria Fatima Al-Zahra',
        bio: 'Qaria Fatima Al-Zahra is a renowned female Quranic reciter and Islamic scholar known for her beautiful recitation of the Holy Quran and her expertise in Quranic sciences.',
        languages: ['Arabic', 'Urdu'],
        genres: ['Quranic Recitation', 'Tajweed', 'Quranic Sciences'],
        awards: ['International Quranic Recitation Award', 'Master of Tajweed'],
        socialLinks: [],
        experienceYears: 25,
        voiceDescription: 'Beautiful, melodious Quranic recitation with perfect Tajweed',
        totalNarrations: 60,
        gender: 'Female',
      ),
    ];
  }

  // Mock chapters
  static List<ChapterData> getMockChapters(String contentId, String narratorId) {
    switch (contentId) {
      case 'fiqh_1':
        return [
          ChapterData(
            id: 'ch_1_1',
            title: 'Introduction to Fiqh',
            description: 'An overview of Islamic jurisprudence and its importance in Muslim life.',
            duration: '45m',
            chapterNumber: 1,
            status: ChapterStatus.completed,
            narratorId: narratorId,
            progress: 1.0,
          ),
          ChapterData(
            id: 'ch_1_2',
            title: 'Purification and Wudu',
            description: 'Learn the proper methods of purification and ablution before prayer.',
            duration: '38m',
            chapterNumber: 2,
            status: ChapterStatus.paused,
            pausedAt: '12:30',
            narratorId: narratorId,
            progress: 0.33,
          ),
          ChapterData(
            id: 'ch_1_3',
            title: 'Prayer Fundamentals',
            description: 'Understanding the basic requirements and structure of Islamic prayer.',
            duration: '52m',
            chapterNumber: 3,
            status: ChapterStatus.playing,
            narratorId: narratorId,
            progress: 0.15,
          ),
          ChapterData(
            id: 'ch_1_4',
            title: 'Times of Prayer',
            description: 'Learn about the five daily prayer times and their significance.',
            duration: '42m',
            chapterNumber: 4,
            status: ChapterStatus.notPlayed,
            narratorId: narratorId,
            progress: 0.0,
          ),
        ];
      case 'fiqh_3':
        // Return chapters for both narrators
        final narrators = getMockNarrators();
        if (narratorId == narrators[1].id) { // Mufti Menk
          return [
            ChapterData(
              id: 'ch_3_1_narrator1',
              title: 'Preparing for Hajj',
              description: 'Essential preparations and requirements before embarking on Hajj.',
              duration: '55m',
              chapterNumber: 1,
              status: ChapterStatus.completed,
              narratorId: narratorId,
              progress: 1.0,
            ),
            ChapterData(
              id: 'ch_3_2_narrator1',
              title: 'Journey to Mecca',
              description: 'The spiritual and physical journey to the holy city.',
              duration: '48m',
              chapterNumber: 2,
              status: ChapterStatus.paused,
              pausedAt: '20:15',
              narratorId: narratorId,
              progress: 0.42,
            ),
            ChapterData(
              id: 'ch_3_3_narrator1',
              title: 'Tawaf and Saee',
              description: 'Performing the circumambulation and walking between hills.',
              duration: '62m',
              chapterNumber: 3,
              status: ChapterStatus.notPlayed,
              narratorId: narratorId,
              progress: 0.0,
            ),
          ];
        } else if (narratorId == narrators[2].id) { // Nouman Ali Khan
          return [
            ChapterData(
              id: 'ch_3_1_narrator2',
              title: 'Preparing for Hajj',
              description: 'Essential preparations and requirements before embarking on Hajj.',
              duration: '52m',
              chapterNumber: 1,
              status: ChapterStatus.notPlayed,
              narratorId: narratorId,
              progress: 0.0,
            ),
            ChapterData(
              id: 'ch_3_2_narrator2',
              title: 'Journey to Mecca',
              description: 'The spiritual and physical journey to the holy city.',
              duration: '46m',
              chapterNumber: 2,
              status: ChapterStatus.notPlayed,
              narratorId: narratorId,
              progress: 0.0,
            ),
            ChapterData(
              id: 'ch_3_3_narrator2',
              title: 'Tawaf and Saee',
              description: 'Performing the circumambulation and walking between hills.',
              duration: '58m',
              chapterNumber: 3,
              status: ChapterStatus.notPlayed,
              narratorId: narratorId,
              progress: 0.0,
            ),
          ];
        }
        return [];
      default:
        return [
          ChapterData(
            id: 'ch_default_1',
            title: 'Chapter 1',
            description: 'Introduction to the topic.',
            duration: '30m',
            chapterNumber: 1,
            narratorId: narratorId,
            progress: 0.0,
          ),
        ];
    }
  }

  // Mock category content (books and podcasts)
  static List<ContentItemData> getCategoryContent(String categoryId) {
    final narrators = getMockNarrators();
    final authors = getMockAuthors();
    switch (categoryId) {
      case '1': // Fiqh
        return [
          ContentItemData(
            id: 'fiqh_1',
            title: 'Fiqh Made Easy',
            author: 'Salih al-Munajjid',
            authorData: authors[0], // Using first author as placeholder
            coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Fiqh+Easy',
            type: ContentType.book,
            availability: AvailabilityType.glimpse,
            rating: 4.6,
            duration: '8h 30m',
            chapterCount: 12,
            description: 'A comprehensive guide to Islamic jurisprudence, covering the fundamental principles and practical applications of Fiqh in daily life.',
            narrators: [narrators[0]],
            chapters: getMockChapters('fiqh_1', narrators[0].id),
            language: 'Arabic',
          ),
          ContentItemData(
            id: 'fiqh_2',
            title: 'Prayer Guidelines',
            author: 'Ahmad ibn Hanbal',
            authorData: authors[0],
            coverUrl: 'https://via.placeholder.com/150x200/2196F3/white?text=Prayer',
            type: ContentType.podcast,
            availability: AvailabilityType.premium,
            rating: 4.8,
            duration: '45m',
            chapterCount: 5,
            description: 'Essential guidelines for performing the five daily prayers correctly according to Islamic teachings.',
            narrators: [narrators[0], narrators[1]], // Multiple speakers for podcast
            chapters: getMockChapters('fiqh_2', narrators[0].id),
            language: 'English',
          ),
          ContentItemData(
            id: 'fiqh_3',
            title: 'Hajj and Umrah Guide',
            author: 'Ibn Taymiyyah',
            authorData: authors[1],
            coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Hajj',
            type: ContentType.book,
            availability: AvailabilityType.premium,
            rating: 4.9,
            duration: '12h 15m',
            chapterCount: 18,
            description: 'Complete guide to performing Hajj and Umrah pilgrimage with detailed step-by-step instructions.',
            narrators: [narrators[1], narrators[2]], // Two narrators for this book
            chapters: [
              ...getMockChapters('fiqh_3', narrators[1].id),
              ...getMockChapters('fiqh_3', narrators[2].id),
            ],
            language: 'Urdu',
          ),
        ];
      case '2': // Aqeedah
        return [
          ContentItemData(
            id: 'aqeedah_1',
            title: 'The Six Pillars of Faith',
            author: 'Ibn Kathir',
            authorData: authors[2],
            coverUrl: 'https://via.placeholder.com/150x200/9C27B0/white?text=Six+Pillars',
            type: ContentType.book,
            availability: AvailabilityType.glimpse,
            rating: 4.7,
            duration: '6h 45m',
            chapterCount: 8,
            description: 'Detailed explanation of the six fundamental pillars of Islamic faith and belief.',
            narrators: [narrators[1]],
            chapters: getMockChapters('aqeedah_1', narrators[1].id),
            language: 'Arabic',
          ),
          ContentItemData(
            id: 'aqeedah_2',
            title: 'Understanding Tawheed',
            author: 'Muhammad ibn Abd al-Wahhab',
            authorData: authors[1],
            coverUrl: 'https://via.placeholder.com/150x200/F44336/white?text=Tawheed',
            type: ContentType.podcast,
            availability: AvailabilityType.premium,
            rating: 4.8,
            duration: '1h 20m',
            chapterCount: 3,
            description: 'Deep dive into the concept of Tawheed (monotheism) in Islamic theology.',
            narrators: [narrators[0], narrators[2]], // Multiple speakers for podcast
            chapters: getMockChapters('aqeedah_2', narrators[0].id),
            language: 'English',
          ),
        ];
      case '3': // Quran
        return [
          ContentItemData(
            id: 'quran_1',
            title: 'Tafsir Ibn Kathir',
            author: 'Ibn Kathir',
            authorData: authors[2],
            coverUrl: 'https://via.placeholder.com/150x200/607D8B/white?text=Tafsir',
            type: ContentType.book,
            availability: AvailabilityType.premium,
            rating: 4.9,
            duration: '45h 30m',
            chapterCount: 114,
            description: 'Complete commentary and interpretation of the Holy Quran by the renowned scholar Ibn Kathir.',
            narrators: [narrators[2]],
            chapters: getMockChapters('quran_1', narrators[2].id),
            language: 'Arabic',
          ),
          ContentItemData(
            id: 'quran_2',
            title: 'Beautiful Recitations',
            author: 'Various Qaris',
            authorData: authors[2],
            coverUrl: 'https://via.placeholder.com/150x200/795548/white?text=Recitation',
            type: ContentType.podcast,
            availability: AvailabilityType.glimpse,
            rating: 4.8,
            duration: '2h 15m',
            chapterCount: 30,
            description: 'Collection of beautiful Quranic recitations by various renowned Qaris.',
            narrators: narrators, // Multiple reciters
            chapters: getMockChapters('quran_2', narrators[0].id),
            language: 'Arabic',
          ),
        ];
      default:
        return [
          ContentItemData(
            id: 'default_1',
            title: 'Islamic Knowledge',
            author: 'Various Scholars',
            authorData: authors[0],
            coverUrl: 'https://via.placeholder.com/150x200/9E9E9E/white?text=Knowledge',
            type: ContentType.book,
            availability: AvailabilityType.glimpse,
            rating: 4.5,
            duration: '5h 30m',
            chapterCount: 10,
            description: 'General Islamic knowledge covering various aspects of faith and practice.',
            narrators: [narrators[0]],
            chapters: getMockChapters('default_1', narrators[0].id),
            language: 'English',
          ),
        ];
    }
  }

  // Search-related mock data
  static List<String> getRecentSearches() {
    return [
      'Islamic history',
      'Seerah',
      'Quran tafsir',
      'Hadith collection',
      'Ibn Kathir',
    ];
  }

  static List<String> getTrendingTopics() {
    return [
      'Ramadan preparation',
      'Hadith studies',
      'Islamic finance',
      'Quranic recitation',
      'Prophet stories',
      'Islamic ethics',
    ];
  }

  static List<String> getPopularTags() {
    return [
      'Islamic History',
      'Quran',
      'Hadith',
      'Seerah',
      'Fiqh',
      'Aqeedah',
      'Tafsir',
      'Arabic',
      'Duas',
      'Islamic Finance',
      'Women in Islam',
      'Youth',
      'Contemporary Issues',
    ];
  }

  static Map<String, List<dynamic>> performSearch(String query) {
    // Simulate search results based on query
    final authors = getMockAuthors();
    final narrators = getMockNarrators();
    final allContent = [
      ...getCategoryContent('1'),
      ...getCategoryContent('2'),
      ...getCategoryContent('3'),
    ];
    final allChapters = <ChapterData>[];
    
    // Collect all chapters from all content
    for (final content in allContent) {
      allChapters.addAll(content.chapters);
    }

    final lowerQuery = query.toLowerCase();
    
    return {
      'authors': authors.where((author) => 
        author.name.toLowerCase().contains(lowerQuery) ||
        author.bio.toLowerCase().contains(lowerQuery) ||
        author.genres.any((genre) => genre.toLowerCase().contains(lowerQuery))
      ).toList(),
      'narrators': narrators.where((narrator) => 
        narrator.name.toLowerCase().contains(lowerQuery) ||
        narrator.bio.toLowerCase().contains(lowerQuery) ||
        narrator.voiceDescription.toLowerCase().contains(lowerQuery) ||
        narrator.languages.any((lang) => lang.toLowerCase().contains(lowerQuery))
      ).toList(),
      'content': allContent.where((content) => 
        content.title.toLowerCase().contains(lowerQuery) ||
        content.author.toLowerCase().contains(lowerQuery) ||
        content.description.toLowerCase().contains(lowerQuery)
      ).toList(),
      'chapters': allChapters.where((chapter) => 
        chapter.title.toLowerCase().contains(lowerQuery) ||
        chapter.description.toLowerCase().contains(lowerQuery)
      ).map((chapter) {
        // Find parent content for this chapter
        final parentContent = allContent.firstWhere(
          (content) => content.chapters.contains(chapter),
          orElse: () => allContent.first,
        );
        return {'chapter': chapter, 'parent': parentContent};
      }).toList(),
    };
  }

  static List<NarratorData> getFollowedNarrators() {
    final allNarrators = getMockNarrators();
    // Return narrators that are being followed (simulate some being followed)
    return allNarrators.where((narrator) => narrator.isFollowing).toList();
  }

  static List<AuthorData> getFollowedAuthors() {
    final allAuthors = getMockAuthors();
    // Return authors that are being followed (simulate some being followed)
    return allAuthors.where((author) => author.isFollowing).toList();
  }

  // Reviews-related mock data
  static List<ReviewData> getMockReviews(String contentId) {
    return [
      ReviewData(
        id: 'review_1',
        userId: 'user_1',
        userName: 'Ahmad Mahmoud',
        userAvatar: '',
        rating: 5.0,
        reviewText: 'Absolutely amazing content! The narrator\'s voice is clear and engaging. I learned so much from this audiobook. Highly recommend it to anyone seeking Islamic knowledge.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        upvotes: 15,
        downvotes: 1,
        isUserUpvoted: false,
        isUserDownvoted: false,
        isOwnReview: false,
      ),
      ReviewData(
        id: 'review_2',
        userId: 'user_2',  
        userName: 'Fatima Hassan',
        userAvatar: '',
        rating: 4.0,
        reviewText: 'Very insightful and well-presented. The content is authentic and based on reliable sources. My only minor complaint is that some chapters felt a bit long.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        upvotes: 8,
        downvotes: 0,
        isUserUpvoted: true,
        isUserDownvoted: false,
        isOwnReview: false,
      ),
      ReviewData(
        id: 'review_3',
        userId: 'current_user',
        userName: 'You',
        userAvatar: '',
        rating: 4.5,
        reviewText: 'Great collection of Islamic teachings. The audio quality is excellent and the content is very educational. Would love to see more books by this author.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        upvotes: 12,
        downvotes: 0,
        isUserUpvoted: false,
        isUserDownvoted: false,
        isOwnReview: true,
      ),
      ReviewData(
        id: 'review_4',
        userId: 'user_4',
        userName: 'Omar Abdullah',
        userAvatar: '',
        rating: 3.5,
        reviewText: 'Good content overall, but I felt some topics could have been explained in more detail. The narrator did a decent job.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        upvotes: 5,
        downvotes: 2,
        isUserUpvoted: false,
        isUserDownvoted: false,
        isOwnReview: false,
      ),
      ReviewData(
        id: 'review_5',
        userId: 'user_5',
        userName: 'Aisha Khan',
        userAvatar: '',
        rating: 5.0,
        reviewText: 'Excellent resource for learning! The way complex topics are explained makes it easy to understand. Perfect for both beginners and advanced learners.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        upvotes: 20,
        downvotes: 0,
        isUserUpvoted: false,
        isUserDownvoted: false,
        isOwnReview: false,
      ),
    ];
  }

  static ReviewSummaryData getReviewSummary(String contentId) {
    final reviews = getMockReviews(contentId);
    final totalReviews = reviews.length;
    final averageRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews;
    
    // Calculate rating distribution
    final ratingDistribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = reviews.where((r) => r.rating.floor() == i).length;
    }
    
    // Find user's review if exists
    final userReview = reviews.where((r) => r.isOwnReview).firstOrNull;
    
    return ReviewSummaryData(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingDistribution: ratingDistribution,
      userReview: userReview,
    );
  }

  /// Check if user can review content based on listening progress
  static bool canUserReview(String contentId, double listeningProgress) {
    // User can only review if they've listened to more than 50% of the content
    return listeningProgress > 0.5;
  }

  /// Get listening progress for content (mock data)
  static double getListeningProgress(String contentId) {
    // Mock progress data - in real app this would come from user's listening history
    final mockProgress = <String, double>{
      'default_1': 0.75, // 75% listened
      'hadith_1': 0.25, // 25% listened
      'seerah_1': 0.90, // 90% listened
      'fiqh_1': 0.30, // 30% listened
      'aqeedah_1': 0.60, // 60% listened
    };
    
    return mockProgress[contentId] ?? 0.0;
  }
}