import Combine
import Foundation

public struct LoggedDispatchEvent: Encodable, Identifiable {
    public let id: UUID = .init()
    public let distributionId: String
    public let timestamp: Date = Date()
    public let event: DispatchEvent
}

public enum DispatchEvent: Equatable, Encodable {
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
            // MARK: Checkout
        case .carouselSwipe_Checkout: return "carousel_swipe"
        case .checkoutDismissed_Checkout: return "checkout_dismissed"
        case .checkoutRequested_Checkout: return "checkout_requested"
        case .customerIdentifierCollected_Checkout: return "customer_identifier_collected"
        case .navigatePrevious_Checkout: return "navigate_previous"
        case .paymentSent_Checkout: return "payment_sent"
        case .paymentAuthorized_Checkout: return "payment_authorized"
        case .paymentFailed_Checkout: return "payment_failed"
        case .paymentMethodSelected_Checkout: return "payment_method_selected"
        case .productDetailsOpened_Checkout: return "product_details_opened"
        case .shippingAddressCollected_Checkout: return "shipping_address_collected"
        case .trustModalDismissed_Checkout: return "trust_modal_dismissed"
        case .trustModalOpened_Checkout: return "trust_modal_opened"
        case .variantSelected_Checkout: return "variant_selected"
        case .quantitySelected_Checkout: return "quantity_selected"
        case .termsClicked_Checkout: return "terms_clicked"
        case .view_Checkout: return "view"
            
            // MARK: Leadgen
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

    public var params: [String: AnyHashable] {
        switch self {
        case .carouselSwipe_Checkout(let direction, let imageIndex):
            return ["direction": direction, "imageIndex": imageIndex]
        case .checkoutDismissed_Checkout:
            return [:]
        case .checkoutRequested_Checkout:
            return [:]
        case .customerIdentifierCollected_Checkout:
            return [:]
        case .navigatePrevious_Checkout:
            return [:]
        case .paymentSent_Checkout:
            return [:]
        case .paymentAuthorized_Checkout:
            return [:]
        case .paymentFailed_Checkout:
            return [:]
        case .paymentMethodSelected_Checkout(let paymentMethod):
            return ["paymentMethod": paymentMethod]
        case .productDetailsOpened_Checkout:
            return [:]
        case .shippingAddressCollected_Checkout:
            return [:]
        case .trustModalDismissed_Checkout:
            return [:]
        case .trustModalOpened_Checkout:
            return [:]
        case .variantSelected_Checkout(let attribute):
            return attribute
        case .quantitySelected_Checkout(let quantity):
            return ["quantity": quantity]
        case .termsClicked_Checkout:
            return [:]
        case .view_Checkout:
            return [:]
        case .carouselSwipe_Leadgen(let direction, let imageIndex):
            return ["direction": direction, "imageIndex": imageIndex]
        case .contactInfoCollected_Leadgen:
            return [:]
        case .copyCode_Leadgen:
            return [:]
        case .formRequested_Leadgen:
            return [:]
        case .formDismissed_Leadgen:
            return [:]
        case .navigatePrevious_Leadgen:
            return [:]
        case .recommendedProductClick_Leadgen:
            return [:]
        case .shopNowClicked_Leadgen:
            return [:]
        case .termsClicked_Leadgen:
            return [:]
        case .trustModalDismissed_Leadgen:
            return [:]
        case .trustModalOpened_Leadgen:
            return [:]
        case .view_Leadgen:
            return [:]
        }
    }
    
}


protocol AnalyticsClient {
    var onEventTriggered: (LoggedDispatchEvent) -> Void { get set }
    func send(event: DispatchEvent) -> Void
    func updateEnvironment(_ environment: AppEnvironment)
    func updateApplicationId(_ applicationId: String)
    func updateDistributionId(_ distributionId: String)
}

class MockAnalyticsClient: AnalyticsClient {
    
    var onEventTriggered: (LoggedDispatchEvent) -> Void = { _ in
        
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

@available(iOS 15.0, *)
class LiveAnalyticsClient: AnalyticsClient {
    
    internal var onEventTriggered: (LoggedDispatchEvent) -> Void
    private var environment: AppEnvironment
    private var applicationId: String
    private var distributionId: String?
    
    let apiClient: GraphQLClient
    
    init(
        environment: AppEnvironment,
        applicationId: String,
        apiClient: GraphQLClient,
        onEventTriggered: @escaping (LoggedDispatchEvent) -> Void
    ) {
        self.onEventTriggered = onEventTriggered
        self.environment = environment
        self.apiClient = apiClient
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
        let loggedEvent = LoggedDispatchEvent(distributionId: distributionId ?? "missing", event: event)
        Task {
            do {
                let request = CreateEventRequest(event: loggedEvent, orderId: nil)
                _ = try await apiClient.performOperation(request)
            } catch {
                print("[DispatchSDK] Error when sending DispatchEvent via the API", error)
            }
        }
        
        onEventTriggered(loggedEvent)
    }

    // TODO: Handle async event handler via API
}
class FallbackAnalyticsClient: AnalyticsClient {
    
    internal var onEventTriggered: (LoggedDispatchEvent) -> Void
    private var environment: AppEnvironment
    private var applicationId: String
    private var distributionId: String?
    
    
    init(
        environment: AppEnvironment,
        applicationId: String,
        onEventTriggered: @escaping (LoggedDispatchEvent) -> Void
    ) {
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
        // NOTE: Events will be logged via the web session so we don't want to duplicate those here
        let loggedEvent = LoggedDispatchEvent(distributionId: distributionId ?? "missing", event: event)
        onEventTriggered(loggedEvent)
    }
}
