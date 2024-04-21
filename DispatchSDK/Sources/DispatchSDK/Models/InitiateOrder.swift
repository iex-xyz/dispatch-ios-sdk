import Foundation

struct InitiateOrder: Codable {
    let id: String
    let status: OrderStatus
}

extension InitiateOrder {
    static func mock(
        id: String = UUID().uuidString,
        status: OrderStatus = .inProgress
    ) -> InitiateOrder {
        return .init(
            id: id,
            status: status
        )
    }
}
