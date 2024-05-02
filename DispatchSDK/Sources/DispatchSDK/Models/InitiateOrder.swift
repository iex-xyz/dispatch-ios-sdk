import Foundation

struct InitiateOrder: Codable {
    let id: String
    let status: OrderStatus
    let totalCost: Int
    let productCost: Int
    let shippingCost: Int
    let taxCost: Int
    
    init(
        id: String,
        status: OrderStatus,
        totalCost: Int,
        productCost: Int,
        shippingCost: Int,
        taxCost: Int
    ) {
        self.id = id
        self.status = status
        self.totalCost = totalCost
        self.productCost = productCost
        self.shippingCost = shippingCost
        self.taxCost = taxCost
    }
}

extension InitiateOrder {
    static func mock(
        id: String = UUID().uuidString,
        status: OrderStatus = .inProgress,
        totalCost: Int = 0,
        productCost: Int = 0,
        shippingCost: Int = 0,
        taxCost: Int = 0
    ) -> InitiateOrder {
        return .init(
            id: id,
            status: status,
            totalCost: totalCost,
            productCost: productCost,
            shippingCost: shippingCost,
            taxCost: taxCost
        )
    }
}
