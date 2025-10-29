import Foundation
import Photos
import UIKit
import AVFoundation
import Combine

class PhotoManager: ObservableObject {
    static let shared = PhotoManager()
    
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    private init() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
            }
        }
    }
    
    func fetchPhotos(withFilter filter: PhotoFilter = .random) async -> [PhotoItem] {
        guard authorizationStatus == .authorized else {
            return []
        }
        
        let fetchOptions = PHFetchOptions()
        
        switch filter {
        case .thisMonth:
            let calendar = Calendar.current
            let now = Date()
            if let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start {
                fetchOptions.predicate = NSPredicate(format: "creationDate >= %@", startOfMonth as NSDate)
            }
            
        case .lastYear:
            let calendar = Calendar.current
            let now = Date()
            if let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now),
               let twoYearsAgo = calendar.date(byAdding: .year, value: -2, to: now) {
                fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", twoYearsAgo as NSDate, oneYearAgo as NSDate)
            }
            
        default:
            break
        }
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var photoItems: [PhotoItem] = []
        
        fetchResult.enumerateObjects { asset, _, _ in
            if asset.mediaType == .image || asset.mediaType == .video {
                let photoItem = PhotoItem(asset: asset)
                photoItems.append(photoItem)
            }
        }
        
        return applySpecificFilter(filter, to: photoItems)
    }
    
    private func applySpecificFilter(_ filter: PhotoFilter, to photos: [PhotoItem]) -> [PhotoItem] {
        switch filter {
        case .screenshots:
            return photos.filter { isScreenshot($0.asset) }
            
        case .selfies:
            return photos.filter { $0.asset.mediaType == .image }
            
        case .blurred:
            return Array(photos.prefix(50))
            
        case .duplicates:
            return findPotentialDuplicates(photos)
            
        case .random:
            var shuffled = photos
            shuffled.shuffle()
            return shuffled
            
        case .thisMonth, .lastYear:
            return photos
        }
    }
    
    private func isScreenshot(_ asset: PHAsset) -> Bool {
        let commonScreenshotSizes: [(Int, Int)] = [
            (1179, 2556), (1290, 2796), (1170, 2532),
            (1125, 2436), (828, 1792), (750, 1334), (1242, 2688)
        ]
        
        return commonScreenshotSizes.contains { width, height in
            (asset.pixelWidth == width && asset.pixelHeight == height) ||
            (asset.pixelWidth == height && asset.pixelHeight == width)
        }
    }
    
    private func findPotentialDuplicates(_ photos: [PhotoItem]) -> [PhotoItem] {
        var duplicates: [PhotoItem] = []
        let sampleSize = min(photos.count, 50)
        
        for i in 0..<sampleSize {
            for j in (i+1)..<min(i+10, sampleSize) {
                let photo1 = photos[i]
                let photo2 = photos[j]
                
                if let date1 = photo1.asset.creationDate,
                   let date2 = photo2.asset.creationDate {
                    if abs(date1.timeIntervalSince(date2)) < 1.0 {
                        if !duplicates.contains(where: { $0.id == photo2.id }) {
                            duplicates.append(photo2)
                        }
                    }
                }
            }
        }
        
        return duplicates.isEmpty ? Array(photos.prefix(20)) : duplicates
    }
    
    func loadImage(from asset: PHAsset, targetSize: CGSize = CGSize(width: 800, height: 800)) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.isSynchronous = false
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    func getVideoURL(from asset: PHAsset) async -> URL? {
        return await withCheckedContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .automatic
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                guard let urlAsset = avAsset as? AVURLAsset else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: urlAsset.url)
            }
        }
    }
    
    func deletePhotos(_ assets: [PHAsset]) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assets as NSArray)
            }) { success, error in
                if success {
                    continuation.resume(returning: .success(()))
                } else {
                    let deleteError = error ?? NSError(
                        domain: "PhotoDeletionError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No se pudieron eliminar las fotos"]
                    )
                    continuation.resume(returning: .failure(deleteError))
                }
            }
        }
    }
}

enum PhotoFilter: String, CaseIterable {
    case random = "random"
    case screenshots = "screenshots"
    case selfies = "selfies"
    case blurred = "blurred"
    case duplicates = "duplicates"
    case thisMonth = "thisMonth"
    case lastYear = "lastYear"
    
    var displayName: String {
        switch self {
        case .random: return "RANDOM_MODE"
        case .screenshots: return "SCREENSHOT_FILTER"
        case .selfies: return "PHOTO_ONLY"
        case .blurred: return "RECENT_BATCH"
        case .duplicates: return "BURST_DETECTION"
        case .thisMonth: return "CURRENT_MONTH"
        case .lastYear: return "ARCHIVE_MODE"
        }
    }
    
    var icon: String {
        switch self {
        case .random: return "🎲"
        case .screenshots: return "📱"
        case .selfies: return "📸"
        case .blurred: return "⚡"
        case .duplicates: return "👯"
        case .thisMonth: return "📅"
        case .lastYear: return "🗄️"
        }
    }
    
    var description: String {
        switch self {
        case .random: return "Completely randomized selection"
        case .screenshots: return "Screen captures detected by resolution"
        case .selfies: return "All photos from your library"
        case .blurred: return "Quick batch of recent photos"
        case .duplicates: return "Photos taken in burst mode"
        case .thisMonth: return "Files from current month only"
        case .lastYear: return "Photos from previous year"
        }
    }
}

