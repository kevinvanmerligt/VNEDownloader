# Patch Notes: VNEDownloader v1.0.2

- **Version**: 1.0.2
- **Release Date**: October 30, 2026
- **Target OS**: Android 8.0+ (API Level 26+)
- **Binary**: `VNEDownloader-v1.0.2.apk`

---

## 🛠️ Critical Bug Fixes & Improvements

### 1. Fixed Download Engine & Endless Buffering
- **Dio Streaming Core**: Switched download engine to use high-throughput `Dio` streaming with connection timeouts (25s) and receive timeouts (120s), eliminating indefinite stalls on stream initialization.
- **Fail-safe Fallback**: In case of CDN header mismatches, the engine gracefully falls back to chunked stream reading before reporting errors.

### 2. Fixed Duplicate Downloads on Retry
- **Single-Flight Retry**: Added `_pendingRetries` deduplication set to block rapid duplicate taps.
- **Item ID Reuse**: Retrying now reuses the existing `DownloadItem.id` in-place rather than generating new UUIDs, ensuring exactly one download occurs per video.

### 3. Fully Functional Cancel Button
- **Instant Abort**: Integrated `CancelToken` so pressing the Cancel (✕) button immediately stops the active HTTP connection.
- **Clean Storage**: Automatically deletes partial files (`.mp4` / `.mp3`) from storage upon cancellation.
- **Notification & DB Sync**: Dismisses the Android notification bar progress item and updates the local SQLite record to reflect cancellation.

### 4. Storage Permissions & On-Device Saving
- **Proper Manifest Scopes**: Added `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO`, and `READ/WRITE_EXTERNAL_STORAGE` with `requestLegacyExternalStorage="true"`.
- **Runtime Permission Handler**: Checks and requests storage permissions prior to writing to public device folders (`Download/`, `Movies/`).
- **Resilient Fallback**: If a public folder is restricted by vendor-specific Android ROM security, automatically falls back to app-specific external storage to ensure downloads never fail.

### 5. Custom Folder Selection in Settings
- **Native Android Directory Picker**: Added `FilePicker` integration allowing users to browse and pick any folder on internal storage or SD cards.
- **Instant Presets**: Quick one-tap options for `Movies/VNEDownloader`, `Download/VNEDownloader`, `Music/VNEDownloader`, and `DCIM/VNEDownloader`.

### 6. Suspicious App Warning & Error Sanitization
- **Clean Permissions**: Removed unmapped `FOREGROUND_SERVICE` permission that triggered Google Play Protect heuristics.
- **Rate-Limit Exception Sanitization**: Caught YouTube `RequestLimitExceededException` ("suspicious / rate limit") and translated it into friendly user guidance instead of raw technical warnings.

---

## 📦 Included Artifacts
- `VNEDownloader-v1.0.2.apk` — Optimized Release Package.

