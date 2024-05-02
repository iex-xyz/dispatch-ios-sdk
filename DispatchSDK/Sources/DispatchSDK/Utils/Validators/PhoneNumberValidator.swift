import Foundation

struct PhoneNumberRules: Codable {
    let mask: String
    let regex: String
    let placeholder: String
}

class PhoneNumberValidator {
    private static var phoneNumberRules: [String: PhoneNumberRules] = [:]
    private static var areRulesLoaded = false
    
    static func rules(for country: Country) -> PhoneNumberRules? {
        if !areRulesLoaded {
            loadPhoneNumberRules()
        }
        
        return phoneNumberRules[country.code]
    }
    
    private static func loadPhoneNumberRules() {
        guard let url = Bundle.module.url(forResource: "phone_number_rules", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let rules = try? JSONDecoder().decode([String: PhoneNumberRules].self, from: data) else {
            return
        }
        phoneNumberRules = rules
        areRulesLoaded = true
    }
    
    static func validatePhoneNumber(_ number: String, country: Country) -> Bool {

        let phoneRegex = rules(for: country)?.regex ?? "^\\+1 \\(\\d{3}\\) \\d{3}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: number)
    }
    
    static func stripPhoneNumberDecorators(_ number: String) -> String {
        return number.filter { $0.isNumber || $0 == "+" }
    }
}
