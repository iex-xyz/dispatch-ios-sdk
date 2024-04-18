import SwiftUI

struct PriceLabel: View {
    let basePrice: String
    let currentPrice: String?
    let theme: Theme
    
    var body: some View {
        HStack {
            if let currentPrice {
                Text(currentPrice)
                    .foregroundStyle(Color.dispatchGreen)
                Text(basePrice)
                    .strikethrough(true, color: Color.dispatchLightGray)
                    .foregroundStyle(Color.dispatchLightGray)
            } else {
                Text(basePrice)
                    .foregroundStyle(.primary)

            }
        }
        .font(.headline)
    }
}

#Preview {
    HStack(spacing: 32) {
        VStack(alignment: .leading) {
            PriceLabel(basePrice: "$76.97", currentPrice: nil, theme: .default)
            PriceLabel(basePrice: "$85.00", currentPrice: "$76.97", theme: .default)
        }
        VStack(alignment: .leading) {
            PriceLabel(basePrice: "$76.97", currentPrice: nil, theme: .mock(mode: .dark))
            PriceLabel(basePrice: "$85.00", currentPrice: "$76.97", theme: .mock(mode: .dark))
        }
    }
    .frame(width: 300, height: 200)
    .background(Color.dispatchDarkGray)
}
