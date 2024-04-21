import SwiftUI

struct PaymentOptionsPickerView: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    
    let onPaymentMethodSelected: (PaymentType) -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Payment Options")
                    .foregroundStyle(.primary)
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Icons.close
                }
            }
            ScrollView {
                VStack {
                    Spacer()
                    Button(action: {
                        onPaymentMethodSelected(.applePay)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Pay")
                        }
                        .font(.headline.bold())
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(
                            foregroundColor: Color(UIColor.systemBackground),
                            backgroundColor: .primary
                        )
                    )
                    Button(action: {
                        onPaymentMethodSelected(.creditCard)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                            Text("Card")
                        }
                        .font(.headline.bold())
                    }
                    .buttonStyle(
                        PrimaryButtonStyle(
                            isLoading: false,
                            foregroundColor: .white,
                            backgroundColor: .blue
                        )
                    )

                }
            }
            VStack(spacing: 24) {
                FooterView()
            }
        }
        .padding()
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

struct PaymentOptionsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentOptionsPickerView { _ in
            
        }
//            .previewDevice("iPhone 12") // Specify the device here
    }
}
