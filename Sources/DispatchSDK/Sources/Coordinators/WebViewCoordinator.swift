import Foundation
import WebKit
import SafariServices

class WebViewCoordinator: Coordinator {
    let config: DispatchConfig
    let analyticsClient: AnalyticsClient
    
    init(config: DispatchConfig, analyticsClient: AnalyticsClient) {
        self.config = config
        self.analyticsClient = analyticsClient
    }
    
    func start() {
        print("[DispatchSDK] Warning: Cannot present distribution without DispatchRoute param")
    }
    
    func start(with route: DispatchRoute) {
        switch route {
        case let .checkout(id):
            navigateToDistribution(with: id)
        }
    }
    
    private func navigateToDistribution(with id: String) {
        let url = config.environment.webBaseURL.appendingPathComponent(id)
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .currentContext
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController?
                .present(
                    viewController,
                    animated: true,
                    completion: {
                        
                    }
                )
        } else {
            UIApplication
                .shared
                .keyWindow?
                .rootViewController?
                .present(
                    viewController,
                    animated: true
                )
        }
    }
    
}
