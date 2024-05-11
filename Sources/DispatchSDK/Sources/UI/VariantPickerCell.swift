import SwiftUI

@available(iOS 15.0, *)
struct VariantPickerCell: View {
    @Preference(\.theme) var theme
    let text: String
    let isSelected: Bool
    
    init(text: String, isSelected: Bool) {
        self.text = text
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(text)
                .foregroundStyle(.primary)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(minHeight: 40)
                .frame(maxWidth: .infinity)

            if isSelected {
                RoundedCorner(radius: 4, corners: [.topRight, .bottomLeft])
                    .fill(Color.dispatchBlue)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(.white)
                    )
            }
        }
        .frame(minHeight: 40)
        .frame(maxWidth: .infinity)
        .background(Colors.controlBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? Color.dispatchBlue : Colors.borderGray, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

@available(iOS 15.0, *)
#Preview {
    VStack {
        VariantPickerCell(text: "Label", isSelected: true)
        VariantPickerCell(text: "Label", isSelected: true)
        
        Divider()
        
        VStack {
            VariantPickerCell(text: "Gridiron/Summit White/Summit White/Black", isSelected: true)
            VariantPickerCell(text: "Gridiron/Summit White/Summit White/Black", isSelected: false)
        }
        .padding(.horizontal, 64)
    }
}
