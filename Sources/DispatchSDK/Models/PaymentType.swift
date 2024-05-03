import Foundation

enum PaymentType: String, Codable, CaseIterable {
  case applePay = "APPLE_PAY"
  case creditCard = "CREDIT_CARD"
  case googlePay = "GOOGLE_PAY"
  case paypal = "PAYPAL"
}

