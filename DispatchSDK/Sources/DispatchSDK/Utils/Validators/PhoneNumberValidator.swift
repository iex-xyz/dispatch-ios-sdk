import Foundation

class PhoneNumberValidator {
    static func validatePhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^\\(?(\\d{3})\\)?[- ]?(\\d{3})[- ]?(\\d{4})$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: number)
    }
}
