import SwiftUI

struct SecureCheckoutOverview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
            }
            Text("Secure Checkout")
                .font(.title3.bold())
            Text("Nike is selling across the web thanks to Dispatch. All orders will be handled by Nike who is responsible for:")
            
            Button(action: {}) {
                Text("Need help with your order? Contact Nike Support ") + Text(Image(systemName: "arrow.right"))
            }
            .buttonStyle(
                SecondaryButtonStyle()
            )
        }
        .padding()
    }
}

struct SecureCheckoutOverview_Previews: PreviewProvider {
    static var previews: some View {
        SecureCheckoutOverview()
        .previewDevice("iPhone 12")
    }
}
