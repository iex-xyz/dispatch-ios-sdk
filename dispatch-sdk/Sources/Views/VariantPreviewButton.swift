import SwiftUI

internal struct LightVariantPreviewButton: View {
    @Environment(\.theme) var theme

    let title: String
    let selectedValue: String
    let onTap: () -> Void

    
    internal var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                onTap()
            }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.primary.opacity(0.15), lineWidth: 2)
                    .overlay(
                        HStack {
                            Text(selectedValue)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                        }
                            .padding(.horizontal)
                            .foregroundStyle(.primary)
                    )
            }
            .padding(.top, 8)
            Text("Select \(title)")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(Color(UIColor.systemBackground))
                .padding(.horizontal, 8)
                .background(.black)
                .padding(.leading, 8)
        }
        .frame(height: 52)
    }
}


internal struct VariantPreviewButton: View {
    @Environment(\.theme) var theme
    @ObservedObject var viewModel: AttributeViewModel
    let onTap: () -> Void

    
    internal var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                onTap()
            }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.primary.opacity(0.15), lineWidth: 2)
                    .overlay(
                        HStack {
                            Text(viewModel.selectedValueText)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                        }
                            .padding(.horizontal)
                            .foregroundStyle(.primary)
                    )
            }
            .padding(.top, 8)
            Text("Select \(viewModel.attribute.title)")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(Color(UIColor.systemBackground))
                .padding(.horizontal, 8)
                .background(.black)
                .padding(.leading, 8)
        }
        .frame(height: 52)
    }
}

struct VariantPreviewButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            VariantPreviewButton(theme: .sharp, title: "Selected Color", selectedValue: "M 9 / W 10.5")
//            VariantPreviewButton(theme: .sharp, title: "Selected Size", selectedValue: "M 9 / W 10.5")
        }
        .padding()
        .background(.black)
            .previewDevice("iPhone 12") // Specify the device here
    }
}
