# Patch Notes: VNEDownloader v1.0.0

- **Version**: 1.0.0 (MVP Stable Release)
- **Release Date**: October 30, 2026
- **Target OS**: Android 8.0+ (API Level 26+)
- **Binary**: `VNEDownloader-v1.0.0.apk` (Universal Release APK included in this folder)

---

## 🚀 Key Highlights & New Features

### 1. MP3 Audio & MP4 Video Extraction
- **Audio Only (MP3)**: Directly extract and download YouTube audio in the highest available bitrate with metadata (title, artist/channel name, thumbnail).
- **High-Definition Video (MP4)**: Support for multiple resolutions (360p, 480p, 720p HD, and 1080p Full HD) with real-time file size estimation before downloading.

### 2. High Refresh Rate Display Optimization (60Hz / 90Hz / 120Hz / 144Hz)
- Integrated native Android display mode switching (`Display.Mode`) to unlock peak panel refresh rates up to 144Hz.
- Smooth 120fps/144fps transitions, scrolling, and micro-animations across all modern flagship and gaming devices.

### 3. Native Background Download Service
- Real-time download progress tracking with Android system notifications.
- Automatic filename sanitization to prevent Android filesystem naming conflicts.
- Wi-Fi only download protection toggle to prevent unexpected cellular data consumption.

### 4. 100% On-Device Offline History
- Powered by local SQLite database (`vnedownloader.db`).
- Zero tracking, zero telemetry, and zero remote database dependencies.
- One-tap playback via the user's favorite external media player (VLC, MX Player, Google Files, etc.).
- Delete history with an optional clean-up of the physical storage file.

### 5. Clean Custom Branding & UI
- Custom circular blue download icon applied across all Android mipmap densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
- Clean bottom navigation with 3 intuitive tabs: **Download**, **History**, and **Settings**.
- Modern Material 3 design supporting Dark Theme, Light Theme, and System Default.
- Bilingual localization: Full support for English and Bahasa Indonesia.

---

## 🛠️ Internal Improvements & Architecture
- Built with Flutter 3.47 and Dart 3.10.
- State management powered by Flutter Riverpod for deterministic, reactive state handling.
- Optimized YouTube streaming engine with `youtube_explode_dart`.
- Platform directories cleaned: Stripped unused platforms (`windows`, `linux`, `macos`, `web`, `ios`) for a 100% Android-focused codebase.
- Core library desugaring enabled for broad Android OS compatibility.

---

## 📦 Included Artifacts
- `VNEDownloader-v1.0.0.apk` — Universal Android release package.

