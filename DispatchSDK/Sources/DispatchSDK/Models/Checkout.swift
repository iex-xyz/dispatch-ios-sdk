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

