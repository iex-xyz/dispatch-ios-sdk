import Foundation

enum JSONValue: Codable, Hashable {
    case string(String)
    case number(Double)
    case boolean(Bool)
    case array([JSONValue?])
    case object([String: JSONValue?])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let bool = try? container.decode(Bool.self) {
            self = .boolean(bool)
        } else if let array = try? container.decode([JSONValue?].self) {
            self = .array(array)
        } else if let object = try? container.decode([String: JSONValue?].self) {
            self = .object(object)
        } else {
            throw DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode JSONValue."))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
}

// Add expressible by literal initializers for convenience
extension JSONValue: ExpressibleByStringLiteral, ExpressibleByBooleanLiteral, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }

    init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }

    init(floatLiteral value: Double) {
        self = .number(value)
    }

    init(integerLiteral value: Int) {
        self = .number(Double(value))
    }

    init(arrayLiteral elements: JSONValue?...) {
        self = .array(elements)
    }

    init(dictionaryLiteral elements: (String, JSONValue?)...) {
        self = .object(Dictionary(uniqueKeysWithValues: elements))
    }
}
