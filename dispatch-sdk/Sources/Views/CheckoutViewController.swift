import Foundation
import SwiftUI
import UIKit
import Combine

struct CheckoutView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @StateObject var mediaViewModel: ProductMediaViewModel = .init(images: [
        "https://fastly.picsum.photos/id/868/400/300.jpg?hmac=5C4AshIrWvAN9A0sY5Zgv6X_MVpHWivtCnxEMLRW8OE",
        "https://fastly.picsum.photos/id/889/400/300.jpg?hmac=bnjifYNFcybzu2SpzMsIa7Od1iOA9Jjz7imYROcHw-Q",
        "https://fastly.picsum.photos/id/287/400/300.jpg?hmac=WOrUCUFbXzGkc4Ea1v9o-f4eG2KLgGBRRn2QOQZB_7Y",
        "https://fastly.picsum.photos/id/891/400/300.jpg?hmac=nHUVgyyOABMgUtxMImL3NrbL2GZR3Xl-ATduX-QXiPI",
    ])

    var body: some View {
        VStack {
            MediaCarouselView(viewModel: mediaViewModel)
            Button("Secure checkout")  {
                viewModel.onSecureCheckoutButtonTapped()
            }
            if let productViewModel = viewModel.productViewModel {
                ProductOverviewDetailsCell(product: productViewModel.product)
                ForEach(Array(productViewModel.selectedVariantMap.values), id: \.attribute.id) { viewModel in
                    VariantPreviewButton(
                        theme: .round,
                        viewModel: viewModel
                    ) {
                        self.viewModel.onAttributeTapped(viewModel.attribute)
                    }
                    
                    ForEach(viewModel.variations) { variation in
                        Button(action: {
                            viewModel.onVariationTapped(variation)
                        }) {
                            Text(viewModel.title(for: variation))
                        }
                        .disabled(variation.quantityAvailable == nil || variation.quantityAvailable == 0)
                    }
                }
                
            } else {
                ProgressView()
            }
            Spacer()
        }
        .preferredColorScheme(.light)
        .background(.white)
        .onChange(of: viewModel.checkout?.product) { value in
            mediaViewModel.product = value
        }
    }
}

internal class CheckoutViewController: UIViewController {
    
    private let viewModel: CheckoutViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var hostingController: UIHostingController<CheckoutView> = {
        .init(rootView: CheckoutView(viewModel: viewModel))
    }()
    
    internal init(viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }
}
