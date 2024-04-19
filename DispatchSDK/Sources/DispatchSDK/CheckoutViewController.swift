import Foundation
import SwiftUI
import UIKit
import Combine

struct CheckoutView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutViewModel
    @StateObject var mediaViewModel: ProductMediaViewModel = .init(images: [])

    var body: some View {
        VStack {
            CheckoutHeader(logo: nil)
            ScrollView {
                VStack {
                    MediaCarouselView(viewModel: mediaViewModel)
                        .frame(height: 200)
                    VStack {
                        if let productViewModel = viewModel.productViewModel {
                            ProductOverviewDetailsCell(product: productViewModel.product)
                            if
                                let checkout = viewModel.checkout,
                                let selectedVariant = viewModel.selectedVariant
                            {
                                ForEach(Array(checkout.product.attributes.values), id: \.id) { attribute in
                                    LightVariantPreviewButton(
                                        title: attribute.title,
                                        selectedValue: selectedVariant.attributes?[attribute.id] ?? "None",
                                        onTap: {
                                            viewModel.onAttributeTapped(attribute)
                                        }
                                    )
                                }
                            }
                            
                        } else {
                            ProgressView()
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            VStack {
                PayButton(ctaText: "Buy with", paymentType: .creditCard)
                Button(action: {
                    
                }) {
                    Text("More payment options")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .environment(\.theme, theme)
        // TODO: This should come from the Theme
        // once we have primary/background color decoding back in
        .tint(.dispatchBlue)
        .onChange(of: viewModel.checkout) { value in
            mediaViewModel.product = value?.product
            if let theme = value?.theme {
                self.theme = theme
            }
        }
        .colorScheme(theme.colorScheme)
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
