import SwiftUI

@available(iOS 15.0, *)
internal struct LightVariantPreviewButton: View {
    @Preference(\.theme) var theme

    let title: String
    let selectedValue: String
    let onTap: () -> Void
    
    internal var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                onTap()
            }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Colors.borderGray, lineWidth: 2)
                    .overlay(
                        HStack {
                            Text(selectedValue)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .padding(.horizontal)
                    )
            }
            .padding(.top, 8)
            .foregroundStyle(.primary)
            Text("Select \(title)")
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .background(theme.backgroundColor)
                .padding(.leading, 8)
        }
        .frame(height: 52)
        .colorScheme(theme.colorScheme)
    }
}

//
//internal struct VariantPreviewButton: View {
//    @Preference(\.theme) var theme
//    @ObservedObject var viewModel: AttributeViewModel
//    let onTap: () -> Void
//
//    
//    internal var body: some View {
//        ZStack(alignment: .topLeading) {
//            Button(action: {
//                onTap()
//            }) {
//                RoundedRectangle(cornerRadius: 4)
//                    .stroke(.primary.opacity(0.15), lineWidth: 2)
//                    .overlay(
//                        HStack {
//                            Text(viewModel.selectedValueText)
//                            Spacer()
//                            Image(systemName: "chevron.up.chevron.down")
//                        }
//                            .padding(.horizontal)
//                            .foregroundStyle(.primary)
//                    )
//            }
//            .padding(.top, 8)
//            Text("Select \(viewModel.attribute.title)")
//                .font(.footnote)
//                .fontWeight(.medium)
//                .foregroundStyle(Color(UIColor.systemBackground))
//                .padding(.horizontal, 8)
//                .background(.black)
//                .padding(.leading, 8)
//        }
//        .frame(height: 52)
//    }
//}

@available(iOS 15.0, *)
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
