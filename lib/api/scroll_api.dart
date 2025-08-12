import 'api_client.dart';
import 'api_constants.dart';

/// Main API client for Scroll - Audiobook & Learning Platform.
/// 
/// This class provides access to all backend endpoints with proper error handling
/// and authentication. All methods use the underlying ApiClient which handles
/// session token management automatically.
/// 
/// Usage:
/// ```dart
/// final api = ScrollApi();
/// final health = await api.getHealth();
/// ```
class ScrollApi {
  static final ScrollApi _instance = ScrollApi._internal();
  factory ScrollApi() => _instance;
  ScrollApi._internal();

  final ApiClient _client = ApiClient();

  // ============================================================================
  // HEALTH ENDPOINTS
  // ============================================================================

  /// Returns server health status and database connectivity.
  /// 
  /// See docs/swagger.json -> /health -> 200 schema for response fields:
  /// - status: "ok" | "error"
  /// - timestamp: ISO date string
  /// - uptime: number (seconds)
  /// - database: connection status string
  /// 
  /// Throws [ServerException] on 503 service unavailable.
  Future<Map<String, dynamic>> getHealth() async {
    return await _client.get<Map<String, dynamic>>(ApiConstants.health);
  }

  // ============================================================================
  // AUTH ENDPOINTS
  // ============================================================================

