import Foundation
import Photos
import UIKit

struct PhotoItem: Identifiable, Equatable, Hashable {
    let id = UUID()
    let asset: PHAsset
    var image: UIImage?
    var isMarkedForDeletion: Bool = false
    
    var isVideo: Bool {
        return asset.mediaType == .video
    }
    
    var videoDuration: String? {
        guard isVideo else { return nil }
        let duration = Int(asset.duration)
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    static func == (lhs: PhotoItem, rhs: PhotoItem) -> Bool {
        return lhs.asset.localIdentifier == rhs.asset.localIdentifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(asset.localIdentifier)
    }
}

