import SwiftUI

struct PriceLabel: View {
    @Preference(\.theme) var theme
    
    let basePrice: String
    let currentPrice: String?
    
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
            Spacer()
        }
        .font(.headline)
    }
}

#Preview {
    HStack(spacing: 32) {
        VStack(alignment: .leading) {
            PriceLabel(basePrice: "$76.97", currentPrice: nil)
            PriceLabel(basePrice: "$85.00", currentPrice: "$76.97")
        }
        VStack(alignment: .leading) {
            PriceLabel(basePrice: "$76.97", currentPrice: nil)
                .environment(\.theme, .mock(mode: .light))
            PriceLabel(basePrice: "$85.00", currentPrice: "$76.97")
                .environment(\.theme, .mock(mode: .dark))
        }
    }
    .frame(width: 300, height: 200)
    .background(Color.dispatchDarkGray)
}
