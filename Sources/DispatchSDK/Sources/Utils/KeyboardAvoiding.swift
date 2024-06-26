import Combine
import SwiftUI

@available(iOS 15.0, *)
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

@available(iOS 15.0, *)
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

@available(iOS 15.0, *)
struct KeyboardAvoiding: ViewModifier {
    @State private var keyboardActiveAdjustment: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
                EmptyView().frame(height: 0)
            }
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardActiveAdjustment = min($0, 12)
            }
    }
}

@available(iOS 15.0, *)
extension View {
    func keyboardAvoiding() -> some View {
        modifier(KeyboardAvoiding())
    }
}
