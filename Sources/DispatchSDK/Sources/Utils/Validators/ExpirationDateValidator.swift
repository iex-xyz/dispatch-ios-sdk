import Foundation

class ExpirationDateValidator {
    static func validateExpirationDate(_ date: String) -> Bool {
        let components = date.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]),
              month >= 1 && month <= 12 else {
            return false
        }
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        // Check if the expiration date is in the future
        if year > currentYear || (year == currentYear && month >= currentMonth) {
            return true
        }
        
        return false
    }
}

