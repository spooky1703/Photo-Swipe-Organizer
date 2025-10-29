# 📱 PhotoSwipeOrganizer

<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)

**A powerful, terminal-styled iOS app for efficiently organizing and cleaning your photo library**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [Contributing](#-contributing) • [License](#-license)

<img src="screenshots/demo.gif" alt="PhotoSwipeOrganizer Demo" width="300"/>

</div>

---

## 🎯 Overview

PhotoSwipeOrganizer is a native iOS application built with SwiftUI that helps users quickly review and organize their photo libraries through an intuitive swipe interface. Inspired by terminal aesthetics, the app combines powerful photo management capabilities with a unique, retro-tech visual design.

### Key Highlights

- 🎨 **Terminal-inspired UI** with customizable themes
- ⚡ **Lightning-fast photo review** with intelligent preloading
- 🎯 **Smart filtering** (screenshots, duplicates, date ranges, and more)
- 🌍 **Bilingual support** (English/Spanish)
- 📊 **Session statistics** and progress tracking
- 🔒 **Privacy-focused** with full local processing
- 💪 **Haptic feedback** for intuitive interactions

---

## ✨ Features

### 🗂️ Smart Photo Filtering

PhotoSwipeOrganizer offers multiple intelligent filters to help you target specific types of photos:

| Filter | Description |
|--------|-------------|
| 🎲 **Random Mode** | Completely randomized selection for unbiased review |
| 📱 **Screenshot Filter** | Automatically detects screenshots by resolution |
| 📸 **Photo Only** | Shows all photos from your library |
| ⚡ **Recent Batch** | Quick batch of recent photos |
| 👯 **Burst Detection** | Identifies photos taken in burst mode |
| 📅 **Current Month** | Files from the current month only |
| 🗄️ **Archive Mode** | Photos from previous years |

### 🎮 Intuitive Swipe Interface

- **Swipe Left (KEEP)**: Mark photo as worth keeping
- **Swipe Right (DELETE)**: Mark photo for deletion
- **Long Press**: View photo in full-screen mode
- **Visual Feedback**: Green/red overlays indicate your decision
- **Haptic Feedback**: Physical vibrations confirm actions

### ⚙️ Customization Options

- **Custom Display Name**: Personalize the terminal prompt
- **Language Toggle**: Switch between English and Spanish
- **Batch Size Selection**: Review 10, 20, 50, or 100 photos per session
- **Filter Presets**: Quick access to your favorite filtering modes

### 🔐 Privacy & Security

- **100% On-Device Processing**: No data leaves your iPhone
- **Photo Library Permissions**: Full control over what the app can access
- **Safe Deletion Flow**: Review all marked photos before permanent deletion
- **No Analytics**: Zero tracking or data collection

---

## 📸 Screenshots

<div align="center">

| Selector | Swipe View | Review Screen |
|----------|------------|---------------|
| ![Selector](screenshots/selector.png) | ![Swipe](screenshots/swipe.png) | ![Review](screenshots/review.png) |

| Settings | Permission | Success |
|----------|------------|---------|
| ![Settings](screenshots/settings.png) | ![Permission](screenshots/permission.png) | ![Success](screenshots/success.png) |

</div>

---

## 🚀 Installation

### Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- An iPhone or iPad device (simulator supported)

### Building from Source

1. **Clone the repository**
   ```bash
   git clone https://github.com/Spooky17/PhotoSwipeOrganizer.git
   cd PhotoSwipeOrganizer
   ```

2. **Open in Xcode**
   ```bash
   open PhotoSwipeOrganizer.xcodeproj
   ```

3. **Configure signing**
   - Select the project in the navigator
   - Go to "Signing & Capabilities"
   - Select your development team
   - Update the Bundle Identifier if needed

4. **Run the app**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Required Permissions

The app requires photo library access. Ensure the following keys are in your `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Esta app necesita acceso a tu galería para organizar fotos</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Esta app puede modificar tu galería</string>

<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key>
<true/>
```

---

## 📖 Usage

### Quick Start Guide

1. **Launch the app** and grant photo library permissions
2. **Select a filter** from the available options
3. **Choose batch size** (10, 20, 50, or 100 photos)
4. **Tap EXECUTE** to start your review session
5. **Swipe or tap buttons** to mark photos:
   - Left/👍 = KEEP
   - Right/🗑️ = DELETE
6. **Review your selections** before confirming
7. **Confirm deletion** to permanently remove marked photos

### Advanced Tips

- **Long-press** on any photo to view it in full-screen
- **Use Digital Crown** (Apple Watch) to navigate between photos
- **Change settings** via the gear icon in the top-right
- **Reset session** anytime from the review screen

---

## 🏗️ Architecture

PhotoSwipeOrganizer follows the **MVVM (Model-View-ViewModel)** architecture pattern with clear separation of concerns.

### Project Structure

```
PhotoSwipeOrganizer/
├── App/
│   └── App.swift                    # App entry point
├── Models/
│   └── PhotoItem.swift              # Photo data model
├── Managers/
│   └── PhotoManager.swift           # Photo library operations
├── ViewModels/
│   └── PhotoViewModel.swift         # Business logic & state
├── Views/
│   ├── ContentView.swift            # Main container view
│   ├── SwipeView.swift              # Photo review interface
│   └── ReviewView.swift             # Deletion confirmation
├── Settings/
│   ├── AppSettings.swift            # User preferences
│   ├── Localizable.swift            # i18n strings
│   └── SettingsView.swift           # Settings UI
└── Assets.xcassets/                 # Images and colors
```

### Key Components

#### 📦 Models

- **PhotoItem**: Represents a photo/video with metadata
- **PhotoFilter**: Enum for filtering modes
- **SessionStats**: Tracks review session metrics

#### 🎛️ Managers

- **PhotoManager**: Singleton for photo library access
  - Fetches photos based on filters
  - Loads images asynchronously
  - Handles photo deletion
  - Detects screenshots by resolution

#### 🧠 ViewModels

- **PhotoViewModel**: Manages app state and business logic
  - Coordinates photo loading
  - Handles swipe gestures
  - Manages deletion queue
  - Provides haptic feedback

#### 🎨 Views

- **ContentView**: Main navigation and state routing
- **SwipeView**: Interactive photo review interface
- **ReviewView**: Deletion confirmation screen
- **SettingsView**: User preferences panel

### Design Patterns

- **Singleton**: `PhotoManager.shared`, `AppSettings.shared`
- **Observer Pattern**: `@Published` properties with `@ObservedObject`
- **Dependency Injection**: ViewModels injected into Views
- **Async/Await**: Modern Swift concurrency for photo operations

---

## 🎨 Customization

### Theming

The app uses a terminal-inspired design with monospaced fonts and a green-on-black color scheme. To customize:

1. Edit `Assets.xcassets` to change colors
2. Modify font declarations in Views
3. Update `Localizable.swift` for text customization

### Adding New Filters

To add a custom filter:

1. Add a new case to `PhotoFilter` enum in `PhotoManager.swift`
2. Implement filtering logic in `applySpecificFilter()`
3. Add localized strings in `Localizable.swift`
4. Update the UI in `TerminalSelectorView`

Example:
```swift
case .largeVideos = "largeVideos"

// In applySpecificFilter()
case .largeVideos:
    return photos.filter { 
        $0.isVideo && $0.asset.duration > 60 
    }
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

### Reporting Bugs

Open an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device and iOS version

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftLint for consistency
- Add comments for complex logic
- Write descriptive commit messages

---

## 🐛 Known Issues

- [ ] Video playback may lag on older devices
- [ ] Large photo libraries (>10,000 photos) may have slower initial load
- [ ] Some Live Photos may not display duration correctly

See [Issues](https://github.com/Spooky17/PhotoSwipeOrganizer/issues) for full list.

---

## 🗺️ Roadmap

### Version 2.0
- [ ] Apple Watch companion app
- [ ] Widget support
- [ ] iCloud sync for deleted photo logs
- [ ] Advanced duplicate detection using perceptual hashing
- [ ] Blur detection using image analysis

### Version 3.0
- [ ] Machine learning photo quality assessment
- [ ] Automatic categorization
- [ ] Batch operations
- [ ] Export deletion reports

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Spooky17

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👨‍💻 Author

**Spooky17**

- Email: ryverz.alonso@gmail.com
- GitHub: [@Spooky17](https://github.com/Spooky17)
- Location: México 🇲🇽

---

## 🙏 Acknowledgments

- Inspired by Tinder's swipe interface
- Terminal aesthetics inspired by classic Unix terminals
- Built with love using SwiftUI and modern iOS frameworks
- Thanks to the Swift community for excellent documentation

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/Spooky17/PhotoSwipeOrganizer?style=social)
![GitHub forks](https://img.shields.io/github/forks/Spooky17/PhotoSwipeOrganizer?style=social)
![GitHub issues](https://img.shields.io/github/issues/Spooky17/PhotoSwipeOrganizer)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Spooky17/PhotoSwipeOrganizer)

---

<div align="center">

**If you find this project useful, please consider giving it a ⭐️!**

Made with ❤️ by Spooky17

</div>

