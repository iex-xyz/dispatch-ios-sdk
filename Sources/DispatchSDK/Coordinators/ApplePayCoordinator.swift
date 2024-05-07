import UIKit
import SwiftUI
import Combine
import PassKit

class ApplePayCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let config: DispatchConfig
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ApplePayViewModel
    private let didCancel: () -> Void

    init(
        router: Router,
        apiClient: GraphQLClient,
        viewModel: ApplePayViewModel,
        config: DispatchConfig,
        didCancel: @escaping () -> Void
    ) {
        self.router = router
        self.apiClient = apiClient
        self.viewModel = viewModel
        self.config = config
        self.didCancel = didCancel
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
            
            router.present(viewController, animated: true) {
                //
            }
        }
    }
}
