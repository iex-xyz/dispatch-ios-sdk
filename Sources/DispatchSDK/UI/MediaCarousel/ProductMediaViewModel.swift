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
    @Published var currentIndex: Int {
        didSet {
            guard oldValue != currentIndex else { return }
            let direction = calculateIndexChangeDirection(oldIndex: oldValue, newIndex: currentIndex)
            analyticsClient.send(event:.carouselSwipe_Checkout(direction: direction, imageIndex: currentIndex))
        }
    }
    @Published var selectedImage: Image?
    
    private let analyticsClient: AnalyticsClient

    var isPreviousButtonEnabled: Bool {
        return currentIndex > 0
    }

    var isNextButtonEnabled: Bool {
        return currentIndex < images.count - 1
    }
    
    init(images: [String], currentIndex: Int = 0, analyticsClient: AnalyticsClient) {
        self.images = images
        self.currentIndex = currentIndex
        self.analyticsClient = analyticsClient
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
    
    // Returns 'prev' or 'next' based on if the carousel went left or right
    private func calculateIndexChangeDirection(oldIndex: Int, newIndex: Int) -> String {
        if oldIndex == images.count - 1 && newIndex == 0 {
            return "next"
        } else if oldIndex == 0 && newIndex == images.count - 1 {
            return "prev"
        } else {
            return newIndex > oldIndex ? "next" : "prev"
        }
    }
}

