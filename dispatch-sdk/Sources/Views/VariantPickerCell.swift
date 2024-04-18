import SwiftUI

internal struct VariantPickerCell: View {
    let text: String
    @State var isSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(text)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(minHeight: 40)
            
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
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? Color.dispatchBlue : Color.borderGray, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    VStack {
        VariantPickerCell(text: "Label", isSelected: true)
        VariantPickerCell(text: "Label", isSelected: false)
        
        Divider()
        
        VStack {
            VariantPickerCell(text: "Gridiron/Summit White/Summit White/Black", isSelected: true)
            VariantPickerCell(text: "Gridiron/Summit White/Summit White/Black", isSelected: false)
        }
        .padding(.horizontal, 64)
    }
}
