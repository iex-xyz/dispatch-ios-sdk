import SwiftUI

struct PaymentOptionsPickerView: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    
    let paymentMethods: [PaymentMethods]
    let onPaymentMethodSelected: (PaymentMethods) -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Payment Options")
                    .foregroundStyle(.primary)
                    .font(.title3.bold())
                Spacer()
                CloseButton {
                    dismiss()
                }
            }
            ScrollView {
                VStack {
                    Spacer()
                    if paymentMethods.contains(.applePay) {
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
                    }
                    
                    if paymentMethods.contains(.creditCard) {
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
        PaymentOptionsPickerView(paymentMethods: [.applePay, .creditCard]) { _ in
            
        }
//            .previewDevice("iPhone 12") // Specify the device here
    }
}
