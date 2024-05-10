import SwiftUI
import Combine

struct ProductOverview: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ProductOverviewViewModel
    
    init(viewModel: ProductOverviewViewModel) {
        self.viewModel = viewModel
    }
    
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
