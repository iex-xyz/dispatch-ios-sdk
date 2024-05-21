import Foundation

struct Leadgen: Codable {
    let applicationId: String
    let campaignName: String?
    let channel: String?
    let collectionSteps: [CollectionSteps]
    let defaultLegalText: String
    let dispatchIsReseller: Bool?
    let externalTracker: ExternalTracker?
    let externalTrackerId: String?
    let id: String
    let merchantAvailableShippingZones: [String]?
    let merchantEmployerIdentificationNumber: String?
    let merchantId: String
    let merchantLogoUrl: String?
    let merchantName: String?
    let merchantSupportUrl: String?
    let merchantTermsUrl: String?
    let name: String?
    let offerDescription: String
    let offerTitle: String
    let pspAccountId: String?
    let pspPublishableKey: String?
    let sharingPrefillText: String?
    let shopRedirectUrl: String
    let subFolderId: String
    let successBody: String?
    let successHeadlineText: String?
    let successTitle: String?
    let type: String
    
    
}
