import SwiftUI

internal struct CheckoutHeader: View {
    @Environment(\.theme) var theme
    let logo: Image?
    
    var body: some View {
        ZStack {
            if let logo {
                logo
            }
            HStack {
                Spacer()
                Icons.lock.tint(.dispatchLightGray)
            }
        }
    }
}
