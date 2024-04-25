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
   
    private func showPaymentView(with viewModel: ApplePayViewModel) {
        if PKPaymentAuthorizationViewController.canMakePayments(
            usingNetworks: viewModel.supportedNetworks
        ) {
            let request = viewModel.generateRequest()
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            router.present(viewController, animated: true) {
                // TODO:
            }
        }
    }
}
