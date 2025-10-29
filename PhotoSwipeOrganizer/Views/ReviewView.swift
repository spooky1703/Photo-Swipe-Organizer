import SwiftUI

struct ReviewView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 0) {
            TerminalHeader()
            
            if viewModel.deletionComplete {
                SuccessView(viewModel: viewModel)
            } else if viewModel.photosMarkedForDeletion.isEmpty {
                EmptyDeletionView(viewModel: viewModel)
            } else {
                DeletionListView(viewModel: viewModel)
            }
        }
        .background(Color.black)
    }
}

struct DeletionListView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("> \(Localizable.text("review.title", isEnglish: settings.isEnglish))")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                
                Text("\(viewModel.photosMarkedForDeletion.count) \(Localizable.text("review.marked", isEnglish: settings.isEnglish))")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(white: 0.1))
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.photosMarkedForDeletion) { photo in
                        PhotoReviewCard(photo: photo) {
                            viewModel.removePhotoFromDeletionList(photo)
                        }
                    }
                }
                .padding()
            }
            
            VStack(spacing: 12) {
                if viewModel.isDeletingPhotos {
                    HStack(spacing: 12) {
                        ProgressView()
                            .tint(.green)
                        Text(Localizable.text("review.deleting", isEnglish: settings.isEnglish))
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.green)
                    }
                    .padding()
                } else {
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.resetSession()
                        }) {
                            Text(Localizable.text("review.cancel", isEnglish: settings.isEnglish))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(white: 0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.confirmDeletion()
                            }
                        }) {
                            Text(Localizable.text("review.confirm", isEnglish: settings.isEnglish))
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            .background(Color(white: 0.05))
        }
    }
}

struct PhotoReviewCard: View {
    let photo: PhotoItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if photo.isVideo {
                    HStack(spacing: 4) {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.green)
                        Text(photo.videoDuration ?? "")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

struct SuccessView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text(Localizable.text("review.great", isEnglish: settings.isEnglish))
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                
                Text(Localizable.text("review.success", isEnglish: settings.isEnglish))
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.green.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                viewModel.resetSession()
            }) {
                Text("> \(Localizable.text("review.new", isEnglish: settings.isEnglish))")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct EmptyDeletionView: View {
    @ObservedObject var viewModel: PhotoViewModel
    @ObservedObject var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text(Localizable.text("review.great", isEnglish: settings.isEnglish))
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                
                Text(Localizable.text("review.safe", isEnglish: settings.isEnglish))
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.green.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                viewModel.resetSession()
            }) {
                Text("> \(Localizable.text("review.new", isEnglish: settings.isEnglish))")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

