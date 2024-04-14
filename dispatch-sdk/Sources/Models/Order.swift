import Foundation

struct Order: Codable {
    let availableShippingMethods: [ShippingMethod]?
    let confirmationOrderId: String?
    let confirmationOrderUrl: String?
    let createdAt: Date?
    let distributionId: String?
    let id: String
    let lineItems: [LineItem]
    let merchantIsDispatch: Bool?
    let nextPaymentAction: NextPaymentAction?
    let paymentType: PaymentType
    let productCost: Float
    let selectedShippingMethod: String?
    let shippingCost: Float
    let status: OrderStatus
    let taxCost: Float
    let totalCost: Float
    let updatedAt: Date?
}
