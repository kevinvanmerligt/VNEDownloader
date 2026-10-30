# Patch Notes: VNEDownloader v1.0.0

- **Version**: 1.0.0 (MVP Stable Release)
- **Release Date**: October 30, 2026
- **Target OS**: Android 8.0+ (API Level 26+)
- **Binary**: `VNEDownloader-v1.0.0.apk` (~21 MB Optimized Release APK)

---

## 🚀 Key Highlights & New Updates

### 1. Visual Refresh & Exact Mockup Styling
- **Header Bar**: Removed the "Aktif" status badge for a cleaner, minimal header layout matching the design mockup.
- **Hero & Input**: Clean white background, subtle `#E5E7EB` borders, and an integrated "📋 Tempel" chip button.
- **Action Button**: Solid Sky Blue (`#38A2F2`) button in Light Theme; solid Halloween Blood Red (`#991B1B`) in Dark Theme.
- **History List Preview**: Clean flat cards with document/video icons and pill status badges ("Selesai" and "Gagal").
- **Flat FAQ Accordion**: Divider lines with trailing `+` expand icons, matching the minimalist product design.

### 2. Halloween Blood Red & Matte Pure Black Dark Theme
- **Halloween Blood Red**: Deep, rich blood red (`#991B1B` / `#DC2626`) accents without neon glow or AI slop gradients.
- **Matte Pure Black**: Deep charcoal and true black surfaces (`#0A0A0A` / `#141414`) for maximum battery efficiency on OLED/AMOLED displays.

### 3. Ultra-Smooth Tab Switching Animations
- Added `AnimatedSwitcher` with `Curves.easeOutCubic` and 280ms duration for fluid cross-fading and subtle slide animations between tabs.
- Optimized for high refresh rates (60Hz, 90Hz, 120Hz, and 144Hz) with zero frame drops.

### 4. Significant APK Size Reduction
- Size reduced by **~65%** (from **62.0 MB** down to **~21 MB**) using targeted architecture optimization (`arm64-v8a`).
- Provides 3x faster downloads and minimal storage footprint while supporting modern Android devices.

### 5. MP3 Audio & MP4 Video Extraction
- **Audio Only (MP3)**: Directly extract and download YouTube audio at the highest available bitrate.
- **High-Definition Video (MP4)**: Support for 360p, 480p, 720p HD, and 1080p Full HD with real-time file size estimation.

### 6. Background Download & On-Device Storage
- Native Android download progress notifications.
- 100% on-device SQLite history (`vnedownloader.db`) with one-tap external media playback.

---

## 📦 Included Artifacts
- `VNEDownloader-v1.0.0.apk` — Lightweight Release Package (~21 MB).
