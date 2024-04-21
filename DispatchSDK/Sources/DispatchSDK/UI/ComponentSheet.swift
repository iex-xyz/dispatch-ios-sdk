import SwiftUI

struct ComponentSheet: View {
    @Preference(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack {
                ForEach(PaymentType.allCases, id: \.rawValue) { paymentType in
                    VStack {
                        PayButton(ctaText: "Continue with", paymentType: paymentType) {}
                        PayButton(ctaText: "Pay with", paymentType: paymentType) {}
                        PayButton(ctaText: "Donate with", paymentType: paymentType) {}
                    }
                }
            }
            
        }
    }
}

#Preview {
    ComponentSheet()
}
