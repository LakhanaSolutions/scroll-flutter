## API Changes Required — Log

Purpose: Track any frontend data needs that are not currently returned by the API. Do not modify API or frontend code here; log the requirement clearly for backend follow‑up.

### How to add an entry
- One row per need. Keep it concise and actionable.
- Update Status as work progresses.

### Fields
- Where needed: screen/widget and file path (and line if helpful)
- Endpoint: expected API path and verb
- What is needed: fields and types (example values if possible)
- Reason: why the UI needs it (UX/state/logic)
- Priority: high/medium/low
- Status: todo/in‑progress/done
- Owner: person responsible
- Date: yyyy‑mm‑dd

### Table
| Where needed | Endpoint | What is needed | Reason | Priority | Status | Owner | Date |
| --- | --- | --- | --- | --- | --- | --- | --- |
| e.g., `PlaylistScreen` — `lib/screens/playlist_screen.dart` (badge) | GET `/contents/{id}` | `availability: 'free' | 'premium'` | Show top‑center availability badge | High | todo | @you | 2025-08-11 |

### Notes
- Prefer grouping related fields into a single entry per endpoint.
- If the change impacts multiple screens, list all under “Where needed”.

