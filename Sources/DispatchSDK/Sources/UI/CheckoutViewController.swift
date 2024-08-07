import Foundation
import SwiftUI
import UIKit
import Combine

@available(iOS 15.0, *)
struct CheckoutView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        VStack {
            VStack {
                MediaCarouselView(viewModel: viewModel.mediaViewModel, isZoomable: false)
                    .frame(minHeight: 200, idealHeight: 300, maxHeight: 360)
                    .fullScreenCover(item: $viewModel.mediaViewModel.selectedImage) { selectedImage in
                        ZStack {
                            MediaCarouselView(viewModel: viewModel.mediaViewModel, isZoomable: true)
                            VStack {
                                HStack {
                                    Spacer()
                                    CloseButton {
                                        viewModel.mediaViewModel.selectedImage = nil
                                    }
                                }
                                .padding()
                                Spacer()
                            }
                        }
                        .background(theme.backgroundColor)
                        .colorScheme(theme.colorScheme)
                        .gesture(DragGesture(coordinateSpace: .local)
                            .onEnded { value in
                                let width = value.translation.width
                                let height = value.translation.height
                                // check for down swipe gesture
                                if -100 <= width && width <= 100 && height > 0 {
                                    viewModel.mediaViewModel.selectedImage = nil
                                }
                            })
                    }
                
                VStack(alignment: .leading) {
                    if let productViewModel = viewModel.productViewModel {
                        ProductOverviewDetailsCell(
                            product: productViewModel.product,
                            basePrice: viewModel.selectedVariation?.price ?? productViewModel.product.basePrice,
                            baseComparePrice: viewModel.selectedVariation?.compareAtPrice ?? productViewModel.product.baseCompareAtPrice) {
                                viewModel.onMoreProductInfoButtonTapped()
                            }
                            .frame(maxWidth: .infinity)
                        if
                            let checkout = viewModel.checkout,
                            let selectedVariant = viewModel.selectedVariation,
                            let attributes = checkout.product.attributes
                        {
                            ForEach(Array(attributes.values), id: \.id) { attribute in
                                if
                                    let attributeKey = selectedVariant.attributes?[attribute.id],
                                    let selectedValue = attributes[attribute.id]?.options[attributeKey]?.title
                                {
                                    LightVariantPreviewButton(
                                        title: attribute.title,
                                        selectedValue: selectedValue,
                                        onTap: {
                                            viewModel.onAttributeTapped(attribute)
                                        }
                                    )
                                }
                            }
                        }
                        
                    } else {
                        ProgressView()
                    }
                    Spacer()
                }
                .padding()
            }
            VStack(spacing: 20) {
                HStack {
                    if viewModel.maxQuantity > 1 {
                        QuantityStepControl(
                            value: $viewModel.currentQuantity,
                            maxQuantity: viewModel.maxQuantity
                        )
                        .frame(minWidth: 120)
                        .frame(height: 40)
                    }
                    PayButton(
                        productType: viewModel.checkout?.product.type ?? .product,
                        paymentMethod: viewModel.selectedPaymentMethod,
                        isDisabled: false,
                        isLoading: false
                    ) {
                        viewModel.onPaymentCTATapped()
                    }
                }
                if viewModel.enabledPaymentMethods.count > 1 {
                    Button(action: {
                        viewModel.onMorePaymentMethodsButtonTapped()
                    }) {
                        Text("More payment options ") + Text(Image(systemName: "arrow.right"))
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .tint(.dispatchBlue)
        .onChange(of: viewModel.checkout) { value in
            viewModel.mediaViewModel.product = value?.product
            theme = value?.theme ?? .default
        }
        .colorScheme(theme.colorScheme)
    }
}
