import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    @Binding var isValid: Bool
    let theme: Theme
    
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
                        .stroke(isValid ? .blue : .red)
                }
                .foregroundStyle(configuration.isOn ? .white : .blue)
                .background(configuration.isOn ? .blue : .white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 16, height: 16)
                .padding(.top, 2)
            configuration.label
                .font(.caption)
                .foregroundStyle(.primary)
            Spacer()
        }
        .preferredColorScheme(theme.mode == .dark ? .dark : .light)
    }
}




struct CheckboxToggleStyle_Preview: PreviewProvider {
    
    static let theme: Theme = .init()
    
    static var previews: some View {
        VStack {
            Toggle("Allow |merchantName| to use this email address for marketing and newsletters.", isOn: .constant(true))
                .toggleStyle(
                    CheckboxToggleStyle(
                        isValid: .constant(true),
                        theme: theme
                    )
                )
            Toggle("Allow |merchantName| to use this email address for marketing and newsletters.", isOn: .constant(false))
                .toggleStyle(
                    CheckboxToggleStyle(
                        isValid: .constant(true),
                        theme: theme
                    )
                )
        }
        .padding()
        .background(.black)
            .previewDevice("iPhone 12") // Specify the device here
    }
}
