import UIKit

final class MainCoordinator: BaseCoordinator {
    
    private let router: Router
    private let apiClient: GraphQLClient

    init(router: Router, apiClient: GraphQLClient) {
        self.router = router
        self.apiClient = apiClient
    }
    
    override func start() {
        runCheckoutFlow()
    }
    
    private func runCheckoutFlow() {
        let coordinator = CheckoutCoordinator(router: router, apiClient: apiClient)
        coordinator.shouldDismissFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.router.dismissSelf(completion: nil)
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
