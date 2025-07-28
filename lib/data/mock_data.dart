// Mock data for Siraaj app - Phase 1 UI implementation
// In Phase 2, this will be replaced with actual API calls

import 'package:flutter/material.dart';

enum NotificationType { info, warning, success, error }

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

  BookData({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    required this.duration,
    this.isPremium = false,
    required this.categories,
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
  final IconData icon;
  final int itemCount;
  final String listeningHours;
  final String description;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
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
enum AvailabilityType { free, premium, trial }
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
        title: 'The Sealed Nectar',
        author: 'Safi-ur-Rahman al-Mubarakpuri',
        coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Sealed+Nectar',
        rating: 4.8,
        duration: '12h 30m',
        categories: ['Biography', 'Islamic'],
      ),
      BookData(
        id: '2',
        title: 'Fortress of the Muslim',
        author: 'Sa\'id bin Ali bin Wahf Al-Qahtani',
        coverUrl: 'https://via.placeholder.com/150x200/2196F3/white?text=Fortress',
        rating: 4.9,
        duration: '8h 15m',
        categories: ['Duas', 'Islamic'],
      ),
      BookData(
        id: '3',
        title: 'The Clear Quran',
        author: 'Dr. Mustafa Khattab',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Clear+Quran',
        rating: 4.7,
        duration: '25h 45m',
        categories: ['Quran', 'Translation'],
      ),
    ];
  }

  // Mock mood categories
  static List<MoodCategory> getMoodCategories() {
    return [
      MoodCategory(
        id: '1',
        name: 'Boost Your Iman',
        emoji: '🤲',
        description: 'Strengthen your faith with inspiring content',
        books: getShelfBooks().take(2).toList(),
      ),
      MoodCategory(
        id: '2',
        name: 'Productivity',
        emoji: '⚡',
        description: 'Get motivated and organized',
        books: getShelfBooks().skip(1).take(2).toList(),
      ),
      MoodCategory(
        id: '3',
        name: 'Overcome Depression',
        emoji: '🌅',
        description: 'Find hope and healing',
        books: getShelfBooks().take(1).toList(),
      ),
      MoodCategory(
        id: '4',
        name: 'Healthy Lifestyle',
        emoji: '🌱',
        description: 'Mind, body, and soul wellness',
        books: getShelfBooks().skip(2).take(1).toList(),
      ),
      MoodCategory(
        id: '5',
        name: 'Teaching Children',
        emoji: '👶',
        description: 'Islamic education for kids',
        books: getShelfBooks().take(2).toList(),
      ),
      MoodCategory(
        id: '6',
        name: 'Stories of Awliya',
        emoji: '✨',
        description: 'Inspiring tales of righteous people',
        books: getShelfBooks().skip(1).toList(),
      ),
    ];
  }

  // Mock premium features
  static List<String> getPremiumFeatures() {
    return [
      'Unlimited downloads',
      'Ad-free listening',
      'Exclusive premium content',
      'Multiple device sync',
      'Early access to new releases',
      'HD audio quality',
    ];
  }

  // Mock audiobook of the week
  static BookData getAudiobookOfTheWeek() {
    return BookData(
      id: 'aotw',
      title: 'When the Moon Split',
      author: 'Safi-ur-Rahman al-Mubarakpuri',
      coverUrl: 'https://via.placeholder.com/300x400/9C27B0/white?text=Moon+Split',
      rating: 4.9,
      duration: '15h 20m',
      isPremium: true,
      categories: ['Biography', 'Islamic', 'Featured'],
    );
  }

  // Mock Islamic categories
  static List<CategoryData> getIslamicCategories() {
    return [
      CategoryData(
        id: '1',
        name: 'Fiqh',
        icon: Icons.balance_rounded,
        itemCount: 48,
        listeningHours: '156h',
        description: 'Islamic jurisprudence and legal rulings',
      ),
      CategoryData(
        id: '2',
        name: 'Aqeedah',
        icon: Icons.star_rounded,
        itemCount: 32,
        listeningHours: '98h',
        description: 'Islamic creed and beliefs',
      ),
      CategoryData(
        id: '3',
        name: 'Quran',
        icon: Icons.menu_book_rounded,
        itemCount: 67,
        listeningHours: '234h',
        description: 'Quran recitation and tafseer',
      ),
      CategoryData(
        id: '4',
        name: 'Kids',
        icon: Icons.child_care_rounded,
        itemCount: 25,
        listeningHours: '45h',
        description: 'Islamic content for children',
      ),
      CategoryData(
        id: '5',
        name: 'Women',
        icon: Icons.female_rounded,
        itemCount: 19,
        listeningHours: '67h',
        description: 'Content specifically for Muslim women',
      ),
      CategoryData(
        id: '6',
        name: 'Hadith',
        icon: Icons.format_quote_rounded,
        itemCount: 41,
        listeningHours: '123h',
        description: 'Prophetic traditions and sayings',
      ),
      CategoryData(
        id: '7',
        name: 'Seerah',
        icon: Icons.person_rounded,
        itemCount: 28,
        listeningHours: '89h',
        description: 'Biography of Prophet Muhammad (PBUH)',
      ),
      CategoryData(
        id: '8',
        name: 'Dua & Dhikr',
        icon: Icons.favorite_rounded,
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
        title: 'The Sealed Nectar',
        narrator: 'Ahmad Al-Shugairi',
        coverUrl: 'https://via.placeholder.com/150x200/4CAF50/white?text=Sealed+Nectar',
        playedWhen: DateTime.now().subtract(const Duration(hours: 2)),
        playedMinutes: 45,
        progress: 0.3,
      ),
      RecentlyPlayedData(
        id: '2',
        title: 'Fortress of the Muslim',
        narrator: 'Omar Suleiman',
        coverUrl: 'https://via.placeholder.com/150x200/2196F3/white?text=Fortress',
        playedWhen: DateTime.now().subtract(const Duration(days: 1)),
        playedMinutes: 120,
        progress: 1.0,
        isFinished: true,
      ),
      RecentlyPlayedData(
        id: '3',
        title: 'Stories of the Prophets',
        narrator: 'Mufti Menk',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Prophets',
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
        title: 'The Clear Quran',
        narrator: 'Dr. Mustafa Khattab',
        coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Clear+Quran',
        downloadSize: '2.4 GB',
      ),
      DownloadedBookData(
        id: '2',
        title: 'In the Footsteps of the Prophet',
        narrator: 'Tariq Ramadan',
        coverUrl: 'https://via.placeholder.com/150x200/9C27B0/white?text=Footsteps',
        downloadSize: '1.8 GB',
      ),
      DownloadedBookData(
        id: '3',
        title: 'The Road to Mecca',
        narrator: 'Muhammad Asad',
        coverUrl: 'https://via.placeholder.com/150x200/F44336/white?text=Road+Mecca',
        downloadSize: '856 MB',
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
        name: 'Safi-ur-Rahman al-Mubarakpuri',
        bio: 'Safi-ur-Rahman al-Mubarakpuri was a renowned Islamic scholar and author, best known for his biographical work on Prophet Muhammad (PBUH). His meticulous research and scholarly approach have made his works essential reading for those seeking to understand Islamic history.',
        nationality: 'Indian',
        birthYear: '1943',
        genres: ['Biography', 'Islamic History', 'Seerah'],
        awards: ['King Faisal International Prize', 'Best Islamic Book Award'],
        socialLinks: [],
        quote: 'The best of people are those who benefit others.',
        totalBooks: 15,
      ),
      AuthorData(
        id: 'author_2',
        name: 'Ibn Taymiyyah',
        bio: 'Taqi ad-Din Ahmad ibn Taymiyyah was a medieval Islamic scholar and theologian. He is known for his devotion to the sources of Islam and his comprehensive scholarly works on Islamic jurisprudence and theology.',
        nationality: 'Syrian',
        birthYear: '1263',
        genres: ['Fiqh', 'Theology', 'Philosophy'],
        awards: ['Recognized as Shaykh al-Islam'],
        socialLinks: [],
        quote: 'Whoever seeks knowledge to compete with scholars or to argue with the ignorant has gone astray.',
        totalBooks: 350,
      ),
      AuthorData(
        id: 'author_3',
        name: 'Ibn Kathir',
        bio: 'Ismail ibn Umar ibn Kathir was a highly influential Islamic scholar during the Mamluk era in Syria. He was known for his profound knowledge of Quran, Hadith, and Islamic history.',
        nationality: 'Syrian',
        birthYear: '1300',
        genres: ['Tafseer', 'Hadith', 'Islamic History'],
        awards: ['Master of Quranic Commentary'],
        socialLinks: [],
        quote: 'Knowledge is light, and ignorance is darkness.',
        totalBooks: 25,
      ),
    ];
  }

  // Mock narrators
  static List<NarratorData> getMockNarrators() {
    return [
      NarratorData(
        id: 'narrator_1',
        name: 'Omar Suleiman',
        bio: 'Dr. Omar Suleiman is a renowned Islamic scholar, author, and speaker. He serves as the founder and president of the Yaqeen Institute for Islamic Research and is a prolific voice in contemporary Islamic discourse.',
        languages: ['English', 'Arabic'],
        genres: ['Islamic Studies', 'Contemporary Issues', 'Spirituality'],
        awards: ['Most Influential Muslim Personality', 'Excellence in Islamic Education'],
        socialLinks: ['@omarsuleiman504'],
        experienceYears: 15,
        voiceDescription: 'Clear, authoritative, and engaging with excellent pronunciation',
        totalNarrations: 45,
      ),
      NarratorData(
        id: 'narrator_2',
        name: 'Mufti Menk',
        bio: 'Mufti Ismail ibn Musa Menk is a renowned Islamic scholar from Zimbabwe. Known for his motivational speeches and accessible teaching style, he has inspired millions around the world.',
        languages: ['English', 'Arabic', 'Urdu'],
        genres: ['Motivational', 'Fiqh', 'Character Development'],
        awards: ['Global Islamic Personality Award', 'Excellence in Da\'wah'],
        socialLinks: ['@muftimenk'],
        experienceYears: 20,
        voiceDescription: 'Warm, compassionate, and motivational with clear articulation',
        totalNarrations: 65,
      ),
      NarratorData(
        id: 'narrator_3',
        name: 'Nouman Ali Khan',
        bio: 'Nouman Ali Khan is a Pakistani-American Islamic speaker and Arabic instructor. He is the founder of Bayyinah Institute and is known for his expertise in Arabic linguistics and Quranic studies.',
        languages: ['English', 'Arabic', 'Urdu'],
        genres: ['Quranic Studies', 'Arabic Language', 'Youth Education'],
        awards: ['Outstanding Contribution to Islamic Education', 'Arabic Excellence Award'],
        socialLinks: ['@noumanalikhan'],
        experienceYears: 18,
        voiceDescription: 'Dynamic, educational, and passionate with excellent Arabic pronunciation',
        totalNarrations: 55,
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
            availability: AvailabilityType.free,
            rating: 4.6,
            duration: '8h 30m',
            chapterCount: 12,
            description: 'A comprehensive guide to Islamic jurisprudence, covering the fundamental principles and practical applications of Fiqh in daily life.',
            narrators: [narrators[0]],
            chapters: getMockChapters('fiqh_1', narrators[0].id),
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
          ),
          ContentItemData(
            id: 'fiqh_3',
            title: 'Hajj and Umrah Guide',
            author: 'Ibn Taymiyyah',
            authorData: authors[1],
            coverUrl: 'https://via.placeholder.com/150x200/FF9800/white?text=Hajj',
            type: ContentType.book,
            availability: AvailabilityType.trial,
            rating: 4.9,
            duration: '12h 15m',
            chapterCount: 18,
            description: 'Complete guide to performing Hajj and Umrah pilgrimage with detailed step-by-step instructions.',
            narrators: [narrators[1], narrators[2]], // Two narrators for this book
            chapters: [
              ...getMockChapters('fiqh_3', narrators[1].id),
              ...getMockChapters('fiqh_3', narrators[2].id),
            ],
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
            availability: AvailabilityType.free,
            rating: 4.7,
            duration: '6h 45m',
            chapterCount: 8,
            description: 'Detailed explanation of the six fundamental pillars of Islamic faith and belief.',
            narrators: [narrators[1]],
            chapters: getMockChapters('aqeedah_1', narrators[1].id),
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
          ),
          ContentItemData(
            id: 'quran_2',
            title: 'Beautiful Recitations',
            author: 'Various Qaris',
            authorData: authors[2],
            coverUrl: 'https://via.placeholder.com/150x200/795548/white?text=Recitation',
            type: ContentType.podcast,
            availability: AvailabilityType.free,
            rating: 4.8,
            duration: '2h 15m',
            chapterCount: 30,
            description: 'Collection of beautiful Quranic recitations by various renowned Qaris.',
            narrators: narrators, // Multiple reciters
            chapters: getMockChapters('quran_2', narrators[0].id),
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
            availability: AvailabilityType.free,
            rating: 4.5,
            duration: '5h 30m',
            chapterCount: 10,
            description: 'General Islamic knowledge covering various aspects of faith and practice.',
            narrators: [narrators[0]],
            chapters: getMockChapters('default_1', narrators[0].id),
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
}