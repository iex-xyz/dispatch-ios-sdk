import Foundation

enum PaymentType: String, Codable {
  case applePay = "APPLE_PAY"
  case creditCard = "CREDIT_CARD"
  case googlePay = "GOOGLE_PAY"
  case paypal = "PAYPAL"
}

