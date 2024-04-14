import SwiftUI

internal struct QuantityStepControl : View {
    @Binding var value: Int
    let maxQuantity: Int
    let theme: Theme
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
                        .stroke(Color(hex: "#E8E8E8"), lineWidth: 2)
                case .sharp:
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(hex: "#E8E8E8"), lineWidth: 2)
                case .round:
                    Capsule()
                        .stroke(Color(hex: "#E8E8E8"), lineWidth: 2)
                }
            }
        )
    }
}


struct QuantityStepControl_Preview: PreviewProvider {
    static let round = Theme(inputStyle: .round)
    static let soft = Theme(inputStyle: .soft)
    static let hard = Theme(inputStyle: .sharp)

    static var previews: some View {
        VStack {
            QuantityStepControl(value: .constant(3), maxQuantity: 10, theme: soft)
            QuantityStepControl(value: .constant(3), maxQuantity: 10, theme: hard)
            QuantityStepControl(value: .constant(3), maxQuantity: 10, theme: round)
        }
        .padding()
        .background(Color.black)
        .previewDevice("iPhone 12")
    }
}
