import SwiftUI

@available(iOS 15.0, *)
struct CloseButton: View {
    // Assuming `theme` is correctly implemented and accessible here.
    @Preference(\.theme) var theme

    let handler: () -> Void
    
    // Ensure the touchable area covers the whole 44x44 area.
    var body: some View {
        Button(action: handler) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .padding()
        }
        .background(
            Circle()
                .fill(Colors.secondaryBackgroundColor)
                .frame(width: 30, height: 30)
        )
        .frame(width: 44, height: 44)
        .colorScheme(theme.colorScheme)
        .foregroundColor(.primary)
        .clipShape(Circle())
    }
}
