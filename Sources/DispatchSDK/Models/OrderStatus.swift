import Foundation

enum OrderStatus: String, Codable {
    case completed = "COMPLETED"
    case error = "ERROR"
    case inProgress = "IN_PROGRESS"
    case merchantBilled = "MERCHANT_BILLED"
    case partialRefund = "PARTIAL_REFUND"
    case paymentRequiresAction = "PAYMENT_REQUIRES_ACTION"
    case refunded = "REFUNDED"
}
