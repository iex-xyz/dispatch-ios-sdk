import UIKit
import SwiftUI
import Combine

class CheckoutSuccessCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    
    let viewModel: CheckoutSuccessViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        router: Router,
        apiClient: GraphQLClient,
        viewModel: CheckoutSuccessViewModel
    ) {
        self.router = router
        self.apiClient = apiClient
        self.viewModel = viewModel
        super.init()
    }
    
    override func start() {
        showSuccessScreen()
    }
    
    override func start(with route: DispatchRoute) {
        print("[WARNING] Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
    
    private func showSuccessScreen() {
        let viewController = CheckoutSuccessViewController(viewModel: viewModel)
        
        viewModel
            ._onMainCTATapped
            .sink { [weak self] in
                self?.router.dismissSelf(completion: {
                    //
                })
            }
            .store(in: &cancellables)
        
        router.setRootModule(viewController, animated: true)
    }
    
}
