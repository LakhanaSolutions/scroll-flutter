## API Wiring Guide (Flutter) — Compact

> Goal: wire existing UI to real APIs from Swagger/OpenAPI with all API actions centralized, and without changing API or frontend code.

### Non‑negotiables
- Do not modify API or frontend code in this step.
- If the frontend needs data not returned by the API, document it in `frontend/docs/api-changes-required.md` with: where it is needed, what is needed, endpoint, priority, and status.
- Code all API actions in one place. Choose one:
  - Single file for the whole app: `lib/data/api.dart`, or
  - One file per module: `lib/features/{{module}}/data/{{module}}_api.dart`

### Inputs
- Module/Page: `{{MODULE_NAME}}`
- Swagger/OpenAPI JSON: `{{PATH/TO/swagger.json}}`

### Steps (minimal)
1) Identify endpoints in Swagger used by `{{MODULE_NAME}}`.
2) Create/update the API actions file (single source of truth).
   - No UI imports. No widget logic. No direct network calls from widgets/VMs.
3) Define DTOs used by those endpoints under `lib/features/{{module}}/data/models/` (request and response as needed).
   - Use existing serializers/utilities in the project. Do not add new packages.
4) Implement endpoint methods using the existing HTTP client/utilities in the project.
   - Keep URL building, headers, and JSON mapping here only.
   - Return your app’s existing result type or DTOs, consistent with current codebase conventions.
5) Wire ViewModels/Providers to call these methods and update state. Widgets must not parse JSON.

### Method mapping (fill per module)
| Swagger Path | Verb | Purpose | Method in API file | Request DTO | Response DTO |
| --- | --- | --- | --- | --- | --- |
| `/{{resource}}` | GET | List | `fetch{{EntityPlural}}` | — | `Paged<{{Entity}}>` |
| `/{{resource}}/{id}` | GET | Details | `get{{Entity}}` | — | `{{Entity}}` |
| `/{{resource}}` | POST | Create | `create{{Entity}}` | `Create{{Entity}}Req` | `{{Entity}}` |
| `/{{resource}}/{id}` | PUT | Update | `update{{Entity}}` | `Update{{Entity}}Req` | `{{Entity}}` |
| `/{{resource}}/{id}` | DELETE | Remove | `delete{{Entity}}` | — | `void` |

### Example stub
```dart
// lib/features/{{module}}/data/{{module}}_api.dart
class {{Module}}Api {
  final HttpClient http; // use existing client/utilities
  {{Module}}Api(this.http);

  Future<{{Entity}}> get{{Entity}}(String id) async {
    final json = await http.get('/{{resource}}/$id');
    return {{Entity}}.fromJson(json);
  }
}
```

### Missing API data
If the UI needs fields not provided by the API, add an entry to `frontend/docs/api-changes-required.md` including: screen/widget and file, endpoint, fields needed, reason, priority, and status.

### Definition of done
- All `{{MODULE_NAME}}` API calls centralized in the chosen API file.
- DTOs exist for every request/response used.
- UI/ViewModels call the API file only; no JSON parsing in widgets.
- No new packages added. Any missing backend fields are logged in `api-changes-required.md`.
