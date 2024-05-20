import UIKit
import SwiftUI
import Combine

@available(iOS 15.0, *)
class CheckoutSuccessCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let analyticsClient: AnalyticsClient
    private let showAtRoot: Bool

    let viewModel: CheckoutSuccessViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        router: Router,
        apiClient: GraphQLClient,
        analyticsClient: AnalyticsClient,
        viewModel: CheckoutSuccessViewModel,
        showAtRoot: Bool
    ) {
        self.router = router
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.viewModel = viewModel
        self.showAtRoot = showAtRoot
        super.init()
    }
    
    override func start() {
        showSuccessScreen()
    }
    
    override func start(with route: DispatchRoute) {
        print("[DispatchSDK]: Warning: Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
    
    private func showSuccessScreen() {
        let viewController = UIHostingController<CheckoutSuccessView>(
            rootView: CheckoutSuccessView(viewModel: viewModel)
        )
        
        viewModel
            ._onMainCTATapped
            .sink { [weak self] in
                self?.router.dismissCheckout(completion: { [weak self] in
                    self?.router.dismissSelf(completion: nil)
                })
            }
            .store(in: &cancellables)
        
        if showAtRoot {
            router.setRootModule(viewController, hideBar: true, animated: true)
        } else {
            router.setCheckoutRootModule(viewController, hideBar: true, animated: true)
        }
    }
    
}
