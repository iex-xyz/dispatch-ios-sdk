import SwiftUI

@available(iOS 15.0, *)
struct FooterView: View {
    var body: some View {
        HStack(spacing: 48) {
            Icons.poweredByDispatch
        }
        .padding(.horizontal)
    }
}

@available(iOS 15.0, *)
#Preview {
    FooterView()
}
