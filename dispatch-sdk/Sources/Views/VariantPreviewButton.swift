import SwiftUI

internal struct VariantPreviewButton: View {
    let theme: Theme
    let title: String
    
    internal var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                
            }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.white.opacity(0.15), lineWidth: 2)
                    .overlay(
                        HStack {
                            Text("M 9 / W 10.5")
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                        }
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                    )
            }
            .padding(.top, 8)
            Text(title)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .background(.black)
                .padding(.leading, 8)
        }
        .frame(height: 52)
        .preferredColorScheme(theme.mode == .dark ? .dark : .light)
    }
}

struct VariantPreviewButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VariantPreviewButton(theme: .init(), title: "Selected Color")
            VariantPreviewButton(theme: .init(), title: "Selected Size")
        }
        .padding()
        .background(.black)
            .previewDevice("iPhone 12") // Specify the device here
    }
}
