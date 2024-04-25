import Foundation

class PhoneNumberValidator {
    static func validatePhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^\\+1 \\(\\d{3}\\) \\d{3}-\\d{4}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: number)
    }
    
    static func stripPhoneNumberDecorators(_ number: String) -> String {
        return number.filter { $0.isNumber || $0 == "+" }
    }
}
