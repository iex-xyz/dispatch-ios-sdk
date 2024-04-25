import Foundation

class ExpirationDateValidator {
    static func validateExpirationDate(_ date: String) -> Bool {
        let components = date.split(separator: "/").map(String.init)
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]),
              month >= 1, month <= 12 else {
            return false
        }
        
        // Validate that the date is not in the past
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        if let dateFromInput = formatter.date(from: date), let currentDate = formatter.date(from: formatter.string(from: Date())) {
            return dateFromInput >= currentDate
        }
        return false
    }
}

