import SwiftUI

struct CheckoutLogoImageView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        if let url = viewModel.checkout?.merchantLogoUrl {
            LogoImageView(logoUrl: url)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading, 8)
            
        }
    }
}
