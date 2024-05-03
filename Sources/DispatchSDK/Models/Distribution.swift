import Foundation

public struct Distribution: Codable, Equatable {
    public let version: String
    public let subFolderId: String
    public let initScreen: InitScreen
    public let product: Product
    public let applicationId: String
    public let theme: Theme
    public let pspPublishableKey: String
    public let createdAt: String
    public let updatedAt: String
    public let type: String
    public let merchantName: String
    public let channel: String
    public let dispatchIsReseller: Bool
    public let hiddenPaymentMethods: [String]
    public let name: String
    public let psp: String
    public let merchantId: String
    public let id: String
}

extension Distribution {
    static func mock(
        version: String = "1.0",
        subFolderId: String = "subfolder123",
        initScreen: InitScreen = InitScreen.mock(),
        product: Product = Product.mock(),
        applicationId: String = UUID().uuidString,
        theme: Theme = .mock(),
        pspPublishableKey: String = "123456789",
        createdAt: String = Date.now.ISO8601Format(),
        updatedAt: String = Date.now.ISO8601Format(),
        type: String = "distribution",
        merchantName: String = "mock merchant",
        channel: String = "channel",
        dispatchIsReseller: Bool = false,
        hiddenPaymentMethods: [String] = [],
        name: String = "Mock Distribution",
        psp: String = "psp",
        merchantId: String = "merchant-id",
        id: String = UUID().uuidString
    ) -> Distribution {
        return Distribution(
            version: version,
            subFolderId: subFolderId,
            initScreen: initScreen,
            product: product,
            applicationId: applicationId,
            theme: theme,
            pspPublishableKey: pspPublishableKey,
            createdAt: createdAt,
            updatedAt: createdAt,
            type: type,
            merchantName: merchantName,
            channel: channel,
            dispatchIsReseller: dispatchIsReseller,
            hiddenPaymentMethods: hiddenPaymentMethods,
            name: name,
            psp: psp,
            merchantId: merchantId,
            id: id
        )
    }
}
