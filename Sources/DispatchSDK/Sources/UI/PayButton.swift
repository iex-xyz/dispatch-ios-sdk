import SwiftUI
import PassKit

struct ApplePayButton: UIViewRepresentable {
    @Preference(\.theme) var theme
    let paymentButtonType: PKPaymentButtonType
    let isDisabled: Bool
    let action: () -> Void
    
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(
            paymentButtonType: paymentButtonType,
            paymentButtonStyle: .automatic
        )
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)

        button.cornerRadius = theme.cornerRadius
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
        uiView.isEnabled = !isDisabled
        uiView.cornerRadius = theme.cornerRadius
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }

}

struct PayButton: View {
    @Preference(\.theme) var theme
    let productType: ProductType
    let paymentMethod: PaymentMethods
    var isDisabled: Bool
    var isLoading: Bool
    let onButtonTapped: () -> Void

    var body: some View {
        switch paymentMethod {
        case .applePay:
            ApplePayButton(
                paymentButtonType: productType == .donation ? .donate : .buy,
                isDisabled: isDisabled
            ) {
                onButtonTapped()
            }
            .frame(height: 44)
        case .creditCard:
            Button(action: {
                onButtonTapped()
            }) {
                HStack(spacing: 4) {
                    Text(productType.renderedCTAString)
                        .lineLimit(1)
                    switch (paymentMethod, theme.mode) {
                    case (.applePay, .light):
                        Icons.Payment.applePayLight
                    case (.applePay, .dark):
                        Icons.Payment.applePayLight
                    case (.creditCard, .light):
                        Icons.Payment.cardDark
                    case (.creditCard, .dark):
                        Icons.Payment.cardDark
                    case (.googlePay, .light):
                        Icons.Payment.googlePayLight
                    case (.googlePay, .dark):
                        Icons.Payment.googlePayDark
                    case (.stripeLink, .light):
                        Icons.Payment.cardDark
                    case (.stripeLink, .dark):
                        Icons.Payment.cardDark
                    }
                }
                .opacity(isDisabled ? 0.24 : 1)
            }
            .disabled(isDisabled)
            .buttonStyle(
                PrimaryButtonStyle(isLoading: isLoading)
            )
        case .googlePay, .stripeLink:
            EmptyView()
        }
        
        
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach([ProductType.donation, ProductType.product], id: \.self) { productType in
                    VStack {
                        PayButton(productType: productType, paymentMethod: .applePay, isDisabled: true, isLoading: true) {}
                        PayButton(productType: productType, paymentMethod: .googlePay, isDisabled: false, isLoading: false) {}
                        PayButton(productType: productType, paymentMethod: .creditCard, isDisabled: true, isLoading: false) {}
                        PayButton(productType: productType, paymentMethod: .stripeLink, isDisabled: false, isLoading: false) {}
                    }
                    
                    VStack {
                        PayButton(productType: productType, paymentMethod: .applePay, isDisabled: true, isLoading: true) {}
                        PayButton(productType: productType, paymentMethod: .googlePay, isDisabled: true, isLoading: true) {}
                        PayButton(productType: productType, paymentMethod: .creditCard, isDisabled: false, isLoading: false) {}
                        PayButton(productType: productType, paymentMethod: .stripeLink, isDisabled: false, isLoading: false) {}
                    }
                    .environment(\.theme, .mock(mode: .dark))
            }
        }
        .padding(.horizontal)
    }
    .background(Color.dispatchDarkGray)
}
