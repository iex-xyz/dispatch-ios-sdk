import UIKit
import Foundation

public struct DispatchConfig: Equatable {
    let applicationId: String
    let environment: AppEnvironment
    let merchantId: String
    
    public init(applicationId: String, environment: AppEnvironment, merchantId: String) {
        self.applicationId = applicationId
        self.environment = environment
        self.merchantId = merchantId
    }
    
    static var `default`: Self = {
        let environment: AppEnvironment
#if DEBUG
        environment = .staging
#else
        environment = .production
#endif
        var config = Self(
            applicationId: "",
            environment: environment,
            merchantId: ""
        )
        
        return config
        
    }()
}

public class DispatchSDK {
    public static var shared: DispatchSDK = .init()
    public private(set) var config: DispatchConfig = .default
    public private(set) var distributionId: String = ""

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
                networkService: RealNetworkService(
                    applicationId: config.applicationId,
                    distributionId: distributionId
                ),
                environment: config.environment
            ),
            config: config
        )
    }
    
    public func setup(using config: DispatchConfig) {
        self.config = config
    }
    
    public func present(with route: DispatchRoute) {
        if config.applicationId.isEmpty {
            print("[DispatchSDK] Warning: Invalid applicationId set before presenting. Please make sure you call 'setup(using config: DispatchConfig) before presenting.")
        }
        switch route {
        case let .checkout(id):
            self.distributionId = id
        case let .leadgen(id):
            self.distributionId = id
        default:
            break
        }
        coordinator.start(with: route)
    }
}
