import Foundation


extension Dictionary where Key == String, Value == AnyHashable {
    func toAnyEncodable() -> [String: AnyEncodable] {
        var result: [String: AnyEncodable] = [:]
        for (key, value) in self {
            guard let value = value as? Encodable else {
                continue
            }
            result[key] = AnyEncodable(value)
        }
        return result
    }
}

struct CreateEventRequest: GraphQLRequest {
    struct Response: Codable {
        let id: String
    }
    
    struct Params: Encodable {
        let eventName: String
        let data: DataWrapper
        let orderId: String?
        
        struct DataWrapper: Encodable {
            let content: [String: AnyEncodable]
            
            init(content: [String: AnyHashable]) {
                self.content = content.toAnyEncodable()
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(content, forKey: .content)
            }
            
            enum CodingKeys: String, CodingKey {
                case content = "data"
            }
        }
    }

    var input: Params
    
    typealias Output = Response
    typealias Input = Params

    var operationString: String {
        """
        mutation CreateEvent($eventName: String!, $orderId: String, $data: JSON) {
            createCheckoutEvent(
                eventName: $eventName,
                orderId: $orderId,
                data: $data
            ) {
                id
            }
        }
        """
    }

    init(event: LoggedDispatchEvent, orderId: String?) {
        self.input = Params(
            eventName: event.event.name,
            data: Params.DataWrapper(content: event.event.params),
            orderId: orderId
        )
    }
}
