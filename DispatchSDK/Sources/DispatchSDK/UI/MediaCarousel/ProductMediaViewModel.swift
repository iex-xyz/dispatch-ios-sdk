import Foundation
import Combine

class ProductMediaViewModel: ObservableObject {
    @Published var product: Product? {
        didSet {
            self.images = product?.baseImages ?? []
            self.currentIndex = 0
        }
    }
    @Published private(set) var images: [String]
    @Published var currentIndex: Int
    
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
    
    func onNextButtonTapped() {
        currentIndex = max(currentIndex + 1, images.count - 1)
    }
    
    func onPreviousButtonTapped() {
        currentIndex = max(currentIndex - 1, 0)
    }
    
    func onCurrentIndexDidChange(_ index: Int) {
        self.currentIndex = index
    }
}

