import SwiftUI

@available(iOS 15.0, *)
struct CheckboxToggleStyle: ToggleStyle {
    @Preference(\.theme) var theme
    @Binding var isValid: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: .top) {
            Image(systemName: configuration.isOn ? "checkmark" : "")
                .resizable()
                .scaledToFit()
                .padding(3)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isValid ? Color.dispatchBlue : Color.dispatchRed)
                }
                .foregroundStyle(configuration.isOn ? .white : Color.dispatchBlue)
                .background(configuration.isOn ? Color.dispatchBlue : .white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 16, height: 16)
                .padding(.top, 2)
            configuration.label
                .font(.caption)
                .foregroundStyle(.primary)
            Spacer()
        }
    }
}



@available(iOS 15.0, *)
#Preview {
    @State var isToggled: Bool = false
    return VStack {
        Toggle("Allow |merchantName| to use this email address for marketing and newsletters.", isOn: $isToggled)
            .toggleStyle(
                CheckboxToggleStyle(isValid: .constant(true))
            )
        Toggle("Allow |merchantName| to use this email address for marketing and newsletters.", isOn: .constant(false))
            .toggleStyle(
                CheckboxToggleStyle(isValid: .constant(true))
            )
    }
    .padding()
    .previewDevice("iPhone 12")
}