  /// Request OTP for email authentication.
  /// 
  /// Sends a 6-digit OTP code to the specified email address for passwordless
  /// authentication. The OTP is valid for a limited time period.
  /// 
  /// Request body: { "email": string }
  /// 
  /// Response on success (200):
  /// - message: string
  /// - email: string (echoed back)
  /// - otp: string (optional, for testing)
  /// 
  /// Throws [ValidationException] on 400 for invalid email or send failure.
  Future<Map<String, dynamic>> requestOtp({required String email}) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.requestOtp,
      data: {'email': email},
    );
  }

  /// Verify OTP and sign in user.
  /// 
  /// Verifies the 6-digit OTP code sent to the user's email and creates an
  /// authenticated session. Returns user information and session token.
  /// 
  /// Request body: { "email": string, "otp": string }
  /// 
  /// Response on success (200):
  /// - message: string
  /// - user: { id, email, name?, image?, role: "USER"|"PREMIUM"|"ADMIN"|"MODERATOR" }
  /// - sessionToken: string (store this for authenticated requests)
  /// 
  /// After successful verification, call _client.setSessionToken(sessionToken)
  /// to enable automatic authentication for subsequent requests.
  /// 
  /// Throws [ValidationException] on 400 for invalid OTP or verification failure.
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    
    // Automatically set session token for future requests
    if (response['sessionToken'] != null) {
      await _client.setSessionToken(response['sessionToken']);
      print('🔍 Session Token: ${response['sessionToken']}');
    }
    
    return response;
  }

  /// Check if user exists by email.
  /// 
  /// Returns the user's name if they exist, otherwise returns "New User".
  /// Used to personalize the login experience.
  /// 
  /// Request body: { "email": string }
  /// 
  /// Response on success (200):
  /// - name: string (user name or "New User")
  Future<Map<String, dynamic>> checkEmail({required String email}) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.checkEmail,
      data: {'email': email},
    );
  }

  /// Get current user session.
  /// 
  /// Returns the current authenticated user information if session is valid,
  /// otherwise returns user: null.
  /// 
  /// Response on success (200):
  /// - user: { id, email, name?, image?, role } | null
  /// 
  /// No authentication required - uses session cookies/token if present.
  Future<Map<String, dynamic>> getSession() async {
    return await _client.get<Map<String, dynamic>>(ApiConstants.getSession);
  }

  /// Sign out current user.
  /// 
  /// Destroys the current user session and clears authentication cookies.
  /// Also clears the local session token storage.
  /// 
  /// Response on success (200):
  /// - message: string
  Future<Map<String, dynamic>> signOut() async {
    final response = await _client.post<Map<String, dynamic>>(ApiConstants.signOut);
    
    // Clear local session token
    await _client.signOut();
    
    return response;
  }

  // ============================================================================
  // USER ENDPOINTS
  // ============================================================================

  /// Get authenticated user's profile.
  /// 
  /// Returns complete profile information for the authenticated user.
  /// Requires valid session token.
  /// 
  /// Response on success (200):
  /// - id: string
  /// - email: string (email format)
  /// - name: string?
  /// - image: string?
  /// - role: "USER"|"PREMIUM"|"ADMIN"|"MODERATOR"
  /// - isActive: boolean
  /// - createdAt: ISO date string
  /// - updatedAt: ISO date string
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  Future<Map<String, dynamic>> getUserProfile() async {
    return await _client.get<Map<String, dynamic>>(ApiConstants.userProfile);
  }

  /// Update authenticated user's profile.
  /// 
  /// Updates the user's profile information. All fields are optional.
  /// Only provided fields will be updated.
  /// 
  /// Request body (all optional):
  /// - name: string?
  /// - bio: string?
  /// - nationality: string?
  /// - image: string? (URL or base64)
  /// 
  /// Response on success (200): Complete updated user profile
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [ValidationException] on 400 for invalid input.
  Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? bio,
    String? nationality,
    String? image,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (bio != null) data['bio'] = bio;
    if (nationality != null) data['nationality'] = nationality;
    if (image != null) data['image'] = image;
    
    return await _client.put<Map<String, dynamic>>(
      ApiConstants.userProfile,
      data: data,
    );
  }

  /// Get authenticated user's preferences.
  /// 
  /// Returns user's application preferences and settings.
  /// Requires valid session token.
  /// 
  /// Response on success (200): User preferences object
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  Future<Map<String, dynamic>> getUserPreferences() async {
    return await _client.get<Map<String, dynamic>>(ApiConstants.userPreferences);
  }

  /// Update authenticated user's preferences.
  /// 
  /// Updates user's application preferences. All fields are optional.
  /// 
  /// Request body: User preferences object (fields vary based on schema)
  /// Response on success (200): Success message
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [ValidationException] on 400 for invalid preferences.
  Future<Map<String, dynamic>> updateUserPreferences(
    Map<String, dynamic> preferences,
  ) async {
    return await _client.put<Map<String, dynamic>>(
      ApiConstants.userPreferences,
      data: preferences,
    );
  }

  // ============================================================================
  // CONTENT ENDPOINTS
  // ============================================================================

  /// Get paginated content list.
  /// 
  /// Returns a paginated list of content items (audiobooks, etc.) with
  /// optional filtering and search capabilities.
  /// 
  /// Query parameters (all optional):
  /// - page: int (default: 1)
  /// - limit: int (default: 20, max: 100)
  /// - type: string? (filter by content type)
  /// - availability: string? (filter by availability)
  /// - featured: bool? (show only featured content)
  /// - popular: bool? (show only popular content)
  /// - search: string? (search query)
  /// - category: string? (filter by category ID)
  /// - author: string? (filter by author ID)
  /// - narrator: string? (filter by narrator ID)
  /// 
  /// Response includes content array and pagination metadata.
  Future<Map<String, dynamic>> getContent({
    int? page,
    int? limit,
    String? type,
    String? availability,
    bool? featured,
    bool? popular,
    String? search,
    String? category,
    String? author,
    String? narrator,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (type != null) queryParameters['type'] = type;
    if (availability != null) queryParameters['availability'] = availability;
    if (featured != null) queryParameters['featured'] = featured;
    if (popular != null) queryParameters['popular'] = popular;
    if (search != null) queryParameters['search'] = search;
    if (category != null) queryParameters['category'] = category;
    if (author != null) queryParameters['author'] = author;
    if (narrator != null) queryParameters['narrator'] = narrator;

    return await _client.get<Map<String, dynamic>>(
      ApiConstants.content,
      queryParameters: queryParameters,
    );
  }

  /// Get content item by ID.
  /// 
  /// Returns detailed information about a specific content item.
  /// 
  /// Response on success (200): Complete content object
  /// 
  /// Throws [NotFoundException] on 404 if content not found.
  Future<Map<String, dynamic>> getContentById(String id) async {
    return await _client.get<Map<String, dynamic>>(
      ApiConstants.contentById(id),
    );
  }

  /// Get chapters for content item.
  /// 
  /// Returns a list of chapters/sections for the specified content item.
  /// 
  /// Response on success (200): Array of chapter objects
  /// 
  /// Throws [NotFoundException] on 404 if content not found.
  Future<List<Map<String, dynamic>>> getContentChapters(String id) async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.contentChapters(id),
    );
    return response.cast<Map<String, dynamic>>();
  }

  /// Bookmark content item.
  /// 
  /// Creates a bookmark for the specified content item with optional note.
  /// Requires authentication.
  /// 
  /// Request body (optional):
  /// - note: string? (personal note for the bookmark)
  /// 
  /// Response on success (200): Bookmark creation confirmation
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if content not found.
  Future<Map<String, dynamic>> bookmarkContent(
    String id, {
    String? note,
  }) async {
    final data = <String, dynamic>{};
    if (note != null) data['note'] = note;

    return await _client.post<Map<String, dynamic>>(
      ApiConstants.contentBookmark(id),
      data: data,
    );
  }

  /// Remove bookmark from content item.
  /// 
  /// Removes the user's bookmark from the specified content item.
  /// Requires authentication.
  /// 
  /// Response on success (200): Bookmark removal confirmation
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if content or bookmark not found.
  Future<Map<String, dynamic>> removeContentBookmark(String id) async {
    return await _client.delete<Map<String, dynamic>>(
      ApiConstants.contentBookmark(id),
    );
  }

  // ============================================================================
  // AUTHOR ENDPOINTS
  // ============================================================================

  /// Get paginated authors list.
  /// 
  /// Returns a paginated list of authors with optional filtering.
  /// 
  /// Query parameters (all optional):
  /// - page: int (default: 1)
  /// - limit: int (default: 20, max: 100)
  /// - search: string? (search by author name)
  /// - genre: string? (filter by genre)
  /// - nationality: string? (filter by nationality)
  /// - verified: bool? (show only verified authors)
  /// 
  /// Response includes authors array and pagination metadata.
  Future<Map<String, dynamic>> getAuthors({
    int? page,
    int? limit,
    String? search,
    String? genre,
    String? nationality,
    bool? verified,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (search != null) queryParameters['search'] = search;
    if (genre != null) queryParameters['genre'] = genre;
    if (nationality != null) queryParameters['nationality'] = nationality;
    if (verified != null) queryParameters['verified'] = verified;

    return await _client.get<Map<String, dynamic>>(
      ApiConstants.authors,
      queryParameters: queryParameters,
    );
  }

  /// Get author by ID.
  /// 
  /// Returns detailed information about a specific author.
  /// 
  /// Response on success (200): Complete author object
  /// 
  /// Throws [NotFoundException] on 404 if author not found.
  Future<Map<String, dynamic>> getAuthorById(String id) async {
    return await _client.get<Map<String, dynamic>>(
      ApiConstants.authorById(id),
    );
  }

  /// Follow an author.
  /// 
  /// Creates a following relationship with the specified author.
  /// Requires authentication.
  /// 
  /// Response on success (200): Follow confirmation message
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if author not found.
  Future<Map<String, dynamic>> followAuthor(String id) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.followAuthor(id),
    );
  }

  /// Unfollow an author.
  /// 
  /// Removes the following relationship with the specified author.
  /// Requires authentication.
  /// 
  /// Response on success (200): Unfollow confirmation message
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if author not found.
  Future<Map<String, dynamic>> unfollowAuthor(String id) async {
    return await _client.delete<Map<String, dynamic>>(
      ApiConstants.followAuthor(id),
    );
  }

  // ============================================================================
  // CATEGORY ENDPOINTS
  // ============================================================================

  /// Get categories list.
  /// 
  /// Returns a list of content categories with optional filtering.
  /// 
  /// Query parameters (all optional):
  /// - featured: bool? (show only featured categories)
  /// - parent: string? (filter by parent category ID)
  /// - flat: bool? (return flat list vs hierarchical)
  /// 
  /// Response on success (200): Array of category objects
  Future<Map<String, dynamic>> getCategories({
    bool? featured,
    String? parent,
    bool? flat,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (featured != null) queryParameters['featured'] = featured;
    if (parent != null) queryParameters['parent'] = parent;
    if (flat != null) queryParameters['flat'] = flat;

    return await _client.get<Map<String, dynamic>>(
      ApiConstants.categories,
      queryParameters: queryParameters,
    );
  }

  /// Get category by ID.
  /// 
  /// Returns detailed information about a specific category.
  /// 
  /// Response on success (200): Complete category object
  /// 
  /// Throws [NotFoundException] on 404 if category not found.
  Future<Map<String, dynamic>> getCategoryById(String id) async {
    return await _client.get<Map<String, dynamic>>(
      ApiConstants.categoryById(id),
    );
  }

  // ============================================================================
  // BOOKMARK ENDPOINTS
  // ============================================================================

  /// Get user's bookmarks.
  /// 
  /// Returns a paginated list of the authenticated user's bookmarks.
  /// Requires authentication.
  /// 
  /// Query parameters (all optional):
  /// - page: int (default: 1)
  /// - limit: int (default: 20, max: 100)
  /// - type: string? (filter by content type)
  /// 
  /// Response includes bookmarks array and pagination metadata.
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  Future<Map<String, dynamic>> getBookmarks({
    int? page,
    int? limit,
    String? type,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (type != null) queryParameters['type'] = type;

    return await _client.get<Map<String, dynamic>>(
      ApiConstants.bookmarks,
      queryParameters: queryParameters,
    );
  }

  /// Update bookmark note.
  /// 
  /// Updates the personal note for an existing bookmark.
  /// Requires authentication.
  /// 
  /// Request body:
  /// - note: string (new note text)
  /// 
  /// Response on success (200): Update confirmation
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if bookmark not found.
  Future<Map<String, dynamic>> updateBookmark(
    String id, {
    required String note,
  }) async {
    return await _client.put<Map<String, dynamic>>(
      ApiConstants.bookmarkById(id),
      data: {'note': note},
    );
  }

  /// Delete bookmark.
  /// 
  /// Permanently removes a bookmark from the user's collection.
  /// Requires authentication.
  /// 
  /// Response on success (200): Deletion confirmation message
  /// 
  /// Throws [AuthenticationException] on 401 if not authenticated.
  /// Throws [NotFoundException] on 404 if bookmark not found.
  Future<Map<String, dynamic>> deleteBookmark(String id) async {
    return await _client.delete<Map<String, dynamic>>(
      ApiConstants.bookmarkById(id),
    );
  }
}