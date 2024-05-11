import UIKit
import Foundation

public struct DispatchConfig: Equatable {
    let applicationId: String
    let environment: AppEnvironment
    let merchantId: String
    let orderCompletionCTA: String
    let hideOrderCompletionCTA: Bool
    let hideRootCloseButton: Bool
    
    public init(
        applicationId: String,
        environment: AppEnvironment,
        merchantId: String,
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
        if #available(iOS 15, *) {
            return GraphQLClient(
                networkService: RealNetworkService(
                    applicationId: config.applicationId,
                    distributionId: distributionId
                ),
                environment: config.environment
            )
        } else {
            return GraphQLClient(
                networkService: EmptyNetworkService(),
                environment: config.environment
            )
        }
    }()

    private lazy var analyticsClient: AnalyticsClient = {
        LiveAnalyticsClient(
            environment: config.environment,
            applicationId: config.applicationId,
            onEventTriggered: { [weak self] event in
                self?.onEventTriggered?(event)
            }
        )
    }()

    private func makeCoordinator() -> Coordinator {
        if #available(iOS 15, *) {
            return MainCoordinator(
                router: RouterImp(rootController: UINavigationController(), checkoutController: UINavigationController()),
                apiClient: apiClient,
                analyticsClient: analyticsClient,
                config: config
            )

        } else {
            return WebViewCoordinator(
                config: config,
                analyticsClient: analyticsClient
            )
        }

    }
    
    public func setup(using config: DispatchConfig) {
        self.config = config
    }
    
    public func registerForEvents(_ callback: @escaping (LoggedDispatchEvent) -> Void) {
        self.onEventTriggered = callback
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
        
        analyticsClient.updateDistributionId(distributionId)
        coordinator.start(with: route)
    }
}
