import Foundation

internal enum Environment {
    case demo
    case staging
    case production

    var baseURL: URL {
        switch self {
        case .demo:
            return URL(string: "https://checkout-api-demo.dispatch.co/graphql")!
        case .staging:
            return URL(string: "https://checkout-api-staging.dispatch.co/graphql")!
        case .production:
            return URL(string: "https://checkout-api.dispatch.co/graphql")!
        }
    }
}


