import SwiftUI

internal struct ProductOverviewDetailsCell: View {
    private static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    let product: Product
    
    init(product: Product) {
        self.product = product
        Self.priceFormatter.currencyCode = product.currencyCode
    }
    
    func formattedPrice() -> String {
        Self.priceFormatter.currencyCode = product.currencyCode
        let priceValue: NSNumber = .init(floatLiteral: Double(product.basePrice) / 100)
        return Self.priceFormatter.string(from: priceValue) ?? "--"
    }

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
                Text(formattedPrice())
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Text(product.description)
            
            Button(action: {
                
            }) {
                HStack {
                    Text("Shop on Nike.com")
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .font(.footnote.bold())
            }
            .buttonStyle(SecondaryButtonStyle(theme: Theme.sharp))
        }
    }
}



struct ThemeButtonStyle_Preview: PreviewProvider {
    static let product: Product = .mock()
    static let theme: Theme = .sharp
    static var previews: some View {
        @State var text: String = ""
        VStack(spacing: 24) {
            ProductOverviewDetailsCell(product: product)
//            VariantPreviewButton(theme: theme, title: "Select Color", selectedValue: "M 9 / W 10.5")
//            VariantPreviewButton(theme: theme, title: "Select Size", selectedValue: "M 9 / W 10.5")
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 12") // Specify the device here
    }
}

