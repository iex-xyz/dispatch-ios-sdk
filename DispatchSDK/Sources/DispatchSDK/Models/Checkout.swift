import Foundation

public struct Checkout: Codable, Equatable {
    public let version: String
    public let subFolderId: String
    public let initScreen: InitScreen?
    public let product: Product
    public let applicationId: String
    public let theme: Theme
    public let pspPublishableKey: String
    public let createdAt: String
    public let updatedAt: String
    public let type: String
    public let externalTracker: String
    public let externalTrackerId: String?
    public let merchantLogoUrl: String?
    public let merchantName: String
    public let merchantSupportUrl: String?
    public let pspAccountId: String
    public let channel: String
    public let dispatchIsReseller: Bool
    public let hiddenPaymentMethods: [String]
    public let name: String
    public let merchantTermsUrl: String
    public let merchantAvailableShippingZones: [String]
    public let merchantId: String
    public let id: String
}

extension Checkout {
    static func mock() -> Checkout {
        return Checkout(
            version: "1.0",
            subFolderId: "subfolder123",
            initScreen: nil, // Assuming optional
            product: Product.mock(),
            applicationId: "app123",
            theme: .default,
            pspPublishableKey: "key123",
            createdAt: "2024-04-20",
            updatedAt: "2024-04-20",
            type: "defaultType",
            externalTracker: "tracker123",
            externalTrackerId: "trackerId123",
            merchantLogoUrl: "https://example.com/logo.png",
            merchantName: "Example Merchant",
            merchantSupportUrl: "https://example.com/support",
            pspAccountId: "pspAccount123",
            channel: "online",
            dispatchIsReseller: false,
            hiddenPaymentMethods: [],
            name: "Example Checkout",
            merchantTermsUrl: "https://example.com/terms",
            merchantAvailableShippingZones: ["Zone1", "Zone2"],
            merchantId: "merchant123",
            id: "checkout123"
        )
    }
}
