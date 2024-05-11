import SwiftUI

@available(iOS 15.0, *)
struct CloseButton: View {
    @Preference(\.theme) var theme
    let handler: () -> Void
    
    var body: some View {
        Button(action: {
            handler()
        }) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
        }
        .foregroundStyle(.primary)
        .background(
            Circle()
                .fill(Colors.secondaryBackgroundColor)
                .frame(width: 30, height: 30)
        )
        .frame(width: 40, height: 40)
        .colorScheme(theme.colorScheme)
    }
}

@available(iOS 15.0, *)
#Preview {
    CloseButton {
        //
    }
}
