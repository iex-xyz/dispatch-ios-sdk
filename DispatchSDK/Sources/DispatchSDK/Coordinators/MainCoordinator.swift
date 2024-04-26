import UIKit

final class MainCoordinator: BaseCoordinator {
    
    private let router: Router
    private let apiClient: GraphQLClient

    init(router: Router, apiClient: GraphQLClient) {
        self.router = router
        self.apiClient = apiClient
    }
    
    override func start() {
        print("[WARNING] Invalid coordinator invocation. Must use deep link route to start flow")
    }
    
    override func start(with route: DeepLinkRoute) {
        switch route {
        case let .checkout(id):
            runCheckoutFlow(for: id)
        case let .leadgen(id):
            runLeadgenFlow(for: id)
        }
    }
    
    private func runCheckoutFlow(for id: String) {
        let coordinator = CheckoutCoordinator(
            router: router,
            apiClient: apiClient,
            checkoutId: id
        )
        coordinator.shouldDismissFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.router.dismissSelf(completion: nil)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runLeadgenFlow(for id: String) {
        // TODO: Add Leadgen support
    }

}
