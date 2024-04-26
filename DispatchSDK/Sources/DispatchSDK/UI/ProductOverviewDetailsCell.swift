import SwiftUI

internal struct ProductOverviewDetailsCell: View {
    @Preference(\.theme) var theme
    private static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    let product: Product
    let basePrice: Int
    let baseComparePrice: Int?

    init(product: Product, basePrice: Int, baseComparePrice: Int? = nil) {
        self.product = product
        Self.priceFormatter.currencyCode = product.currencyCode
        self.basePrice = basePrice
        self.baseComparePrice = baseComparePrice
    }
    
    func formattedPrice(_ price: Int) -> String {
        Self.priceFormatter.currencyCode = product.currencyCode
        let priceValue: NSNumber = .init(floatLiteral: Double(price) / 100)
        return Self.priceFormatter.string(from: priceValue) ?? "--"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text(product.name)
                    .foregroundStyle(.primary)
                    .font(.title3.bold())
                if let baseComparePrice {
                    PriceLabel(basePrice: formattedPrice(baseComparePrice), currentPrice: formattedPrice(basePrice))
                } else {
                    PriceLabel(basePrice: formattedPrice(basePrice), currentPrice: nil)
                }
            }

            Text(product.description)
//            
//            Button(action: {
//                
//            }) {
//                HStack {
//                    Text("Shop on Nike.com")
//                    Image(systemName: "arrow.right")
//                    Spacer()
//                }
//                .font(.footnote.bold())
//            }
//            .buttonStyle(SecondaryButtonStyle())
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
            baseComparePrice: 3200
        )
        //            VariantPreviewButton(theme: theme, title: "Select Color", selectedValue: "M 9 / W 10.5")
        //            VariantPreviewButton(theme: theme, title: "Select Size", selectedValue: "M 9 / W 10.5")
    }
    .padding()
    .preferredColorScheme(.dark)
    .previewDevice("iPhone 12") // Specify the device here
}

