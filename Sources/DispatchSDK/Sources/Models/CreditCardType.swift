import Foundation
import UIKit

enum CreditCardType: CaseIterable {
    case visa
    case masterCard
    case americanExpress
    case discover
    case dinersClub
    case jcb
    
    var iconImage: UIImage? {
        switch self {
        case .visa:
            Icons.Card.visa
        case .masterCard:
            Icons.Card.mastercard
        case .americanExpress:
            Icons.Card.amex
        case .discover:
            Icons.Card.discover
        case .dinersClub:
            Icons.Card.dinersClub
        case .jcb:
            Icons.Card.jcb
        }
    }

    var format: String {
        switch self {
        case .visa, .masterCard, .discover:
            return "#### #### #### ####"
        case .americanExpress:
            return "#### ###### #####"
        case .dinersClub:
            return "#### ###### ####"
        case .jcb:
            // NOTE: JCB cards can also have 15-16 digits like Diners.
            return "#### #### #### ####"
        }
    }

    static func detect(from number: String) -> CreditCardType? {
        let formattedNumber = number.filter { $0.isWholeNumber }
        
        // Match card type based on number prefixes
        if formattedNumber.hasPrefix("4") {
            return .visa
        } else if formattedNumber.hasPrefix("5") {
            return .masterCard
        } else if formattedNumber.hasPrefix("34") || formattedNumber.hasPrefix("37") {
            return .americanExpress
        } else if formattedNumber.hasPrefix("6") {
            return .discover
        } else if formattedNumber.hasPrefix("3") {
            return .dinersClub
        } else if formattedNumber.hasPrefix("35") {
            return .jcb
        }
        return nil
    }
}


extension String {
    func formatAsCreditCard() -> String {

        guard let cardType = CreditCardType.detect(from: self) else {
            return self // Return original if no card type matches
        }
        let mask = cardType.format
        let digits = self.filter { $0.isNumber }
        var formattedString = ""
        var digitIndex = 0

        for char in mask {
            if digitIndex >= digits.count {
                break
            }
            if char == "#" {
                formattedString.append(digits[digitIndex])
                digitIndex += 1
            } else {
                formattedString.append(char)
            }
        }

        return formattedString
    }
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return String(self[startIndex..<endIndex])
    }
}


extension Character {
    var isNumber: Bool {
        return isASCII && "0"..."9" ~= self
    }
}


