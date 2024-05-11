import Foundation

@available(iOS 15.0, *)
struct Checkout: Codable, Equatable {
    let version: String
    let subFolderId: String
    let initScreen: InitScreen?
    let product: Product
    let applicationId: String
    let theme: Theme?
    let pspPublishableKey: String
    let createdAt: String
    let updatedAt: String
    let type: String
    let externalTracker: String
    let externalTrackerId: String?
    let merchantLogoUrl: String?
    let merchantName: String
    let merchantSupportUrl: String?
    let pspAccountId: String
    let channel: String?
    let dispatchIsReseller: Bool
    let hiddenPaymentMethods: [String]
    let name: String
    let merchantTermsUrl: String
    let merchantAvailableShippingZones: [String]
    let merchantId: String
    let id: String
}

@available(iOS 15.0, *)
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
