import SwiftUI

struct Icons {
    
    static var poweredByDispatchDark = Image("icon-poweredbydispatch-dark", bundle: .main)
    static var poweredByDispatchLight = Image("icon-poweredbydispatch-light", bundle: .main)
    static var poweredByStripeDark = Image("icon-poweredbystripe-dark", bundle: .main)
    static var poweredByStripeLight = Image("icon-poweredbystripe-light", bundle: .main)

    static var lock = Image("icon-lock", bundle: .main)
    static var closeDark = Image("icon-close-default-dark", bundle: .main)
    static var closeLight = Image("icon-close-default-light", bundle: .main)

    static var bagDark = Image("icon-bag-dark", bundle: .main)
    static var bagLight = Image("icon-bag-light", bundle: .main)

    struct Card {
        static var amex = Image("card-amex", bundle: .main)
        static var `default` = Image("card-default", bundle: .main)
        static var discover = Image("card-discover", bundle: .main)
        static var dinersClub = Image("card-diners-club", bundle: .main)
        static var jcb = Image("card-jcb", bundle: .main)
        static var mastercard = Image("card-mastercard", bundle: .main)
        static var unionpay = Image("card-unionpay", bundle: .main)
        static var visa = Image("card-visa", bundle: .main)
    }
    
    struct Payment {
        static var applePayLight = Image("payment-applepay-light", bundle: .main)
        static var applePayDark = Image("payment-applepay-dark", bundle: .main)
        static var googlePayLight = Image("payment-gpay-light", bundle: .main)
        static var googlePayDark = Image("payment-gpay-dark", bundle: .main)
        static var cardLight = Image("payment-card-light", bundle: .main)
        static var cardDark = Image("payment-card-dark", bundle: .main)
        static var shopPayLight = Image("payment-shoppay-light", bundle: .main)
        static var shopPayDark = Image("payment-shoppay-dark", bundle: .main)

        // MARK: Badges
        static var applePayBadgeLight = Image("payment-badge-applepay-light", bundle: .main)
        static var applePayBadgeDark = Image("payment-badge-applepay-dark", bundle: .main)
        static var googlePayBadgeLight = Image("payment-badge-gpay-light", bundle: .main)
        static var googlePayBadgeDark = Image("payment-badge-gpay-dark", bundle: .main)

    }
}
