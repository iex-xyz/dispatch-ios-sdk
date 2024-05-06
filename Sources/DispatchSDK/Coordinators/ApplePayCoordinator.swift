import UIKit
import SwiftUI
import Combine
import PassKit

class ApplePayCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let orderId: String
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ApplePayViewModel
    private let didCancel: () -> Void

    init(
        router: Router,
        apiClient: GraphQLClient,
        orderId: String,
        viewModel: ApplePayViewModel,
        didCancel: @escaping () -> Void
    ) {
        self.router = router
        self.apiClient = apiClient
        self.orderId = orderId
        self.viewModel = viewModel
        self.didCancel = didCancel
        super.init()
    }
    
    override func start() {
        showPaymentView(with: viewModel)
    }
    
    override func start(with route: DeepLinkRoute) {
        print("[WARNING] Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
   
    private func showPaymentView(with viewModel: ApplePayViewModel) {
        if PKPaymentAuthorizationViewController.canMakePayments() {
            let request = viewModel.paymentRequest
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController?.delegate = viewModel
            
            viewModel.initiateOrder()

            router.present(viewController, animated: true) {
                // TODO:
            }
        }
    }
}
