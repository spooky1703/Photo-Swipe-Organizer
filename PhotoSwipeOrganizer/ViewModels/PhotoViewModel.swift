import SwiftUI
import Photos
import Combine

@MainActor
class PhotoViewModel: ObservableObject {
    @Published var photos: [PhotoItem] = []
    @Published var allPhotos: [PhotoItem] = []
    @Published var currentPhotoIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var showReviewScreen: Bool = false
    @Published var isDeletingPhotos: Bool = false
    @Published var errorMessage: String?
    @Published var deletionComplete: Bool = false
    @Published var numberOfPhotosToReview: Int = 20
    @Published var showPhotoCountSelector: Bool = true
    @Published var selectedFilter: PhotoFilter = .random
    
    private let photoManager = PhotoManager.shared
    private var imageLoadingTasks: [Int: Task<Void, Never>] = [:]
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    var currentPhoto: PhotoItem? {
        guard currentPhotoIndex < photos.count else { return nil }
        return photos[currentPhotoIndex]
    }
    
    var hasMorePhotos: Bool {
        currentPhotoIndex < photos.count
    }
    
    var photosMarkedForDeletion: [PhotoItem] {
        photos.filter { $0.isMarkedForDeletion }
    }
    
    var totalPhotosAvailable: Int {
        allPhotos.count
    }
    
    init() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
    }
    
    func loadAllPhotos(withFilter filter: PhotoFilter = .random) async {
        isLoading = true
        errorMessage = nil
        selectedFilter = filter
        
        let fetchedPhotos = await photoManager.fetchPhotos(withFilter: filter)
        allPhotos = fetchedPhotos
        
        isLoading = false
    }
    
    func startReviewSession(withPhotoCount count: Int) async {
        showPhotoCountSelector = false
        isLoading = true
        
        let photosToReview = Array(allPhotos.prefix(count))
        
        var photosWithImages: [PhotoItem] = []
        
        for (index, photo) in photosToReview.enumerated() {
            var photoItem = photo
            
            if index < 10 {
                photoItem.image = await photoManager.loadImage(from: photo.asset)
            }
            
            photosWithImages.append(photoItem)
        }
        
        photos = photosWithImages
        currentPhotoIndex = 0
        isLoading = false
        
        notificationFeedback.notificationOccurred(.success)
        
        preloadNextImages()
    }
    
    private func preloadNextImages() {
        let startIndex = currentPhotoIndex + 1
        let endIndex = min(startIndex + 10, photos.count)
        
        // FIX: Verificar que startIndex sea menor que endIndex
        guard startIndex < endIndex else { return }
        
        for index in startIndex..<endIndex {
            guard photos[index].image == nil else { continue }
            
            imageLoadingTasks[index]?.cancel()
            
            let task = Task {
                let asset = photos[index].asset
                if let image = await photoManager.loadImage(from: asset) {
                    if !Task.isCancelled && index < photos.count {
                        photos[index].image = image
                    }
                }
            }
            
            imageLoadingTasks[index] = task
        }
    }
    
    func swipeRight() {
        impactHeavy.impactOccurred()
        markCurrentPhotoForDeletion(true)
        moveToNextPhoto()
    }
    
    func swipeLeft() {
        impactLight.impactOccurred()
        markCurrentPhotoForDeletion(false)
        moveToNextPhoto()
    }
    
    private func markCurrentPhotoForDeletion(_ shouldDelete: Bool) {
        guard currentPhotoIndex < photos.count else { return }
        photos[currentPhotoIndex].isMarkedForDeletion = shouldDelete
    }
    
    private func moveToNextPhoto() {
        currentPhotoIndex += 1
        
        if currentPhotoIndex >= photos.count {
            notificationFeedback.notificationOccurred(.success)
            showReviewScreen = true
            return
        }
        
        impactLight.impactOccurred(intensity: 0.5)
        
        loadCurrentPhotoImageIfNeeded()
        preloadNextImages()
    }
    
    private func loadCurrentPhotoImageIfNeeded() {
        guard let currentPhoto = currentPhoto,
              currentPhoto.image == nil else { return }
        
        Task {
            let image = await photoManager.loadImage(from: currentPhoto.asset)
            if let index = photos.firstIndex(where: { $0.id == currentPhoto.id }) {
                photos[index].image = image
            }
        }
    }
    
    func removePhotoFromDeletionList(_ photo: PhotoItem) {
        impactMedium.impactOccurred()
        
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index].isMarkedForDeletion = false
        }
    }
    
    func confirmDeletion() async {
        isDeletingPhotos = true
        errorMessage = nil
        
        let assetsToDelete = photosMarkedForDeletion.map { $0.asset }
        
        guard !assetsToDelete.isEmpty else {
            isDeletingPhotos = false
            return
        }
        
        impactMedium.impactOccurred()
        
        let result = await photoManager.deletePhotos(assetsToDelete)
        
        switch result {
        case .success:
            // FIX: Eliminar de la lista actual
            photos.removeAll { $0.isMarkedForDeletion }
            
            // FIX: CRÍTICO - Eliminar de allPhotos para que no vuelvan a aparecer
            let deletedAssetIdentifiers = Set(assetsToDelete.map { $0.localIdentifier })
            allPhotos.removeAll { photo in
                deletedAssetIdentifiers.contains(photo.asset.localIdentifier)
            }
            
            deletionComplete = true
            notificationFeedback.notificationOccurred(.success)
            
        case .failure(let error):
            errorMessage = "Error al eliminar fotos: \(error.localizedDescription)"
            notificationFeedback.notificationOccurred(.error)
        }
        
        isDeletingPhotos = false
    }

    
    func resetSession() {
        imageLoadingTasks.values.forEach { $0.cancel() }
        imageLoadingTasks.removeAll()
        
        currentPhotoIndex = 0
        showReviewScreen = false
        deletionComplete = false
        showPhotoCountSelector = true
        photos.removeAll()
        errorMessage = nil
        
        // FIX: Volver a barajar si era modo random
        if selectedFilter == .random {
            allPhotos.shuffle()
        }
        
        impactLight.impactOccurred()
    }
    
    deinit {
        imageLoadingTasks.values.forEach { $0.cancel() }
    }
}

