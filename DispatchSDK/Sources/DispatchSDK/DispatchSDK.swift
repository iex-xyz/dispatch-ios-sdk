import UIKit
import Foundation

public class DispatchSDK {
    public static var shared: DispatchSDK = .init()
    public private(set) var applicationId: String = ""

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
                networkService: RealNetworkService(applicationId: applicationId),
                environment: environment
            )
        )
    }
    
    public func setApplicationId(_ applicationId: String) {
        self.applicationId = applicationId
    }
    
    public func setEnvironment(_ environment: AppEnvironment) {
        self.environment = environment
    }
    
    public func present(with route: DeepLinkRoute) {
        // TODO: Add checks that applicationId has been set before presenting
        coordinator.start(with: route)
    }
}
