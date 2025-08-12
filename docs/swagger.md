# API Endpoints Documentation

This file tracks the implementation status of all API endpoints from `swagger.json`.

## Endpoints List

| Method | Path                      | Model(s)                           | Service method                        | Status     |
|--------|---------------------------|------------------------------------|---------------------------------------|------------|
| GET    | /                         | ApiInfo                           | HealthService.getApiInfo              | Done       |
| GET    | /health                   | HealthResponse                    | HealthService.checkHealth             | Done       |
| POST   | /auth/request-otp         | OtpRequest, OtpResponse           | AuthService.requestOtp                | Done       |
| POST   | /auth/verify-otp          | VerifyOtpRequest, AuthResponse    | AuthService.verifyOtp                 | Done       |
| POST   | /auth/check-email         | CheckEmailRequest, CheckEmailResponse | AuthService.checkEmail            | Done       |
| GET    | /auth/session             | SessionResponse                   | AuthService.getSession                | Done       |
| POST   | /auth/signout             | MessageResponse                   | AuthService.signOut                   | Done       |
| GET    | /auth/{*}                 | -                                 | -                                     | Remaining  |
| POST   | /auth/{*}                 | -                                 | -                                     | Remaining  |
| GET    | /user/profile             | User                              | UserService.getProfile                | Done       |
| PUT    | /user/profile             | UserProfileUpdate, User           | UserService.updateProfile             | Done       |
| GET    | /user/preferences         | UserPreferences                   | UserService.getPreferences            | Done       |
| PUT    | /user/preferences         | UserPreferences, MessageResponse  | UserService.updatePreferences         | Done       |
| GET    | /content                  | Content[], Pagination             | ContentService.getContent             | Done       |
| GET    | /content/{id}             | Content                           | ContentService.getContentById         | Done       |
| GET    | /content/{id}/chapters    | Chapter[]                         | ContentService.getContentChapters     | Done       |
| POST   | /content/{id}/bookmark    | BookmarkRequest                   | ContentService.createBookmark         | Done       |
| DELETE | /content/{id}/bookmark    | MessageResponse                   | ContentService.deleteBookmark         | Done       |
| GET    | /authors                  | Author[], Pagination              | AuthorService.getAuthors              | Done       |
| GET    | /authors/{id}             | Author                            | AuthorService.getAuthorById           | Done       |
| POST   | /authors/{id}/follow      | MessageResponse                   | AuthorService.followAuthor            | Done       |
| DELETE | /authors/{id}/follow      | MessageResponse                   | AuthorService.unfollowAuthor          | Done       |
| GET    | /categories               | Category[]                        | CategoryService.getCategories         | Done       |
| GET    | /categories/{id}          | Category                          | CategoryService.getCategoryById       | Done       |
| GET    | /bookmarks                | Bookmark[], Pagination            | BookmarkService.getBookmarks          | Done       |
| PUT    | /bookmarks/{id}           | UpdateBookmarkRequest             | BookmarkService.updateBookmark        | Done       |
| DELETE | /bookmarks/{id}           | MessageResponse                   | BookmarkService.deleteBookmark        | Done       |

## Model Definitions

### Core Models
- `ApiResponse<T>` - Generic API response wrapper
- `Pagination` - Pagination metadata
- `ApiInfo` - API information
- `HealthResponse` - Health check response

### Authentication Models
- `OtpRequest` - OTP request payload
- `OtpResponse` - OTP response
- `VerifyOtpRequest` - OTP verification payload
- `CheckEmailRequest` - Email check request payload
- `CheckEmailResponse` - Email check response with user name
- `AuthResponse` - Authentication response with user and token
- `SessionResponse` - Current session response
- `SignoutResponse` - Sign out response

### User Models
- `User` - User profile model
- `UserPreferences` - User preferences model
- `UpdateProfileRequest` - Profile update payload

### Content Models
- `Content` - Content item model
- `Chapter` - Chapter model
- `Author` - Author model
- `Category` - Category model
- `Bookmark` - Bookmark model
- `BookmarkRequest` - Bookmark creation payload
- `UpdateBookmarkRequest` - Bookmark update payload

## Notes
- All endpoints requiring authentication use `bearerAuth` or `cookieAuth` security schemes
- Query parameters for pagination: `page` (default: 1), `limit` (default: 20, max: 100)
- Error responses typically include `error` and `message` fields
- Most endpoints support filtering and search parameters