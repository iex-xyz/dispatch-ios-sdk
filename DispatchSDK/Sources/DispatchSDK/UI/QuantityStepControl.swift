import SwiftUI

internal struct QuantityStepControl : View {
    @Preference(\.theme) var theme

    @Binding var value: Int
    let maxQuantity: Int
    var step = 1

    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)

    internal var body: some View {
        HStack {
            Button(action: {
                if value > 0 {
                    value -= step
                    impactGenerator.impactOccurred()
                }
            }, label: {
                Image(systemName: "minus")
                    .foregroundColor(value > 1 ? .white : .white.opacity(0.5))
            })
            
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Button(action: {
                if value < 1 {
                    value += step
                    impactGenerator.impactOccurred()
                }
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(value < maxQuantity ? .white : .white.opacity(0.5))
            })
        }
        .padding()
        .overlay(
            Group {
                switch theme.inputStyle {
                case .soft:
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Colors.borderGray, lineWidth: 2)
                case .sharp:
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Colors.borderGray, lineWidth: 2)
                case .round:
                    Capsule()
                        .stroke(Colors.borderGray, lineWidth: 2)
                }
            }
        )
        .preferredColorScheme(theme.mode == .dark ? .dark : .light)
    }
}


#Preview {
    
    @State var quantity: Int = 3

    return VStack {
        VStack {
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .soft)
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .sharp)
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .round)
        }
        VStack {
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .soft.darkMode())
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .sharp.darkMode())
            QuantityStepControl(value: $quantity, maxQuantity: 10)
                .environment(\.theme, .round.darkMode())
        }
    }
    .padding()
    .background(Color.dispatchLightGray)
    .previewDevice("iPhone 12")
}