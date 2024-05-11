import SwiftUI

@available(iOS 15.0, *)
struct ProductOverviewDetailsCell: View {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    .frame(maxWidth: .infinity)
                } else {
                    PriceLabel(
                        basePrice: CurrencyHelpers.formatCentsToDollars(
                            cents: basePrice,
                            currencyCode: product.currencyCode
                        ),
                        currentPrice: nil
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)

            ExpandableText(
                text: product.description,
                expandHandler: expandHandler
            )
        }
        .colorScheme(theme.colorScheme)
        .frame(maxWidth: .infinity)
    }
}


@available(iOS 15.0, *)
#Preview {
    let product: Product = .mock()
    @State var text: String = ""
    return VStack(spacing: 24) {
        ProductOverviewDetailsCell(
            product: product,
            basePrice: 1600,
            baseComparePrice: 3200,
            expandHandler: {}
        )
    }
    .padding()
}

