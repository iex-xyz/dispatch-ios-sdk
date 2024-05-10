import Foundation

struct PromoCode: Codable {
    let code: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case code
        case description
    }
}

