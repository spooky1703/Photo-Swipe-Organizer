# Changelog

All notable changes to PhotoSwipeOrganizer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Apple Watch companion app
- Widget support for iOS home screen
- Advanced duplicate detection using perceptual hashing
- Machine learning photo quality assessment
- iCloud sync for deletion logs

---

## [1.0.0] - 2025-10-29

### Added
- Initial release of PhotoSwipeOrganizer
- Terminal-inspired user interface with monospaced fonts
- Swipe-based photo review system (Tinder-style)
- Seven smart photo filters:
  - Random Mode: Completely randomized selection
  - Screenshot Filter: Detects screenshots by resolution
  - Photo Only: Shows all photos from library
  - Recent Batch: Quick batch of recent photos
  - Burst Detection: Identifies burst mode photos
  - Current Month: Files from current month only
  - Archive Mode: Photos from previous years
- Bilingual support (English/Spanish)
- Customizable display name in settings
- Batch size selection (10, 20, 50, 100 photos)
- Visual feedback with green/red overlays during swipe
- Haptic feedback for all interactions
- Long-press gesture for full-screen photo view
- Review screen with deletion confirmation
- Success screen with session statistics
- Permission handling for photo library access
- Dark mode support with terminal aesthetics

### Features
- **Photo Management**
  - Fetch photos from library with smart filtering
  - Async image loading with preloading optimization
  - Video support with duration display
  - Safe deletion with review step

- **User Experience**
  - Smooth animations on swipe gestures
  - Rotation effect based on drag distance
  - Opacity fade on swipe
  - Loading states with animated dots
  - Empty state handling
  - Error message display

- **Performance**
  - Intelligent image preloading (next 10 photos)
  - Task cancellation for cancelled operations
  - Memory-efficient image caching
  - Target size optimization (800x800px)
  - Background thread processing

- **Settings**
  - Custom username with terminal prompt
  - Language toggle (English/Spanish)
  - Persistent preferences using @AppStorage

### Technical
- SwiftUI-based user interface
- MVVM architecture pattern
- Singleton pattern for managers
- Async/await for concurrency
- Photos framework (PHAsset) integration
- Combine framework for reactive updates
- UIImpactFeedbackGenerator for haptics
- AVFoundation for video support

### Security
- Local-only processing (no cloud uploads)
- Photo library permissions with descriptive messages
- No analytics or tracking
- No external dependencies

---

## Version History

### Pre-release Development

#### [0.3.0] - 2025-10-28
- Fixed range error in preloadNextImages()
- Improved deletion confirmation flow
- Added visual overlay animations
- Fixed bug where deleted photos reappeared
- Fixed random mode not re-shuffling between sessions

#### [0.2.0] - 2025-10-27
- Implemented review screen
- Added deletion confirmation
- Created settings panel
- Implemented bilingual support

#### [0.1.0] - 2025-10-26
- Initial prototype
- Basic swipe functionality
- Terminal-style UI concept
- Photo library integration

---

## Upgrade Guide

### From 0.x to 1.0

No breaking changes. Simply replace the app.

---

## Known Issues

### Version 1.0.0

- Video playback may lag on iPhone 11 and older devices
- Large photo libraries (>10,000 photos) may have slower initial load times
- Some Live Photos may not display duration correctly
- Screenshot detection may not work for all device models

See [GitHub Issues](https://github.com/Spooky17/PhotoSwipeOrganizer/issues) for the complete list.

---

## Deprecations

None in version 1.0.0

---

## Contributors

- **Spooky17** - Initial development and design

---

## Release Notes

### 1.0.0 - "Terminal Vision"

This is the first stable release of PhotoSwipeOrganizer! 🎉

PhotoSwipeOrganizer brings a unique, terminal-inspired approach to photo management on iOS. With smart filtering, intuitive swipe gestures, and bilingual support, cleaning your photo library has never been easier or more enjoyable.

**Highlights:**
- 🎨 Unique terminal aesthetic
- ⚡ Lightning-fast photo review
- 🌍 English/Spanish support
- 🎯 Seven smart filters
- 💪 Haptic feedback throughout

Thank you to everyone who provided feedback during development!

---

**For detailed technical information, see [ARCHITECTURE.md](ARCHITECTURE.md)**

**For contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md)**

