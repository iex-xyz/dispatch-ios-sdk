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
                .padding()
        }
        .foregroundStyle(.primary)
        .background(
            Circle()
                .fill(Colors.secondaryBackgroundColor)
                .frame(width: 30, height: 30)
        )
        .frame(width: 44, height: 44)
        .colorScheme(theme.colorScheme)
    }
}

@available(iOS 15.0, *)
#Preview {
    CloseButton {
        //
    }
    .background(.red)
}
