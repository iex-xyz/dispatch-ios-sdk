import UIKit

final class MainCoordinator: BaseCoordinator {
    
    private let router: Router

    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runCheckoutFlow()
    }
    
    private func runCheckoutFlow() {

        let coordinator = CheckoutCoordinator(router: router)
        coordinator.shouldDismissFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.router.dismissSelf(completion: nil)
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
