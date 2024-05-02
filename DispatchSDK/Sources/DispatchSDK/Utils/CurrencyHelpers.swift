import Foundation

struct CurrencyHelpers {
    static private let formatter = NumberFormatter()

    static func formatCentsToDollars(
        cents: Int,
        currencyCode: String = "USD",
        forceDecimalSeparator: Bool = false,
        hideCurrencySymbol: Bool = false
    ) -> String {
        let locale: String
        if forceDecimalSeparator {
            locale = "en_US"
        } else if currencyCode == "EUR" {
            locale = "fr_EU"
        } else {
            locale = "en_US"
        }
        
        let amount = Double(cents) / 100.0
        formatter.locale = Locale(identifier: locale)
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if hideCurrencySymbol {
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: amount)) ?? ""
        } else {
            formatter.numberStyle = .currency
            formatter.currencyCode = currencyCode
            return formatter.string(from: NSNumber(value: amount)) ?? ""
        }
    }
}
