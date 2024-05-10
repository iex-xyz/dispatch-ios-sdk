import Combine
import Foundation

public enum DispatchEvent: Equatable {
    // Checkout
    case carouselSwipe_Checkout(direction: String, imageIndex: Int) // Added
    case checkoutDismissed_Checkout // Added
    case checkoutRequested_Checkout // Added
    case customerIdentifierCollected_Checkout // Added
    case navigatePrevious_Checkout
    case paymentSent_Checkout // Added
    case paymentAuthorized_Checkout // Added
    case paymentFailed_Checkout // Added
    case paymentMethodSelected_Checkout(paymentMethod: String) // Added
    case productDetailsOpened_Checkout // Added
    case shippingAddressCollected_Checkout // Added
    case trustModalDismissed_Checkout // Added
    case trustModalOpened_Checkout // Added
    case variantSelected_Checkout(attribute: [String: String]) // Added
    case quantitySelected_Checkout(quantity: Int) // Added
    case termsClicked_Checkout // Added
    case view_Checkout
    
    // Leadgen
    case carouselSwipe_Leadgen(direction: String, imageIndex: Int)
    case contactInfoCollected_Leadgen
    case copyCode_Leadgen
    case formRequested_Leadgen
    case formDismissed_Leadgen
    case navigatePrevious_Leadgen
    case recommendedProductClick_Leadgen
    case shopNowClicked_Leadgen
    case termsClicked_Leadgen
    case trustModalDismissed_Leadgen
    case trustModalOpened_Leadgen
    case view_Leadgen
    
    public var name: String {
        switch self {
        case .carouselSwipe_Checkout: return "carouselSwipe_Checkout"
        case .checkoutDismissed_Checkout: return "checkoutDismissed_Checkout"
        case .checkoutRequested_Checkout: return "checkoutRequested_Checkout"
        case .customerIdentifierCollected_Checkout: return "customerIdentifierCollected_Checkout"
        case .navigatePrevious_Checkout: return "navigatePrevious_Checkout"
        case .paymentSent_Checkout: return "paymentSent_Checkout"
        case .paymentAuthorized_Checkout: return "paymentAuthorized_Checkout"
        case .paymentFailed_Checkout: return "paymentFailed_Checkout"
        case .paymentMethodSelected_Checkout: return "paymentMethodSelected_Checkout"
        case .productDetailsOpened_Checkout: return "productDetailsOpened_Checkout"
        case .shippingAddressCollected_Checkout: return "shippingAddressCollected_Checkout"
        case .trustModalDismissed_Checkout: return "trustModalDismissed_Checkout"
        case .trustModalOpened_Checkout: return "trustModalOpened_Checkout"
        case .variantSelected_Checkout: return "variantSelected_Checkout"
        case .quantitySelected_Checkout: return "quantitySelected_Checkout"
        case .termsClicked_Checkout: return "termsClicked_Checkout"
        case .view_Checkout: return "view_Checkout"
        case .carouselSwipe_Leadgen: return "carouselSwipe_Leadgen"
        case .contactInfoCollected_Leadgen: return "contactInfoCollected_Leadgen"
        case .copyCode_Leadgen: return "copyCode_Leadgen"
        case .formRequested_Leadgen: return "formRequested_Leadgen"
        case .formDismissed_Leadgen: return "formDismissed_Leadgen"
        case .navigatePrevious_Leadgen: return "navigatePrevious_Leadgen"
        case .recommendedProductClick_Leadgen: return "recommendedProductClick_Leadgen"
        case .shopNowClicked_Leadgen: return "shopNowClicked_Leadgen"
        case .termsClicked_Leadgen: return "termsClicked_Leadgen"
        case .trustModalDismissed_Leadgen: return "trustModalDismissed_Leadgen"
        case .trustModalOpened_Leadgen: return "trustModalOpened_Leadgen"
        case .view_Leadgen: return "view_Leadgen"
        }
    }
}


protocol AnalyticsClient {
    var onEventTriggered: (DispatchEvent) -> Void { get set }
    func send(event: DispatchEvent) -> Void
    func updateEnvironment(_ environment: AppEnvironment)
    func updateApplicationId(_ applicationId: String)
    func updateDistributionId(_ distributionId: String)
}

class MockAnalyticsClient: AnalyticsClient {
    
    var onEventTriggered: (DispatchEvent) -> Void = { _ in
        
    }

    func send(event: DispatchEvent) {
        //
    }
    
    func updateEnvironment(_ environment: AppEnvironment) {
        //
    }

    func updateDistributionId(_ distributionId: String) {
        
    }

    func updateApplicationId(_ applicationId: String) {
        
    }
}

class LiveAnalyticsClient: AnalyticsClient {
    
    internal var onEventTriggered: (DispatchEvent) -> Void
    private var environment: AppEnvironment
    private var applicationId: String
    private var distributionId: String?
    
    init(environment: AppEnvironment, applicationId: String, onEventTriggered: @escaping (DispatchEvent) -> Void) {
        self.onEventTriggered = onEventTriggered
        self.environment = environment
        self.applicationId = applicationId
    }

    func updateEnvironment(_ environment: AppEnvironment) {
        self.environment = environment
    }
    
    func updateApplicationId(_ applicationId: String) {
        self.applicationId = applicationId
    }

    func updateDistributionId(_ distributionId: String) {
        self.distributionId = distributionId
    }
    
    func send(event: DispatchEvent) {
        // TODO: Implement REST API (missing from Postman)
        
        onEventTriggered(event)
    }

    // TODO: Handle async event handler via API
}
