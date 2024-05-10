import SwiftUI
import Combine
import UIKit
import QuartzCore
import CoreGraphics
import SpriteKit

struct CheckoutSuccessView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutSuccessViewModel
    
    var body: some View {
        ZStack {
            VStack {
                // TODO: How are we doing headers? UINavigationBar?
                if let imageUrlString = viewModel.checkout.product.baseImages.first, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url, content: { content in
                        content
                            .resizable()
                            .scaledToFill()
                    }, placeholder: {
                        ProgressView()
                            .foregroundStyle(.primary)
                    })
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipShape(Rectangle())
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Success!")
                                .font(.footnote.bold())
                                .foregroundStyle(Color.dispatchBlue)
                            Text("Your order is on its way.")
                                .font(.title2.bold())
                            Text("")
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Divider()
                        CheckoutOverviewDetailRow(title: "Order Number", showChevron: false) {
                            Text(viewModel.orderNumber)
                                .minimumScaleFactor(0.5)
                                .truncationMode(.middle)
                                .lineLimit(1)
                        } handler: {}
                        Divider()
                        if let shippingAddress = viewModel.shippingAddress {
                            CheckoutOverviewDetailRow(title: "Shipping Address", showChevron: false) {
                                Text(shippingAddress.formattedString)
                                    .multilineTextAlignment(.trailing)
                            } handler: {}
                            Divider()
                        }
                        if let billingInfo = viewModel.billingInfo {
                            CheckoutOverviewDetailRow(title: "Payment", showChevron: false) {
                                HStack {
                                    Text(billingInfo.cardPreview)
                                    if let icon = billingInfo.cardType.iconImage {
                                        Image(uiImage: icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 16)
                                    }
                                }
                                .foregroundStyle(.primary)
                            } handler: {}
                            Divider()
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    if !viewModel.hideOrderCompletionCTA {
                        Button(action: {
                            viewModel.onMainCtaButtonTapped()
                        }) {
                            Text(viewModel.continueCTA)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    FooterView()
                }
                .padding()
            }
            .background(theme.backgroundColor)
            .colorScheme(theme.colorScheme)
            GeometryReader { geo in
                SpriteView(scene: ParticleScene(size: geo.size), options: [.allowsTransparency])
                    .frame(width: geo.size.width, height: geo.size.height)
                    .allowsHitTesting(false)
            }
        }
    }
}



#Preview {
    SpriteView(scene: ParticleScene(size: .init(width: 300, height: 600)), options: [.allowsTransparency])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview {
    let viewModel = CheckoutSuccessViewModel(
        checkout: .mock(),
        orderNumber: "C0192329328",
        shippingAddress: .mock(),
        billingInfo: .mock(),
        continueCTA: "Keep Shopping", 
        hideOrderCompletionCTA: false
    )
    return CheckoutSuccessView(
        viewModel: viewModel
    )
}
