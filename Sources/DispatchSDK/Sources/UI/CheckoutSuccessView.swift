import SwiftUI
import Combine
import UIKit
import QuartzCore
import CoreGraphics
import SpriteKit

@available(iOS 15.0, *)
struct CheckoutSuccessView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutSuccessViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if let imageUrlString = viewModel.checkout.product.baseImages.first, let url = URL(string: imageUrlString) {
                    GeometryReader { geometry in
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .foregroundStyle(.primary)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Color.gray // Placeholder for failed image load
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(height: 320)
                        .clipShape(Rectangle())
                    }
                }
                
                ScrollView {
                    // Content of the success view (order details, etc.)
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
                
                // Bottom buttons and footer
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
            GeometryReader { geometry in
                // Overlay the particle effect
                ParticleView(size: geometry.size)
                    .allowsHitTesting(false) // Prevent the particle effect from intercepting touches
            }
        }
    }
}


@available(iOS 15.0, *)
#Preview {
    SpriteView(scene: ParticleScene(size: .init(width: 300, height: 600)), options: [.allowsTransparency])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

@available(iOS 15.0, *)
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
