import UIKit
import SwiftUI
import Combine
import PassKit

class ApplePayCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let analyticsClient: AnalyticsClient
    private let config: DispatchConfig
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ApplePayViewModel

    private let didComplete: (InitiateOrder, Address?, BillingInfo?) -> Void
    private let didCancel: () -> Void

    init(
        router: Router,
        apiClient: GraphQLClient,
        analyticsClient: AnalyticsClient,
        viewModel: ApplePayViewModel,
        config: DispatchConfig,
        didCancel: @escaping () -> Void,
        didComplete: @escaping (InitiateOrder, Address?, BillingInfo?) -> Void
    ) {
        self.router = router
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.viewModel = viewModel
        self.config = config
        self.didCancel = didCancel
        self.didComplete = didComplete
        super.init()
    }
    
    override func start() {
        showPaymentView(with: viewModel)
    }
    
    override func start(with route: DispatchRoute) {
        print("[WARNING] Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
   
    private func showPaymentView(with viewModel: ApplePayViewModel) {
        if PKPaymentAuthorizationViewController.canMakePayments() {
            let request = viewModel.paymentRequest
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController?.delegate = viewModel
            
            viewModel
                ._onOrderCompleted
                .sink { [weak self] (order, address, billingInfo) in
                    viewController?.dismiss(animated: true, completion: {
                        self?.didComplete(order, address, billingInfo)
                    })
                }
                .store(in: &cancellables)
            
            router.present(viewController, animated: true) {
                //
            }
        }
    }
}
