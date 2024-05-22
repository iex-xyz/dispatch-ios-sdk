import Foundation

public enum DispatchRoute {
    public enum Mock {
        case orderSuccess
    }
    case checkout(_ id: String)
}
