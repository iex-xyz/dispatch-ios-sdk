import SwiftUI

internal struct ProductOverviewDetailsCell: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("3,662 viewed in the last 7 days")
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.orange)
                Text(product.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text("$150")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Text("On the trail, details matter. Fast, rugged and ready for whatever wild comes your")
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Shop on Nike.com")
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .font(.footnote.bold())
            }
            .buttonStyle(SecondaryButtonStyle(theme: Theme()))
        }
    }
}



struct ThemeButtonStyle_Preview: PreviewProvider {
    static let product: Product = .init(
        attributes: nil,
        baseCompareAtPrice: nil,
        baseImages: [],
        basePrice: 150.0,
        baseQuantity: 10,
        baseStrikethroughPrice: nil,
        currencyCode: .usd,
        description: "On the trail, details matter. Fast, rugged and ready for whatever wild comes your",
        descriptionHtml: "On the trail, details matter. Fast, rugged and ready for whatever wild comes your",
        hideCoverTransactionCosts: nil,
        id: UUID().uuidString,
        merchantId: nil,
        name: "Nike ACG Mountain Fly 2 Low",
        pdpUrl: nil,
        priceSubtitleText: nil,
        productLanguage: nil,
        requiresBilling: nil,
        requiresShipping: nil,
        salesEnabled: true,
        type: .product,
        variations: nil
    )
    static let theme: Theme = .init()
    static var previews: some View {
        @State var text: String = ""
        VStack(spacing: 24) {
            ProductOverviewDetailsCell(product: product)
            VariantPreviewButton(theme: theme, title: "Select Color")
            VariantPreviewButton(theme: theme, title: "Select Size")
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 12") // Specify the device here
    }
}

