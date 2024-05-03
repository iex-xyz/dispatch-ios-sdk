import Foundation

public struct Content: Codable {
    public let version: String
    public let subFolderId: String
    public let initScreen: InitScreen
    public let product: Product
    public let applicationId: String
    public let theme: Theme?
    public let pspPublishableKey: String
    public let createdAt: String
    public let updatedAt: String
    public let type: String
    public let externalTracker: String
    public let externalTrackerId: String
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
    
    init(
        version: String,
        subFolderId: String,
        initScreen: InitScreen,
        product: Product,
        applicationId: String,
        theme: Theme,
        pspPublishableKey: String,
        createdAt: String,
        updatedAt: String,
        type: String,
        externalTracker: String,
        externalTrackerId: String,
        merchantLogoUrl: String,
        merchantName: String,
        merchantSupportUrl: String,
        pspAccountId: String,
        channel: String,
        dispatchIsReseller: Bool,
        hiddenPaymentMethods: [String],
        name: String,
        merchantTermsUrl: String,
        merchantAvailableShippingZones: [String],
        merchantId: String,
        id: String
    ) {
        self.version = version
        self.subFolderId = subFolderId
        self.initScreen = initScreen
        self.product = product
        self.applicationId = applicationId
        self.theme = theme
        self.pspPublishableKey = pspPublishableKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.type = type
        self.externalTracker = externalTracker
        self.externalTrackerId = externalTrackerId
        self.merchantLogoUrl = merchantLogoUrl
        self.merchantName = merchantName
        self.merchantSupportUrl = merchantSupportUrl
        self.pspAccountId = pspAccountId
        self.channel = channel
        self.dispatchIsReseller = dispatchIsReseller
        self.hiddenPaymentMethods = hiddenPaymentMethods
        self.name = name
        self.merchantTermsUrl = merchantTermsUrl
        self.merchantAvailableShippingZones = merchantAvailableShippingZones
        self.merchantId = merchantId
        self.id = id
    }
}

extension Content {
    static func mock(
        version: String = "v1",
        subFolderId: String = "001",
        initScreen: InitScreen = .mock(),
        product: Product = .mock(),
        applicationId: String = "64b86c02453510acde70250f",
        theme: Theme = .mock(),
        pspPublishableKey: String = "pk_test_51N1KAeEjp5mSDYV0ckoD5EP9Rj1CdaY7eBBsRBGE1XVKL0xQi7KjPHaJqsseafCLWHGUklT94vnUlm63Yl21AC1i00yOj66TSI",
        createdAt: String = "2023-07-20T14:53:54.101Z",
        updatedAt: String = "2024-02-14T17:51:06.320Z",
        type: String = "Content",
        externalTracker: String = "SNAPCHAT",
        externalTrackerId: String = "430a264c-ed29-42ba-8284-615c59777b87",
        merchantLogoUrl: String = "https://www.fintechfutures.com/files/2018/01/Ledger-logo.jpg",
        merchantName: String = "Dispatch CSV Demo - DEMO",
        merchantSupportUrl: String = "https://ledger.com/support",
        pspAccountId: String = "",
        channel: String = "Dispatch",
        dispatchIsReseller: Bool = false,
        hiddenPaymentMethods: [String] = [],
        name: String = "undefined-null",
        merchantTermsUrl: String = "https://dispatch.co",
        merchantAvailableShippingZones: [String] = [],
        merchantId: String = "64b5864419f8dfb43888f07b",
        id: String = "64dabb5fa62014aafefbe89e"
    ) -> Self {
        Content(
            version: version,
            subFolderId: subFolderId,
            initScreen: initScreen,
            product: product,
            applicationId: applicationId,
            theme: theme,
            pspPublishableKey: pspPublishableKey,
            createdAt: createdAt,
            updatedAt: updatedAt,
            type: type,
            externalTracker: externalTracker,
            externalTrackerId: externalTrackerId,
            merchantLogoUrl: merchantLogoUrl,
            merchantName: merchantName,
            merchantSupportUrl: merchantSupportUrl,
            pspAccountId: pspAccountId,
            channel: channel,
            dispatchIsReseller: dispatchIsReseller,
            hiddenPaymentMethods: hiddenPaymentMethods,
            name: name,
            merchantTermsUrl: merchantTermsUrl,
            merchantAvailableShippingZones: merchantAvailableShippingZones,
            merchantId: merchantId,
            id: id
        )
    }
}
