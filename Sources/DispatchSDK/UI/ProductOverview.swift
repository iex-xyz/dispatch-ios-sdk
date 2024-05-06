import SwiftUI

import Combine
internal class ProductOverviewViewModel: ObservableObject {
    let product: Product

    let _onCloseButtonTapped = PassthroughSubject<Void, Never>()

    init(product: Product) {
        self.product = product
    }
    
    func onCloseButtonTapped() {
        _onCloseButtonTapped.send()
    }

}


struct ProductOverview: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ProductOverviewViewModel
    
    init(viewModel: ProductOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    let svg = """
    <svg width="23" height="8" viewBox="0 0 23 8" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M23 0L6.17976 7.11224C4.77935 7.70451 3.60126 8 2.6519 8C1.5837 8 0.805557 7.62426 0.32768 6.87406C-0.292027 5.90607 -0.0211445 4.34963 1.04194 2.70658C1.67315 1.74622 2.47557 0.864831 3.25755 0.0216529C3.07356 0.319695 1.44954 3.01353 3.22561 4.28212C3.57699 4.53686 4.07659 4.66168 4.69118 4.66168C5.18439 4.66168 5.75043 4.58144 6.37269 4.41968L23 0Z" fill="white"/>
    </svg>

    """
    var body: some View {
        VStack {
            HStack {
                CheckoutProductPreviewRow(product: viewModel.product)
                Spacer()
                CloseButton {
                    viewModel.onCloseButtonTapped()
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            if !viewModel.product.descriptionHtml.isEmpty {
                HTMLTextView(
                    htmlString: viewModel.product.descriptionHtml,
                    bulletSpacing: 0
                )
                .foregroundStyle(.primary)
                .padding()
            } else {
                ScrollView {
                    Text(viewModel.product.description)
                        .foregroundStyle(.primary)
                        .padding()
                }
            }
            Spacer()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let description = """
Apple Watch Band - AlphaPremier - Rainbow\n\nOne of our flagship collections, the AlphaPremier, has made its way to the Apple Watch world. These straps are made from the same soft, supple seatbelt weave as our AlphaPremier straps, which are a favorite among traditional watch wearers. The dual-layer straps are held in place with two nylon keepers, one of which can be slid into the perfect spot. It's the perfect solution for Apple Watch wearers who love our AlphaPremier straps.\n\nMaterial\nSeatbelt weave nylon\n\nSizing\n\nSmall: Fits 38mm or 40mm Apple Watch (22mm band width)\nLarge: Fits 42mm, 44mm, or 45mm Apple Watch (22mm band width)\n\nAdapter\n\nSilver, Space Gray\n\nColor\nRainbow\n\nLength\n120mm x 75mm
"""
    
    let descriptionHTML = """
<h1>Apple Watch Band - AlphaPremier - Rainbow<br />\n</h1>\n<p>One of our flagship collections, the AlphaPremier, has made its way to the Apple Watch world. These straps are made from the same soft, supple seatbelt weave as our AlphaPremier straps, which are a favorite among traditional watch wearers. The dual-layer straps are held in place with two nylon keepers, one of which can be slid into the perfect spot. It's the perfect solution for Apple Watch wearers who love our AlphaPremier straps.</p>\n<p> </p>\n\n<strong>Material﻿﻿</strong>\nSeatbelt weave nylon<br />\n\n<strong>Sizing</strong>\n<p>Small: Fits 38mm or 40mm Apple Watch (22mm band width)</p>\n<p>Large: Fits 42mm, 44mm, or 45mm Apple Watch (22mm band width)</p>\n\n<strong>Adapter</strong>\n<p>Silver, Space Gray</p>\n\n<strong>Color</strong>\nRainbow\n\n<strong>Length</strong>\n120mm x 75mm
"""
    
    let product: Product = .mock(
        description: description,
        descriptionHtml: descriptionHTML
    )
    return ProductOverview(
        viewModel: .init(product: product)
    )
}
