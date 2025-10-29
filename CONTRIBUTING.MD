
# 🤝 Contributing to PhotoSwipeOrganizer

First off, thank you for considering contributing to PhotoSwipeOrganizer! It's people like you that make this app better for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Process](#development-process)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

---

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Standards

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

---

## 🚀 Getting Started

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Git
- A GitHub account

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/PhotoSwipeOrganizer.git
   cd PhotoSwipeOrganizer
   ```

3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/Spooky17/PhotoSwipeOrganizer.git
   ```

4. **Open in Xcode**:
   ```bash
   open PhotoSwipeOrganizer.xcodeproj
   ```

5. **Build and run** to ensure everything works

---

## 💡 How Can I Contribute?

### Reporting Bugs

Bugs are tracked as [GitHub issues](https://github.com/Spooky17/PhotoSwipeOrganizer/issues). Before creating a bug report, please check existing issues to avoid duplicates.

**When filing a bug report, please include:**

- **Clear title**: Summarize the problem in one sentence
- **Description**: Detailed description of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What you expected to happen
- **Actual behavior**: What actually happened
- **Screenshots**: If applicable
- **Environment**:
  - iOS version
  - Device model
  - App version
  - Xcode version (if building from source)

**Example:**

```markdown
## Bug: App crashes when deleting more than 100 photos

**Description:**
The app crashes when attempting to confirm deletion of more than 100 photos at once.

**Steps to Reproduce:**
1. Select Random filter
2. Set batch size to 100
3. Mark all 100 photos for deletion
4. Tap "CONFIRM_DELETE"
5. App crashes

**Expected:** Photos should be deleted successfully
**Actual:** App crashes with error XYZ

**Environment:**
- iOS: 17.2
- Device: iPhone 15 Pro
- App version: 1.0.0
```

### Suggesting Enhancements

Enhancement suggestions are also tracked as GitHub issues. 

**When suggesting an enhancement:**

- **Use a clear title** that describes the suggestion
- **Provide detailed description** of the suggested enhancement
- **Explain why** this enhancement would be useful
- **Include mockups or examples** if applicable

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:

- `good first issue` - Simple issues perfect for newcomers
- `help wanted` - Issues where we need community help
- `documentation` - Improvements to documentation

---

## 🔄 Development Process

### Branch Naming Convention

Use descriptive branch names:

- `feature/` - New features (e.g., `feature/apple-watch-app`)
- `fix/` - Bug fixes (e.g., `fix/crash-on-deletion`)
- `docs/` - Documentation (e.g., `docs/update-readme`)
- `refactor/` - Code refactoring (e.g., `refactor/photoviewmodel`)
- `test/` - Adding tests (e.g., `test/photo-manager`)

### Workflow

1. **Sync your fork** with upstream:
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a new branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** and commit regularly

4. **Test thoroughly**:
   - Run on simulator
   - Test on real device if possible
   - Verify all existing functionality still works

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

---

## 📝 Style Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Key points:

#### Naming

```swift
// ✅ Good
func loadPhotos(withFilter filter: PhotoFilter) async -> [PhotoItem]
var isMarkedForDeletion: Bool
let maximumPhotoCount = 100

// ❌ Bad
func load(f: PhotoFilter) async -> [PhotoItem]
var marked: Bool
let max = 100
```

#### Code Organization

```swift
// MARK: - Lifecycle
override func viewDidLoad() { }

// MARK: - Public Methods
func publicMethod() { }

// MARK: - Private Methods
private func privateMethod() { }

// MARK: - Actions
@IBAction func buttonTapped(_ sender: UIButton) { }
```

#### SwiftUI

```swift
// ✅ Prefer computed properties for simple views
var body: some View {
    VStack {
        headerView
        contentView
    }
}

private var headerView: some View {
    Text("Header")
}

// ✅ Extract complex views into separate structs
struct ComplexView: View {
    var body: some View {
        // Complex UI
    }
}
```

#### Comments

```swift
// ✅ Good comments explain WHY, not WHAT
// Preload next 10 images to ensure smooth scrolling
preloadNextImages()

// ❌ Bad comments repeat the code
// Call preloadNextImages function
preloadNextImages()
```

### File Organization

```
📁 NewFeature/
├── FeatureView.swift        # Main view
├── FeatureViewModel.swift   # Business logic
├── FeatureModel.swift       # Data models
└── FeatureManager.swift     # Services/Managers
```

---

## 💬 Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```bash
feat(filters): add large video filter

Adds a new filter to detect videos longer than 5 minutes.
This helps users identify space-consuming media files.

Closes #123
```

```bash
fix(swipe): resolve crash when reaching last photo

Fixed a crash that occurred when users swiped past the
final photo in a session. Added bounds checking in
moveToNextPhoto().

Fixes #456
```

```bash
docs(readme): update installation instructions

Updated README with clearer steps for configuring
code signing in Xcode 15.
```

---

## 🔍 Pull Request Process

### Before Submitting

- [ ] Code follows the style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated if needed
- [ ] No new warnings in Xcode
- [ ] Tested on iOS simulator
- [ ] Tested on real device (if possible)

### PR Template

When creating a PR, use this template:

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where needed
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have tested on simulator
- [ ] I have tested on device
```

### Review Process

1. **Automated checks** must pass (if configured)
2. **Code review** by maintainers
3. **Address feedback** and push updates
4. **Approval** from at least one maintainer
5. **Merge** by maintainers

### After Merge

- Your branch will be deleted
- Update your local repository:
  ```bash
  git checkout main
  git pull upstream main
  git push origin main
  ```

---

## 🧪 Testing Guidelines

### Manual Testing Checklist

- [ ] App launches successfully
- [ ] Permission flow works correctly
- [ ] All filters work as expected
- [ ] Swipe gestures function properly
- [ ] Photo deletion works correctly
- [ ] Settings persist between launches
- [ ] Language switching works
- [ ] No memory leaks during extended use
- [ ] Performance is acceptable with large libraries

### Edge Cases to Test

- Empty photo library
- Library with only videos
- Library with 10,000+ photos
- Airplane mode / no connectivity
- Low storage situations
- iOS Dark Mode

---

## 📚 Additional Resources

- [Swift Style Guide](https://google.github.io/swift/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Photos Framework](https://developer.apple.com/documentation/photokit)
- [Git Tutorial](https://git-scm.com/docs/gittutorial)

---

## ❓ Questions?

If you have questions:

1. Check the [Wiki](https://github.com/Spooky17/PhotoSwipeOrganizer/wiki)
2. Open a [Discussion](https://github.com/Spooky17/PhotoSwipeOrganizer/discussions)
3. Contact maintainers: ryverz.alonso@gmail.com

---

## 🎉 Recognition

Contributors will be added to the README and receive credit for their work. Thank you for making PhotoSwipeOrganizer better!

---

<div align="center">

**Happy Contributing! 🚀**

</div>
