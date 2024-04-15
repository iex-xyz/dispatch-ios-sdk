import SwiftUI

struct ShippingMethodCell: View {

    let shippingMethod: ShippingMethod
    let theme: Theme

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(shippingMethod.title)
                    .font(.headline)
                Text(shippingMethod.handle)
                    .font(.subheadline)
            }
            Spacer()
            Text("$\(shippingMethod.price)")
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




struct ShippingMethodCell_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ShippingMethodCell(
                shippingMethod: ShippingMethod.random(
                    handle: "Delivery within 4 to 6 business days.",
                    title: "Ground Shipping"
                ),
                theme: Theme.sharp
            )
            ShippingMethodCell(
                shippingMethod: ShippingMethod.random(
                    handle: "Delivery within 2 business days.",
                    title: "Express 2nd Day"
                ),
                theme: Theme.sharp
            )

        }
        .padding()
        .preferredColorScheme(.dark)
            .previewDevice("iPhone 12") // Specify the device here
    }
}
