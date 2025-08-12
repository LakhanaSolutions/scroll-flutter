### Goal
Create a single, clean, and well-documented API layer file in `frontend/lib/api/` that exposes methods for all endpoints described in `frontend/docs/swagger.md`, using request/response shapes from `frontend/docs/swagger.json`, and internally delegates HTTP work to `frontend/lib/api/api_client.dart`.

### Where to look
- `docs/swagger.md`: Human-readable list of endpoints and tags you must cover.
- `docs/swagger.json`: Exact request bodies, query params, path params, and response schemas.
- `lib/api/api_client.dart`: Use only these methods for network calls: `get`, `post`, `put`, `patch`, `delete`, `downloadFile`, `uploadFile`. Authentication is already handled via interceptor and `session_token`.

### What to create
- Add a new file: `lib/api/scroll_api.dart` (single file for all API calls).
- Define one public class: `ScrollApi`.
  - Provide a `factory ScrollApi()` or a static singleton pattern if preferred.
  - Store a private `final ApiClient _client = ApiClient();`.
  - Each endpoint becomes a public method grouped by feature/tag (use section comments).
  - Add rich Dartdoc (`///`) for every method, parameter, and return type.

### Structure and conventions
- Group methods by tags from `swagger.md` (in this order): Health, Auth, Users, Content, Authors, Categories, Bookmarks.
- Naming: `getHealth`, `requestOtp`, `verifyOtp`, `checkEmail`, `getSession`, `signOut`, `getUserProfile`, `updateUserProfile`, `getUserPreferences`, `updateUserPreferences`, `getContent`, `getContentById`, `getContentChapters`, `bookmarkContent`, `removeContentBookmark`, `getAuthors`, `getAuthorById`, `followAuthor`, `unfollowAuthor`, `getCategories`, `getCategoryById`, `getBookmarks`, `updateBookmark`, `deleteBookmark`.
- Parameters:
  - Path params as required `String` args (e.g., `id`).
  - Query params as optional named args with proper Dart types (int/bool/String/list). Only include params defined in `swagger.json`.
  - Body params: create `Map<String, dynamic>` payloads that mirror `swagger.json` schemas.
- Return types:
  - Prefer typed models if already exist in `lib/models` (e.g., `User`).
  - Otherwise return `Map<String, dynamic>` or typed lists/maps that reflect `swagger.json`.
  - Do not throw on 200/201/204; the client already handles status codes. Let `ApiExceptionHandler` propagate errors.
- Comments: Add method-level Dartdoc explaining endpoint, parameters, and the shape of the returned data (field names/types from `swagger.json`).

### Endpoint-to-method checklist
- Health
  - GET `/health` → `Future<Map<String, dynamic>> getHealth()`

- Auth
  - POST `/auth/request-otp` (body: `{ email }`) → `Future<Map<String, dynamic>> requestOtp({ required String email })`
  - POST `/auth/verify-otp` (body: `{ email, otp }`) → `Future<Map<String, dynamic>> verifyOtp({ required String email, required String otp })`
  - POST `/auth/check-email` (body: `{ email }`) → `Future<Map<String, dynamic>> checkEmail({ required String email })`
  - GET `/auth/session` → `Future<Map<String, dynamic>> getSession()`
  - POST `/auth/signout` → `Future<Map<String, dynamic>> signOut()` (also call `_client.signOut()` to clear local token)

- Users
  - GET `/user/profile` → `Future<Map<String, dynamic>> getUserProfile()` (or a `User` if you map it)
  - PUT `/user/profile` (body per schema) → `Future<Map<String, dynamic>> updateUserProfile({ String? name, String? bio, String? nationality })`
  - GET `/user/preferences` → `Future<Map<String, dynamic>> getUserPreferences()`
  - PUT `/user/preferences` (body per schema) → `Future<Map<String, dynamic>> updateUserPreferences({...})`

- Content
  - GET `/content` (query: `page, limit, type, availability, featured, popular, search, category, author, narrator`) → `Future<Map<String, dynamic>> getContent({...})`
  - GET `/content/{id}` → `Future<Map<String, dynamic>> getContentById(String id)`
  - GET `/content/{id}/chapters` → `Future<List<Map<String, dynamic>>> getContentChapters(String id)`
  - POST `/content/{id}/bookmark` (body: `{ note? }`) → `Future<Map<String, dynamic>> bookmarkContent(String id, { String? note })`
  - DELETE `/content/{id}/bookmark` → `Future<Map<String, dynamic>> removeContentBookmark(String id)`

- Authors
  - GET `/authors` (query: `page, limit, search, genre, nationality, verified`) → `Future<Map<String, dynamic>> getAuthors({...})`
  - GET `/authors/{id}` → `Future<Map<String, dynamic>> getAuthorById(String id)`
  - POST `/authors/{id}/follow` → `Future<Map<String, dynamic>> followAuthor(String id)`
  - DELETE `/authors/{id}/follow` → `Future<Map<String, dynamic>> unfollowAuthor(String id)`

- Categories
  - GET `/categories` (query: `featured, parent, flat`) → `Future<Map<String, dynamic>> getCategories({...})`
  - GET `/categories/{id}` → `Future<Map<String, dynamic>> getCategoryById(String id)`

- Bookmarks
  - GET `/bookmarks` (query: `page, limit, type`) → `Future<Map<String, dynamic>> getBookmarks({...})`
  - PUT `/bookmarks/{id}` (body: `{ note }`) → `Future<Map<String, dynamic>> updateBookmark(String id, { required String note })`
  - DELETE `/bookmarks/{id}` → `Future<Map<String, dynamic>> deleteBookmark(String id)`

### Implementation template (use this pattern for all methods)
```dart
/// Returns server health status and DB connectivity.
/// See docs/swagger.json -> /health -> 200 schema for fields: status, timestamp, uptime, database.
Future<Map<String, dynamic>> getHealth() async {
  return await _client.get<Map<String, dynamic>>('/health');
}

/// Request OTP for email authentication.
/// Body: { "email": string }
Future<Map<String, dynamic>> requestOtp({ required String email }) async {
  return await _client.post<Map<String, dynamic>>(
    '/auth/request-otp',
    data: { 'email': email },
  );
}
```

### Error handling
- Do not wrap in try/catch unless you need to transform errors. Let `ApiExceptionHandler` in `api_exceptions.dart` handle Dio errors.
- Document expected error responses in Dartdoc using details from `swagger.json` (e.g., 400/401/404 message shapes).

### Authentication
- The client attaches the session token automatically. For endpoints that require auth, simply call the appropriate `_client` method.
- After successful OTP verification, call `_client.setSessionToken(sessionToken)` with the value from the response payload.
- On sign-out, call both the API and `_client.signOut()` to clear local storage.

### Data mapping
- If a response corresponds to an existing model (e.g., `lib/models/user_model.dart`), parse it before returning or expose a typed overload. Otherwise, return the exact JSON map/list.
- Keep mapping minimal for now; the primary goal is to expose complete endpoint coverage.

### Documentation requirements
- Every method must include:
  - Brief summary that matches the endpoint summary in `swagger.md`.
  - Link hint to the corresponding path in `swagger.json` for request/response shapes.
  - Description of parameters (including optionality and type) and return structure.
  - Notes on auth requirements if applicable.

### Acceptance criteria
- One file `lib/api/scroll_api.dart` contains all API methods listed above.
- No direct `Dio` usage; only calls through `ApiClient` methods.
- Methods are grouped, named, and documented as specified.
- Query/body/path params and return shapes align with `swagger.json`.

