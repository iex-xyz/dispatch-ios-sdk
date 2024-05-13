import Foundation

struct PhoneNumberRules: Codable {
    let mask: String
    let regex: String
    let placeholder: String
    let countryCode: String
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
    
    static func format(for number: String, country: Country) -> String {
        var digits = number.filter { $0.isNumber }
        let rules = PhoneNumberValidator.rules(for: country)
        let mask = rules?.mask ?? "+# (###) ###-####"
        let countryCode = rules?.countryCode ?? "1"
        
        if !digits.hasPrefix(countryCode) && digits.count > countryCode.count {
            digits = (countryCode) + digits
        }
        
        var result = ""
        var index = digits.startIndex
        
        for ch in mask where index < digits.endIndex {
            if ch == "#" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
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
