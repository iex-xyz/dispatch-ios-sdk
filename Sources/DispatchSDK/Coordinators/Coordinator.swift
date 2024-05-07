import Foundation

protocol Coordinator: AnyObject {
    func start()
    func start(with route: DispatchRoute)
}
