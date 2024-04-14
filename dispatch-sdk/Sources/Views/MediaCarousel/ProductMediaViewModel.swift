import Foundation
import Combine

class ProductMediaViewModel: ObservableObject {
    @Published private(set) var images: [String]
    @Published private(set) var currentIndex: Int
    
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
        guard isNextButtonEnabled else {
            return
        }
        
        self.currentIndex += 1
    }
    
    func onPreviousButtonTapped() {
        guard isPreviousButtonEnabled else {
            return
        }
        
        self.currentIndex -= 1
    }
    
    func onCurrentIndexDidChange(_ index: Int) {
        self.currentIndex = index
    }
}

