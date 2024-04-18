import SwiftUI

struct PayButton: View {
    @Environment(\.theme) var theme
    let ctaText: String
    let paymentType: PaymentType
    @State var isDisabled: Bool = false
    var body: some View {
        Button(action: {
            
        }) {
            HStack(spacing: 4) {
                Text(ctaText)
                    .lineLimit(1)
                switch (paymentType, theme.mode) {
                case (.applePay, .light):
                    Icons.Payment.applePayLight
                case (.applePay, .dark):
                    Icons.Payment.applePayDark
                case (.creditCard, .light):
                    Icons.Payment.cardLight
                case (.creditCard, .dark):
                    Icons.Payment.cardDark
                case (.googlePay, .light):
                    Icons.Payment.googlePayLight
                case (.googlePay, .dark):
                    Icons.Payment.googlePayDark
                case (.paypal, .light):
                    Icons.Payment.cardLight
                case (.paypal, .dark):
                    Icons.Payment.cardDark
                }
            }
            .opacity(isDisabled ? 0.24 : 1)
        }
        .buttonStyle(
            PrimaryButtonStyle(
                isLoading: false,
                foregroundColor: .primary,
                backgroundColor: Color(UIColor.systemBackground)
            )
        )
        
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach(["Pay with", "Continue with", "Donate with"], id: \.self) { cta in
                    VStack {
                        PayButton(ctaText: cta, paymentType: .applePay, isDisabled: true)
                        PayButton(ctaText: cta, paymentType: .googlePay)
                        PayButton(ctaText: cta, paymentType: .creditCard, isDisabled: true)
                        PayButton(ctaText: cta, paymentType: .paypal)
                    }
                    
                    VStack {
                        PayButton(ctaText: cta, paymentType: .applePay, isDisabled: true)
                        PayButton(ctaText: cta, paymentType: .googlePay, isDisabled: true)
                        PayButton(ctaText: cta, paymentType: .creditCard)
                        PayButton(ctaText: cta, paymentType: .paypal)
                    }
                    .environment(\.theme, .mock(mode: .dark))
            }
        }
        .padding(.horizontal)
    }
    .background(Color.dispatchDarkGray)
}
