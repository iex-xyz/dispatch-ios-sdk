import SwiftUI

@available(iOS 15.0, *)
struct Icons {
    
    @Preference(\.theme) static var theme
    
    static var poweredByDispatchDark = Image("icon-poweredbydispatch-dark", bundle: .module)
    static var poweredByDispatchLight = Image("icon-poweredbydispatch-light", bundle: .module)
    static var poweredByDispatch: Image {
        return theme.mode == .dark ? poweredByDispatchDark : poweredByDispatchLight
    }

    
    static var poweredByStripeDark = Image("icon-poweredbystripe-dark", bundle: .module)
    static var poweredByStripeLight = Image("icon-poweredbystripe-light", bundle: .module)
    static var poweredByStripe: Image {
        return theme.mode == .dark ? poweredByStripeDark : poweredByStripeLight
    }


    static var lock = Image("icon-lock", bundle: .module)
    static var close: Image {
        return theme.mode == .dark ? closeDark : closeLight
    }
    static var closeDark = Image("icon-close-default-dark", bundle: .module)
    static var closeLight = Image("icon-close-default-light", bundle: .module)

    static var bagDark = Image("icon-bag-dark", bundle: .module)
    static var bagLight = Image("icon-bag-light", bundle: .module)

    struct Card {
        static var amex = UIImage(named: "card-amex", in: .module, with: nil)
        static var `default` = UIImage(named: "card-default", in: .module, with: nil)
        static var discover = UIImage(named: "card-discover", in: .module, with: nil)
        static var dinersClub = UIImage(named: "card-diners-club", in: .module, with: nil)
        static var jcb = UIImage(named: "card-jcb", in: .module, with: nil)
        static var mastercard = UIImage(named: "card-mastercard", in: .module, with: nil)
        static var unionpay = UIImage(named: "card-unionpay", in: .module, with: nil)
        static var visa = UIImage(named: "card-visa", in: .module, with: nil)
    }
    
    struct Payment {
        static var applePayLight = Image("payment-applepay-light", bundle: .module)
        static var applePayDark = Image("payment-applepay-dark", bundle: .module)
        static var googlePayLight = Image("payment-gpay-light", bundle: .module)
        static var googlePayDark = Image("payment-gpay-dark", bundle: .module)
        static var cardLight = Image("payment-card-light", bundle: .module)
        static var cardDark = Image("payment-card-dark", bundle: .module)
        static var shopPayLight = Image("payment-shoppay-light", bundle: .module)
        static var shopPayDark = Image("payment-shoppay-dark", bundle: .module)

        // MARK: Badges
        static var applePayBadgeLight = Image("payment-badge-applepay-light", bundle: .module)
        static var applePayBadgeDark = Image("payment-badge-applepay-dark", bundle: .module)
        static var googlePayBadgeLight = Image("payment-badge-gpay-light", bundle: .module)
        static var googlePayBadgeDark = Image("payment-badge-gpay-dark", bundle: .module)

    }
}
