import SwiftUI
import Combine

@available(iOS 15.0, *)
class ProductOverviewViewModel: ObservableObject {
    let product: Product

    let _onCloseButtonTapped = PassthroughSubject<Void, Never>()

    init(product: Product) {
        self.product = product
    }
    
    func onCloseButtonTapped() {
        _onCloseButtonTapped.send()
    }

}

