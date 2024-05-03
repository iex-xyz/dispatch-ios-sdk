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
            ZStack {
                if let domain = checkout.product.pdpDomain {
                    MerchantSecurityTag(domain: domain, tapHandler: {})
                }
                HStack {
                    Circle()
                        .fill()
                        .frame(width: 40, height: 40)
                    Spacer()
                    CloseButton {
                        dismiss()
                    }
                }
            }
            Text("Secure Checkout")
                .font(.title3.bold())
                .foregroundStyle(.primary)
            Text("\(checkout.merchantName) is selling across the web thanks to Dispatch. All orders will be handled by \(checkout.merchantName) who is responsible for:")
                .foregroundStyle(.primary)
                .font(.caption)
            
            VStack(spacing: 8) {
                ForEach(
                    [
                        "Storing your personal info for order fulfillment",
                        "Handling all disputes, returns or exchanges"
                    ],
                    id: \.self
                ) { term in
                    HStack {
                        Text("•")
                            .font(.headline)
                        Text("\(term)")
                            .font(.caption)
                        Spacer()
                    }
                    .foregroundStyle(.primary)
                }
            }

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
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Colors.secondaryBackgroundColor, lineWidth: 2))
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
        .background(theme.backgroundColor)
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
