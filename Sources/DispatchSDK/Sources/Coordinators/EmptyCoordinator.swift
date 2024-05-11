import Foundation

class WebViewCoordinator: Coordinator {
    let config: DispatchConfig
    let analyticsClient: AnalyticsClient
    
    init(config: DispatchConfig, analyticsClient: AnalyticsClient) {
        self.config = config
        self.analyticsClient = analyticsClient
    }
    
    func start() {
        //
    }
    
    func start(with route: DispatchRoute) {
        //
    }
    
    
}
