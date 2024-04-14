import Foundation

struct NextPaymentAction: Codable {
    let redirectToUrl: String?

    enum CodingKeys: String, CodingKey {
        case redirectToUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.redirectToUrl = try container.decodeIfPresent(String.self, forKey: .redirectToUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(redirectToUrl, forKey: .redirectToUrl)
    }
}
