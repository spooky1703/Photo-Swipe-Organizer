import SwiftUI
import Photos

struct ContentView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @StateObject private var photoManager = PhotoManager.shared
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if photoManager.authorizationStatus == .notDetermined ||
               photoManager.authorizationStatus == .denied {
                PermissionView()
            } else if viewModel.showPhotoCountSelector {
                TerminalSelectorView(viewModel: viewModel)
            } else if viewModel.isLoading {
                TerminalLoadingView()
            } else if viewModel.showReviewScreen {
                ReviewView(viewModel: viewModel)
            } else if viewModel.hasMorePhotos {
                SwipeView(viewModel: viewModel)
            } else {
                EmptyStateView {
                    Task {
                        await viewModel.resetSession()
                        await viewModel.loadAllPhotos()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            if photoManager.authorizationStatus == .authorized {
                await viewModel.loadAllPhotos()
            }
        }
    }
}

struct TerminalHeader: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var blinkingCursor = true
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Text("\(settings.displayName)@\(Localizable.text("terminal.command", isEnglish: settings.isEnglish))")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.green)
                
                Text("~")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.white)
                
                Text("$")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.green)
                
                Text(Localizable.text("terminal.script", isEnglish: settings.isEnglish))
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.cyan)
                
                Text(blinkingCursor ? "█" : " ")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.green)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: blinkingCursor)
                
                Spacer()
                
                Button(action: {
                    settings.showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(white: 0.1))
            
            Divider()
                .background(Color.green.opacity(0.3))
        }
        .sheet(isPresented: $settings.showSettings) {
            SettingsView(settings: settings, isPresented: $settings.showSettings)
        }
        .onAppear {
            withAnimation {
                blinkingCursor.toggle()
            }
        }
    }
}

struct TerminalSelectorView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    @State private var selectedCount: Int = 20
    @State private var selectedFilter: PhotoFilter = .random
    
    var body: some View {
        VStack(spacing: 0) {
            TerminalHeader()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        TerminalText("> \(Localizable.text("system.ready", isEnglish: settings.isEnglish))")
                        TerminalText("> \(Localizable.text("system.gallery", isEnglish: settings.isEnglish)): \(viewModel.totalPhotosAvailable) \(Localizable.text("items", isEnglish: settings.isEnglish))")
                        TerminalText("> \(Localizable.text("system.storage", isEnglish: settings.isEnglish))")
                        TerminalText("")
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Divider().background(Color.green.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText("> \(Localizable.text("select.filter", isEnglish: settings.isEnglish))")
                        
                        ForEach(PhotoFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                filter: filter,
                                isSelected: selectedFilter == filter,
                                isEnglish: settings.isEnglish,
                                action: {
                                    selectedFilter = filter
                                    Task {
                                        await viewModel.loadAllPhotos(withFilter: filter)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.green.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TerminalText("> \(Localizable.text("batch.size", isEnglish: settings.isEnglish)) \(selectedCount)")
                        
                        HStack(spacing: 16) {
                            TerminalButton(text: "-10") {
                                if selectedCount > 10 {
                                    selectedCount -= 10
                                }
                            }
                            
                            Text("\(selectedCount)")
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(.green)
                                .frame(minWidth: 120)
                            
                            TerminalButton(text: "+10") {
                                if selectedCount < viewModel.totalPhotosAvailable {
                                    selectedCount += 10
                                }
                            }
                        }
                        
                        HStack(spacing: 8) {
                            ForEach([10, 20, 50, 100], id: \.self) { count in
                                if count <= viewModel.totalPhotosAvailable {
                                    TerminalPresetButton(
                                        count: count,
                                        isSelected: selectedCount == count
                                    ) {
                                        selectedCount = count
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewModel.startReviewSession(withPhotoCount: selectedCount)
                        }
                    }) {
                        HStack {
                            Text("> \(Localizable.text("execute", isEnglish: settings.isEnglish))")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.black)
    }
}

struct FilterButton: View {
    let filter: PhotoFilter
    let isSelected: Bool
    let isEnglish: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(isSelected ? "●" : "○")
                        .foregroundColor(isSelected ? .green : .gray)
                    
                    Text(filter.icon)
                    
                    Text(Localizable.text("filter.\(filter.rawValue)", isEnglish: isEnglish))
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(isSelected ? .green : .gray)
                    
                    Spacer()
                }
                
                if isSelected {
                    Text("   └─ \(Localizable.text("desc.\(filter.rawValue)", isEnglish: isEnglish))")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.green.opacity(0.7))
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TerminalText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, design: .monospaced))
            .foregroundColor(.green)
    }
}

struct TerminalButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
                .frame(width: 60, height: 60)
                .background(Color(white: 0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: 1)
                )
        }
    }
}

struct TerminalPresetButton: View {
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(count)")
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundColor(isSelected ? .black : .green)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color.clear)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.green, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct TerminalLoadingView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var dots = ""
    @State private var currentMessageIndex = 0
    
    var loadingMessages: [String] {
        [
            Localizable.text("loading.scan", isEnglish: settings.isEnglish),
            Localizable.text("loading.analyze", isEnglish: settings.isEnglish),
            Localizable.text("loading.thumbnails", isEnglish: settings.isEnglish),
            Localizable.text("loading.prepare", isEnglish: settings.isEnglish)
        ]
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("> \(loadingMessages[currentMessageIndex])\(dots)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.green)
            
            ProgressView()
                .tint(.green)
                .scaleEffect(1.5)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            dots = dots.count < 3 ? dots + "." : ""
            
            if dots.isEmpty {
                currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.count
            }
        }
    }
}

struct PermissionView: View {
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 20) {
            TerminalText("> \(Localizable.text("access.denied", isEnglish: settings.isEnglish))")
            TerminalText("> \(Localizable.text("permission.required", isEnglish: settings.isEnglish))")
            TerminalText("")
            TerminalText(Localizable.text("permission.desc1", isEnglish: settings.isEnglish))
            TerminalText(Localizable.text("permission.desc2", isEnglish: settings.isEnglish))
            
            Button(Localizable.text("grant.access", isEnglish: settings.isEnglish)) {
                PhotoManager.shared.requestPhotoLibraryPermission()
            }
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    @ObservedObject var settings = AppSettings.shared
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            TerminalText("> \(Localizable.text("error.no.files", isEnglish: settings.isEnglish))")
            TerminalText("> \(Localizable.text("status.empty", isEnglish: settings.isEnglish))")
            
            TerminalButton(text: Localizable.text("retry", isEnglish: settings.isEnglish)) {
                onRetry()
            }
        }
        .padding()
    }
}

