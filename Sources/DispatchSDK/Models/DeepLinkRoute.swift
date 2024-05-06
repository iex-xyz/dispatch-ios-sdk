import Foundation

public enum DeepLinkRoute {
    public enum Mock {
        case orderSuccess
    }
    case checkout(_ id: String)
    case leadgen(_ id: String)
    case mock(_ mock: Mock)
}

extension DeepLinkRoute {
    public static var testYetiCheckout: Self {
        return .checkout("652ef22e5599070b1b8b9986")
    }
    public static var testYetiMugCheckout: Self {
        return .checkout("65dcf44b774d442bb689067a")
    }

    public static var testMysteryCheckout: Self {
        return .checkout("65df6f3a4ae12e4cec1d3eb2")
    }
    
    public static var testQuantityPicker: Self {
        return .checkout("661e8c14116bdd2bfe95eb29")
    }
    
    public static var testTidePods: Self {
        return .checkout("651f1702562b1a728e606392")
    }

    public static var testNanoX: Self {
        return .checkout("64dabb5fa62014aafefbe89e")
    }

    public static var testFaitesUnDonPour: Self {
        return .checkout("657207c8281f971e15759444")
    }

    public static var testSuccessfulOrder: Self {
        return .mock(.orderSuccess)
    }
}
