import Foundation

public enum DeepLinkRoute {
    case checkout(_ id: String)
    case leadgen(_ id: String)
}

extension DeepLinkRoute {
    public static var testYetiCheckout: Self {
        return .checkout("652ef22e5599070b1b8b9986")
    }
    
    public static var testMysteryCheckout: Self {
        return .checkout("65df6f3a4ae12e4cec1d3eb2")
    }
    
    public static var testQuantityPicker: Self {
        return .checkout("661e8c14116bdd2bfe95eb29")
    }
}
