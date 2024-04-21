import SwiftUI
import Combine

struct CheckoutSuccessView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutSuccessViewModel
    
    var body: some View {
        VStack {
            // TODO: How are we doing headers? UINavigationBar?
            if let imageUrlString = viewModel.checkout.product.baseImages.first, let url = URL(string: imageUrlString) {
                AsyncImage(url: url, content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    ProgressView()
                        .foregroundStyle(.primary)
                })
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Success!")
                        Text("Your order is on its way.")
                        Text("")
                    }
                    .padding(.horizontal)

                    CheckoutOverviewDetailRow(title: "Order Number", showChevron: false) {
                        Text(viewModel.orderNumber)
                    } handler: {}
                    Divider()
                    CheckoutOverviewDetailRow(title: "Shipping Address", showChevron: false) {
                        Text(viewModel.shippingAddress)
                    } handler: {}
                    Divider()
                    CheckoutOverviewDetailRow(title: "Payment", showChevron: false) {
                        Text(viewModel.payment)
                    } handler: {}
                    Divider()
                }
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    viewModel.onMainCtaButtonTapped()
                }) {
                    Text("Keep Shopping") // TODO: Where does this come from?
                }
                .buttonStyle(PrimaryButtonStyle())
                FooterView()
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let viewModel = CheckoutSuccessViewModel(
        checkout: .mock(),
        orderNumber: "C0192329328",
        shippingAddress: "1234 Town\nBrooklyn NY 11211",
        payment: "4242 [VISA]"
    )
    return CheckoutSuccessView(
        viewModel: viewModel
    )
}
