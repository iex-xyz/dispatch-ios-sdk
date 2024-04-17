import Foundation

struct Checkout: Codable, Equatable {
    let version: String
    let subFolderId: String
    let initScreen: InitScreen?
    let product: Product
    let applicationId: String
    let theme: Theme
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
    let channel: String
    let dispatchIsReseller: Bool
    let hiddenPaymentMethods: [String]
    let name: String
    let merchantTermsUrl: String
    let merchantAvailableShippingZones: [String]
    let merchantId: String
    let id: String
}

