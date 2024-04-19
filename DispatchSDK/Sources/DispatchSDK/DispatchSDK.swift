import UIKit
import Foundation

public class DispatchSDK {
    public static var shared: DispatchSDK = .init()

    private lazy var coordinator: Coordinator = self.makeCoordinator()
    
    private func makeCoordinator() -> Coordinator {
        return MainCoordinator(
            router: RouterImp(rootController: UINavigationController())
        )
    }
    
    public func present() {
        coordinator.start()
    }
}
