import Foundation

public struct InitScreen: Codable, Equatable {
    let buttonText: String
    let imageUrls: [String]
    let linkoutUrl: String?
    let logoUrl: String?
    let successImageUrl: String?
    let videoUrl: String?
    let footerText: String?
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
