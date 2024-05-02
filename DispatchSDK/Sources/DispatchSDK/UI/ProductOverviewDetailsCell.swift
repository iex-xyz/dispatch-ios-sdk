import SwiftUI

internal struct ProductOverviewDetailsCell: View {
    @Preference(\.theme) var theme

    let product: Product
    let basePrice: Int
    let baseComparePrice: Int?
    let expandHandler: () -> Void

    init(
        product: Product,
        basePrice: Int,
        baseComparePrice: Int? = nil,
        expandHandler: @escaping () -> Void
    ) {
        self.product = product
        self.basePrice = basePrice
        self.baseComparePrice = baseComparePrice
        self.expandHandler = expandHandler
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text(product.name)
                    .foregroundStyle(.primary)
                    .font(.title3.bold())
                if let baseComparePrice {
                    PriceLabel(
                        basePrice: CurrencyHelpers.formatCentsToDollars(
                            cents: baseComparePrice,
                            currencyCode: product.currencyCode
                        ),
                        currentPrice: CurrencyHelpers.formatCentsToDollars(
                            cents: basePrice,
                            currencyCode: product.currencyCode
                        )
                    )
                } else {
                    PriceLabel(
                        basePrice: CurrencyHelpers.formatCentsToDollars(
                            cents: basePrice,
                            currencyCode: product.currencyCode
                        ),
                        currentPrice: nil
                    )
                }
            }

            ExpandableText(
                text: product.description,
                expandHandler: expandHandler
            )
        }
        .colorScheme(theme.colorScheme)
    }
}



#Preview {
    let product: Product = .mock()
    let theme: Theme = .sharp
    @State var text: String = ""
    return VStack(spacing: 24) {
        ProductOverviewDetailsCell(
            product: product,
            basePrice: 1600,
            baseComparePrice: 3200,
            expandHandler: {}
        )
        //            VariantPreviewButton(theme: theme, title: "Select Color", selectedValue: "M 9 / W 10.5")
        //            VariantPreviewButton(theme: theme, title: "Select Size", selectedValue: "M 9 / W 10.5")
    }
    .padding()
    .preferredColorScheme(.dark)
    .previewDevice("iPhone 12") // Specify the device here
}

