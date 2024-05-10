import SwiftUI

struct CheckoutNavigationTitle: View {
    @ObservedObject var viewModel: CheckoutViewModel
    
    let tapHandler: (Checkout) -> Void
    
    var body: some View {
        Group {
            if let checkout = viewModel.checkout, let domain = checkout.product.pdpDomain {
                MerchantSecurityTag(domain: domain, tapHandler: {
                    tapHandler(checkout)
                })
            }
        }
    }
}

