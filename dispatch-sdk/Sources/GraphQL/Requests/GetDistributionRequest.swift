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

struct InitScreen: Codable, Equatable {
    let buttonText: String
    let imageUrls: [String]
    let linkoutUrl: String
    let logoUrl: String
    let successImageUrl: String
    let videoUrl: String
    let footerText: String
    let hasQuantitySelector: Bool
}

extension InitScreen {
    static func mock(
        buttonText: String = "Buy Now",
        imageUrls: [String] = [
            "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131043/sdk/ledger/ledger-1_tclih1.png",
            "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131043/sdk/ledger/ledger-2_p0j6ii.png",
            "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131043/sdk/ledger/ledger-3_oxxbkh.png",
            "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131043/sdk/ledger/ledger-4_boscsx.png",
            "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131043/sdk/ledger/ledger-5_i5yhd8.png"
        ],
        linkoutUrl: String = "https://dispatch.co/",
        logoUrl: String = "https://res.cloudinary.com/dispatchxyz/image/upload/v1692131476/sdk/ledger/ledger-logo-black_mxo1m2.svg",
        successImageUrl: String = "",
        videoUrl: String = "",
        footerText: String = "Sold by <a href=\"https://dispatch.co\" target=\"_blank\"><img style=\"display: inline\" src=\"https://res.cloudinary.com/dispatchxyz/image/upload/v1679324147/Chain%20Store/dispatch-logo-sm_osl4hu.svg\" width=9 height=6 />&nbsp;<b>Dispatch</b></a>. A Ledger Authorized Reseller.",
        hasQuantitySelector: Bool = false
    ) -> Self {
        InitScreen(
            buttonText: buttonText,
            imageUrls: imageUrls,
            linkoutUrl: linkoutUrl,
            logoUrl: logoUrl,
            successImageUrl: successImageUrl,
            videoUrl: videoUrl,
            footerText: footerText,
            hasQuantitySelector: hasQuantitySelector
        )
    }
}

struct GetDistributionRequest: GraphQLRequest {
    enum Response: Codable {
        case leadgen(Leadgen)
        case checkout(Checkout)
        case content(Content)
    }

    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        query {
            getDistribution(
              id: \"\(id)\",
            )
        }
        """
    }
    
    var input: Input
    let id: String
    
    init(id: String) {
        self.id = id
        self.input = [:]
    }
}


extension GetDistributionRequest.Response {
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    private enum TypeValue: String, Codable {
        case leadgen = "Leadgen"
        case checkout = "Checkout"
        case content = "Content"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(TypeValue.self, forKey: .type)
        
        switch type {
        case .leadgen:
            let leadgen = try Leadgen(from: decoder)
            self = .leadgen(leadgen)
        case .checkout:
            let checkout = try Checkout(from: decoder)
            self = .checkout(checkout)
        case .content:
            let content = try Content(from: decoder)
            self = .content(content)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .leadgen(leadgen):
            try container.encode(TypeValue.leadgen, forKey: .type)
            try leadgen.encode(to: encoder)
        case let .checkout(checkout):
            try container.encode(TypeValue.checkout, forKey: .type)
            try checkout.encode(to: encoder)
        case let .content(content):
            try container.encode(TypeValue.content, forKey: .type)
            try content.encode(to: encoder)
        }
    }
}
