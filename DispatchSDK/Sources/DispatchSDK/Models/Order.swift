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

extension Order {
    static func mock(
        availableShippingMethods: [ShippingMethod]? = nil,
        confirmationOrderId: String? = nil,
        confirmationOrderUrl: String? = nil,
        createdAt: Date? = nil,
        distributionId: String? = nil,
        id: String = "1",
        lineItems: [LineItem] = [],
        merchantIsDispatch: Bool? = nil,
        nextPaymentAction: NextPaymentAction? = nil,
        paymentType: PaymentType = .creditCard,
        productCost: Float = 0,
        selectedShippingMethod: String? = nil,
        shippingCost: Float = 0,
        status: OrderStatus = .inProgress,
        taxCost: Float = 0,
        totalCost: Float = 0,
        updatedAt: Date? = nil
    ) -> Order {
        Order(
            availableShippingMethods: availableShippingMethods,
            confirmationOrderId: confirmationOrderId,
            confirmationOrderUrl: confirmationOrderUrl,
            createdAt: createdAt,
            distributionId: distributionId,
            id: id,
            lineItems: lineItems,
            merchantIsDispatch: merchantIsDispatch,
            nextPaymentAction: nextPaymentAction,
            paymentType: paymentType,
            productCost: productCost,
            selectedShippingMethod: selectedShippingMethod,
            shippingCost: shippingCost,
            status: status,
            taxCost: taxCost,
            totalCost: totalCost,
            updatedAt: updatedAt
        )
    }
}
