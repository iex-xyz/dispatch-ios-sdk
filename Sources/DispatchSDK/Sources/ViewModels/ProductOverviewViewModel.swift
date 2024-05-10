import SwiftUI
import Combine

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

