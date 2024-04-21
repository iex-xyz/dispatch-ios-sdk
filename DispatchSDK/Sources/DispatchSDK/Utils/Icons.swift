import SwiftUI

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
        static var amex = Image("card-amex", bundle: .module)
        static var `default` = Image("card-default", bundle: .module)
        static var discover = Image("card-discover", bundle: .module)
        static var dinersClub = Image("card-diners-club", bundle: .module)
        static var jcb = Image("card-jcb", bundle: .module)
        static var mastercard = Image("card-mastercard", bundle: .module)
        static var unionpay = Image("card-unionpay", bundle: .module)
        static var visa = Image("card-visa", bundle: .module)
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
