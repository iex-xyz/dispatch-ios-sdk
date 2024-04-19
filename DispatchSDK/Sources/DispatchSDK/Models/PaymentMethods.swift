import Foundation

enum PaymentMethods: String, Codable {
  case applePay = "APPLE_PAY"
  case creditCard = "CREDIT_CARD"
  case googlePay = "GOOGLE_PAY"
  case stripeLink = "STRIPE_LINK"
}

