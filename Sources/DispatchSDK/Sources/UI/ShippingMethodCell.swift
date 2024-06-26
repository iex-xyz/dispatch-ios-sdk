import SwiftUI

@available(iOS 15.0, *)
struct ShippingMethodCell: View {
    @Preference(\.theme) var theme

    let shippingMethod: ShippingMethod

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(shippingMethod.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let estimatedETA = shippingMethod.getEstimatedArrivalDateText() {
                    Text(estimatedETA)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }
            Spacer()
            Text(CurrencyHelpers.formatCentsToDollars(cents: shippingMethod.price))
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
        }
        .padding()
        .background(Colors.controlBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Colors.borderGray)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 4)
        )
    }
    
    struct SkeletonView: View {
        var body: some View {
            HStack {
                VStack {
                    Text("#############")
                        .redacted(reason: .placeholder)
                        .font(.headline)
                    Text("#############")
                        .redacted(reason: .placeholder)
                        .font(.subheadline.bold())
                }
                Spacer()
                Text("########")
                    .redacted(reason: .placeholder)
                    .font(.subheadline.bold())
            }
            .padding()
            .background(.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(hex: "#E8E8E8"))
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
            )
        }
    }
}

@available(iOS 15.0, *)
struct ShippingMethodCell_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ShippingMethodCell(
                shippingMethod: ShippingMethod.random(
                    handle: "Delivery within 4 to 6 business days.",
                    title: "Ground Shipping"
                )
            )
            .environment(\.theme, .sharp)
            ShippingMethodCell(
                shippingMethod: ShippingMethod.random(
                    handle: "Delivery within 2 business days.",
                    title: "Express 2nd Day"
                )
            )
            .environment(\.theme, .sharp)

        }
        .padding()
        .previewDevice("iPhone 12") // Specify the device here
    }
}
