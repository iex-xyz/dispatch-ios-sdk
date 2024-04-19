import SwiftUI

struct SecureCheckoutOverview: View {
    @Preference(\.theme) var theme: Theme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Circle()
                    .fill()
                    .frame(width: 32, height: 32)
                Spacer()
                Icons.close
            }
            Text("Secure Checkout")
                .font(.title3.bold())
            Text("Nike is selling across the web thanks to Dispatch. All orders will be handled by Nike who is responsible for:")
            
            Button(action: {
                theme = theme.mode == .dark ? .mock(mode: .light) : .mock(mode: .dark)
                
            }) {
                Text("Need help with your order? Contact Nike Support ") + Text(Image(systemName: "arrow.right"))
            }
            .buttonStyle(
                SecondaryButtonStyle()
            )
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Text("Keep Shopping")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .background(Color(uiColor: UIColor.systemBackground))
        .colorScheme(theme.colorScheme)
    }
}

struct SecureCheckoutOverview_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SecureCheckoutOverview()
            SecureCheckoutOverview()
        }
        .previewDevice("iPhone 12")
    }
}
