import UIKit
import Foundation


public struct DispatchConfig: Equatable {
    let applicationId: String
    let environment: AppEnvironment
    let merchantId: String?
    let orderCompletionCTA: String
    let hideOrderCompletionCTA: Bool
    let hideRootCloseButton: Bool
    
    public init(
        applicationId: String,
        environment: AppEnvironment,
        merchantId: String? = nil,
        orderCompletionCTA: String = "Keep Shopping",
        hideOrderCompletionCTA: Bool = false,
        hideRootCloseButton: Bool = false
    ) {
        self.applicationId = applicationId
        self.environment = environment
        self.merchantId = merchantId
        self.orderCompletionCTA = orderCompletionCTA
        self.hideOrderCompletionCTA = hideOrderCompletionCTA
        self.hideRootCloseButton = hideRootCloseButton
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
    public private(set) var distributionId: String = ""
    
    private(set) var onEventTriggered: ((LoggedDispatchEvent) -> Void)?

    #if DEBUG
    public private(set) var environment: AppEnvironment = .staging
    #else
    public private(set) var environment: AppEnvironment = .production
    #endif

    private lazy var coordinator: Coordinator = self.makeCoordinator()
    private lazy var core: DispatchSDKService = self.makeSDKService()
    
    private func makeSDKService() -> DispatchSDKService {
        if #available(iOS 15.0, *) {
            return DefaultDispatchSDK()
        } else {
            return FallbackDispatchSDK()
        }
    }
    
    private func makeCoordinator() -> Coordinator {
        core.makeCoordinator()
    }
    
    public func setup(using config: DispatchConfig) {
        core.setup(using: config)
    }
    
    public func registerForEvents(_ callback: @escaping (LoggedDispatchEvent) -> Void) {
        core.registerForEvents(callback)
    }
    
    public func present(with route: DispatchRoute) {
        if core.config.applicationId.isEmpty {
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
        
        core.updateDistributionId(distributionId)
        coordinator.start(with: route)
    }
}

// We break the core behaviors into a protocol here so that we can target iOS 15 for certain
// clients such as the GraphQL API Client
protocol DispatchSDKService {
    var config: DispatchConfig { get }
    func setup(using config: DispatchConfig)
    func registerForEvents(_ callback: @escaping (LoggedDispatchEvent) -> Void)
    func updateDistributionId(_ distributionId: String)
    
    func makeCoordinator() -> Coordinator
}

@available(iOS 15.0, *)
class DefaultDispatchSDK: DispatchSDKService {
    public private(set) var config: DispatchConfig = .default {
        didSet {
            apiClient.updateEnvironment(config.environment)
            analyticsClient.updateEnvironment(config.environment)
            analyticsClient.updateApplicationId(config.applicationId)
        }
    }
    public private(set) var distributionId: String = ""
    
    private(set) var onEventTriggered: ((LoggedDispatchEvent) -> Void)?

    #if DEBUG
    public private(set) var environment: AppEnvironment = .staging
    #else
    public private(set) var environment: AppEnvironment = .production
    #endif

    private lazy var coordinator: Coordinator = self.makeCoordinator()
    private lazy var apiClient: GraphQLClient = {
        return GraphQLClient(
            networkService: RealNetworkService(
                applicationId: config.applicationId,
                distributionId: distributionId
            ),
            environment: config.environment
        )
    }()

    private lazy var analyticsClient: AnalyticsClient = {
        LiveAnalyticsClient(
            environment: config.environment,
            applicationId: config.applicationId,
            apiClient: apiClient,
            onEventTriggered: { [weak self] event in
                self?.onEventTriggered?(event)
            }
        )
    }()
    
    internal func makeCoordinator() -> Coordinator {
        return MainCoordinator(
            router: RouterImp(rootController: NoRotationNavigationController(), checkoutController: NoRotationNavigationController()),
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            config: config
        )
    }
    
    public func setup(using config: DispatchConfig) {
        self.config = config
    }
    
    public func registerForEvents(_ callback: @escaping (LoggedDispatchEvent) -> Void) {
        self.onEventTriggered = callback
    }
    
    func updateDistributionId(_ distributionId: String) {
        self.distributionId = distributionId
        self.analyticsClient.updateDistributionId(distributionId)
    }

}

class FallbackDispatchSDK: DispatchSDKService {
    private(set) var onEventTriggered: ((LoggedDispatchEvent) -> Void)?
    private var distributionId: String = ""

    public private(set) var config: DispatchConfig = .default {
        didSet {
            analyticsClient.updateEnvironment(config.environment)
            analyticsClient.updateApplicationId(config.applicationId)
        }
    }
    
    private lazy var analyticsClient: AnalyticsClient = {
        FallbackAnalyticsClient(
            environment: config.environment,
            applicationId: config.applicationId,
            onEventTriggered: { [weak self] event in
                self?.onEventTriggered?(event)
            }
        )
    }()
    


    func setup(using config: DispatchConfig) {
        self.config = config
    }
    
    func registerForEvents(_ callback: @escaping (LoggedDispatchEvent) -> Void) {
        self.onEventTriggered = callback
    }
    
    
    func makeCoordinator() -> any Coordinator {
        return WebViewCoordinator(
            config: config,
            analyticsClient: analyticsClient
        )
    }

    func updateDistributionId(_ distributionId: String) {
        self.distributionId = distributionId
        self.analyticsClient.updateDistributionId(distributionId)
    }
}
