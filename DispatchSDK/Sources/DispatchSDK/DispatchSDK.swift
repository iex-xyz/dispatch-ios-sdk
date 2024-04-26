import UIKit
import Foundation

public class DispatchSDK {
    public static var shared: DispatchSDK = .init()
    #if DEBUG
    public private(set) var environment: AppEnvironment = .staging
    #else
    public private(set) var environment: AppEnvironment = .production
    #endif

    private lazy var coordinator: Coordinator = self.makeCoordinator()
    
    private func makeCoordinator() -> Coordinator {
        return MainCoordinator(
            router: RouterImp(rootController: UINavigationController()),
            apiClient: GraphQLClient(
                networkService: RealNetworkService(),
                environment: environment
            )
        )
    }
    
    public func setEnvironment(_ environment: AppEnvironment) {
        self.environment = environment
    }
    
    public func present(with route: DeepLinkRoute) {
        coordinator.start(with: route)
    }
}
