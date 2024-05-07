import Foundation
import Combine

class ProductMediaViewModel: ObservableObject {
    
    struct Image: Identifiable {
        var id: String {
            url
        }
        let url: String
    }

    @Published var product: Product? {
        didSet {
            self.images = product?.baseImages ?? []
            self.currentIndex = 0
        }
    }
    @Published private(set) var images: [String]
    @Published var currentIndex: Int
    @Published var selectedImage: Image?
    
    var isPreviousButtonEnabled: Bool {
        return currentIndex > 0
    }

    var isNextButtonEnabled: Bool {
        return currentIndex < images.count - 1
    }

    
    init(images: [String], currentIndex: Int = 0) {
        self.images = images
        self.currentIndex = currentIndex
    }
    
    func onImageTapped(at index: Int) {
        self.selectedImage = .init(url: images[index])
    }
    
    func onNextButtonTapped() {
        currentIndex = (currentIndex + 1) % images.count
    }

    func onPreviousButtonTapped() {
        currentIndex = (currentIndex - 1 + images.count) % images.count
    }

    func onCurrentIndexDidChange(_ index: Int) {
        self.currentIndex = index
    }
}

