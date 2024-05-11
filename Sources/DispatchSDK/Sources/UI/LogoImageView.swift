import SwiftUI

@available(iOS 15.0, *)
struct LogoImageView: View {
    let logoUrl: String
    
    init(logoUrl: String) {
        self.logoUrl = logoUrl.replacingOccurrences(of: ".svg", with: ".png")
    }
    
    var body: some View {
        AsyncImage(url: URL(string: logoUrl)) { image in
            image
                .resizable()
                .scaledToFit()
                .padding(8)
        } placeholder: {
            EmptyView()
        }
    }
}
