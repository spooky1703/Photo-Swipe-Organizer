import SwiftUI
import AVKit

struct SwipeView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    @State private var dragOffset: CGSize = .zero
    @State private var isLongPressing = false
    @GestureState private var isDetectingLongPress = false
    
    var body: some View {
        VStack(spacing: 0) {
            TerminalHeader()
            
            ZStack {
                Color.black
                
                if let photo = viewModel.currentPhoto {
                    VStack(spacing: 16) {
                        Text("> \(Localizable.text("photo", isEnglish: settings.isEnglish)) \(viewModel.currentPhotoIndex + 1) \(Localizable.text("of", isEnglish: settings.isEnglish)) \(viewModel.photos.count)")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.green)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        ZStack {
                            // Imagen o video
                            if photo.isVideo {
                                VideoPlayerView(photo: photo)
                            } else if let image = photo.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: isLongPressing ? .fit : .fill)
                                    .frame(maxWidth: .infinity, maxHeight: isLongPressing ? .infinity : 500)
                                    .clipped()
                                    .cornerRadius(12)
                            } else {
                                ProgressView()
                                    .tint(.green)
                                    .scaleEffect(2)
                            }
                            
                            // Overlay de color cuando se arrastra
                            if abs(dragOffset.width) > 20 {
                                Rectangle()
                                    .fill(dragOffset.width > 0 ? Color.red.opacity(0.3) : Color.green.opacity(0.3))
                                    .cornerRadius(12)
                                    .overlay(
                                        VStack {
                                            if dragOffset.width > 0 {
                                                // DELETE - Rojo a la derecha
                                                HStack {
                                                    Spacer()
                                                    VStack(spacing: 8) {
                                                        Image(systemName: "trash.fill")
                                                            .font(.system(size: 48))
                                                        Text("DELETE")
                                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                                    }
                                                    .foregroundColor(.red)
                                                    .padding(.trailing, 40)
                                                }
                                            } else {
                                                // KEEP - Verde a la izquierda
                                                HStack {
                                                    VStack(spacing: 8) {
                                                        Image(systemName: "hand.thumbsup.fill")
                                                            .font(.system(size: 48))
                                                        Text("KEEP")
                                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                                    }
                                                    .foregroundColor(.green)
                                                    .padding(.leading, 40)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    )
                                    .opacity(min(Double(abs(dragOffset.width)) / 150.0, 0.8))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isLongPressing ? nil : 500)
                        .offset(x: dragOffset.width, y: dragOffset.height * 0.3)
                        .rotationEffect(.degrees(Double(dragOffset.width) / 20))
                        .opacity(1 - Double(abs(dragOffset.width)) / 500)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = gesture.translation
                                }
                                .onEnded { gesture in
                                    if abs(gesture.translation.width) > 100 {
                                        if gesture.translation.width > 0 {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                dragOffset.width = 1000
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                viewModel.swipeRight()
                                                dragOffset = .zero
                                            }
                                        } else {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                dragOffset.width = -1000
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                viewModel.swipeLeft()
                                                dragOffset = .zero
                                            }
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .updating($isDetectingLongPress) { currentState, gestureState, _ in
                                    gestureState = currentState
                                }
                                .onChanged { _ in
                                    isLongPressing = true
                                }
                                .onEnded { _ in
                                    isLongPressing = false
                                }
                        )
                        
                        if !isLongPressing {
                            Text(Localizable.text("hold.view", isEnglish: settings.isEnglish))
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.green.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 40) {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    dragOffset.width = -1000
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.swipeLeft()
                                    dragOffset = .zero
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .font(.system(size: 32))
                                    Text(Localizable.text("keep", isEnglish: settings.isEnglish))
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(.green)
                                .frame(width: 120)
                                .padding(.vertical, 20)
                                .background(Color(white: 0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                            }
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    dragOffset.width = 1000
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.swipeRight()
                                    dragOffset = .zero
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 32))
                                    Text(Localizable.text("delete", isEnglish: settings.isEnglish))
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(.red)
                                .frame(width: 120)
                                .padding(.vertical, 20)
                                .background(Color(white: 0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

struct VideoPlayerView: View {
    let photo: PhotoItem
    @State private var videoURL: URL?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if let url = videoURL {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(maxWidth: .infinity)
                    .frame(height: 500)
                    .cornerRadius(12)
            } else if isLoading {
                ProgressView()
                    .tint(.green)
                    .scaleEffect(2)
            }
            
            if let duration = photo.videoDuration {
                VStack {
                    HStack {
                        Spacer()
                        Text(duration)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(6)
                            .padding(8)
                    }
                    Spacer()
                }
            }
        }
        .task {
            videoURL = await PhotoManager.shared.getVideoURL(from: photo.asset)
            isLoading = false
        }
    }
}

