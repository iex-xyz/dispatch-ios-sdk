import Foundation

struct Distribution: Codable, Equatable {
    let version: String
    let subFolderId: String
    let initScreen: InitScreen
    let product: Product
    let applicationId: String
    let theme: Theme?
    let pspPublishableKey: String
    let createdAt: String
    let updatedAt: String
    let type: String
    let merchantName: String
    let channel: String
    let dispatchIsReseller: Bool
    let hiddenPaymentMethods: [String]
    let name: String
    let psp: String
    let merchantId: String
    let id: String
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
