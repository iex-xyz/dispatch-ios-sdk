import UIKit
import SwiftUI
import Foundation

protocol Coordinator: AnyObject {
    func start()
    func start(with route: DeepLinkRoute)
}
