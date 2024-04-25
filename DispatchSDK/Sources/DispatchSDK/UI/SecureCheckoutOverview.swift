import SwiftUI

struct SecureCheckoutOverview: View {
    @Preference(\.theme) var theme: Theme
    @Environment(\.dismiss) var dismiss
    
    let checkout: Checkout
    
    init(checkout: Checkout){
        self.checkout = checkout
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Circle()
                    .fill()
                    .frame(width: 40, height: 40)
                VStack {
                    Text("Secure Checkout")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Text(checkout.product.pdpUrl)
                        .foregroundStyle(Colors.secondaryText)
                        .font(.footnote)
                }
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                }
                .frame(width: 40, height: 40)
            }
            Text("Nike is selling across the web thanks to Dispatch. All orders will be handled by Nike who is responsible for:")
                .foregroundStyle(.primary)
                .font(.caption)
            
            VStack(spacing: 0) {
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Visit Merchant Website")
                        Spacer()
                        Image(systemName: "safari")
                    }
                    .padding(.horizontal)
                }
                .frame(height: 48)
                if checkout.merchantSupportUrl?.isEmpty == false {
                    Divider()
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Contact Merchant Support")
                            Spacer()
                            Image(systemName: "questionmark.circle")
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 48)
                }
                if !checkout.merchantTermsUrl.isEmpty {
                    Divider()
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("View Legal")
                            Spacer()
                            Image(systemName: "doc.text") // TODO: Different symbol icon in Figma
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 48)
                }
            }
            .font(.body)
            .background(theme.backgroundColor)
            .foregroundStyle(Color.dispatchBlue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Text("Keep Shopping")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .foregroundStyle(.primary)
        .padding()
        .background(Colors.secondaryBackgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

struct SecureCheckoutOverview_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            SecureCheckoutOverview(checkout: .mock())
        }
        .previewDevice("iPhone 12")
    }
}
