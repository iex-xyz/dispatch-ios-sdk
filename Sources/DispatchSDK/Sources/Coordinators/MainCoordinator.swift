import UIKit

@available(iOS 15.0, *)
final class MainCoordinator: BaseCoordinator {
    
    private let router: Router
    private let apiClient: GraphQLClient
    private let analyticsClient: AnalyticsClient
    private let config: DispatchConfig

    init(router: Router, apiClient: GraphQLClient, analyticsClient: AnalyticsClient, config: DispatchConfig) {
        self.router = router
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.config = config
    }
    
    override func start() {
        print("[DispatchSDK]: Warning: Invalid coordinator invocation. Must use deep link route to start flow")
    }
    
    override func start(with route: DispatchRoute) {
        switch route {
        case let .checkout(id):
            runCheckoutFlow(for: id)
        }
    }
    
    private func runCheckoutFlow(for id: String) {
        let coordinator = CheckoutCoordinator(
            router: router,
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            checkoutId: id,
            config: config
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
