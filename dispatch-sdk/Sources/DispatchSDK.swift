import UIKit
import Foundation

public struct DispatchSDK {
    public static func present() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let testViewModel = CheckoutViewModel()
        let viewModel: ProductMediaViewModel = ProductMediaViewModel(images: [
            "https://fastly.picsum.photos/id/868/400/300.jpg?hmac=5C4AshIrWvAN9A0sY5Zgv6X_MVpHWivtCnxEMLRW8OE",
            "https://fastly.picsum.photos/id/889/400/300.jpg?hmac=bnjifYNFcybzu2SpzMsIa7Od1iOA9Jjz7imYROcHw-Q",
            "https://fastly.picsum.photos/id/287/400/300.jpg?hmac=WOrUCUFbXzGkc4Ea1v9o-f4eG2KLgGBRRn2QOQZB_7Y",
            "https://fastly.picsum.photos/id/891/400/300.jpg?hmac=nHUVgyyOABMgUtxMImL3NrbL2GZR3Xl-ATduX-QXiPI",
        ])
        let rootViewController = ProductOverviewViewController(viewModel: viewModel)
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        rootNavigationController.modalPresentationStyle = .fullScreen

        keyWindow.rootViewController?.present(rootNavigationController, animated: true)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let viewModel: VariantPickerViewModel = VariantPickerViewModel(variations: [
//                .random(),
//                .random(),
//                .random(),
//                .random(),
//                .random(),
//                .random(),
//                .random(),
//                .random(),
//            ])
//            let vc = VariantPickerViewController(viewModel: viewModel)
//            rootNavigationController.pushViewController(vc, animated: true)
//        }
    }
}
