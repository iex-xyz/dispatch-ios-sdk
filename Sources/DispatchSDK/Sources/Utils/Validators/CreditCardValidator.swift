import Foundation

@available(iOS 15.0, *)
class CreditCardValidator {
    // Validate credit card number using the Luhn algorithm
    static func validateCardNumber(_ number: String) -> Bool {
        let formattedNumber = number.filter { $0.isWholeNumber }
        guard formattedNumber.count >= 13 && formattedNumber.count <= 19 else {
            return false
        }

        return formattedNumber.reversed().enumerated().map {
            let digit = Int(String($1))!
            let odd = $0 % 2 == 1
            return odd ? digit * 2 : digit
        }.map {
            $0 > 9 ? $0 - 9 : $0
        }.reduce(0, +) % 10 == 0
    }

    // Detect the card type based on number prefixes and lengths
    static func detectCardType(from number: String) -> CreditCardType? {
        return CreditCardType.detect(from: number)
    }

    // Validate the security code based on card type
    static func validateSecurityCode(_ code: String, cardType: CreditCardType) -> Bool {
        switch cardType {
        case .visa, .masterCard, .discover, .jcb:
            return code.count == 3
        case .americanExpress:
            return code.count == 4
        case .dinersClub:
            return code.count == 3
        }
    }

    // Validate expiration date
    static func isDateValid(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let expiryYear = calendar.component(.year, from: date)
        let expiryMonth = calendar.component(.month, from: date)
        
        if expiryYear > currentYear {
            return true
        } else if expiryYear == currentYear {
            return expiryMonth >= currentMonth
        } else {
            return false
        }
    }
}

