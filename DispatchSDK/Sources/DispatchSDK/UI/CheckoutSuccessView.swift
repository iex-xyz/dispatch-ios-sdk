import SwiftUI
import Combine
import UIKit
import QuartzCore
import CoreGraphics

class CheckoutSuccessViewController: UIViewController {
    
    lazy var confettiLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()

        emitterLayer.emitterCells = confettiCells
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.minY - 500)
        emitterLayer.emitterSize = CGSize(width: view.bounds.size.width, height: view.safeAreaInsets.top + 200)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.frame = view.bounds
        emitterLayer.backgroundColor = UIColor.clear.cgColor

        emitterLayer.beginTime = CACurrentMediaTime()
        return emitterLayer
    }()

    lazy var confettiTypes: [ConfettiType] = {
        let confettiColors = [
            UIColor(Color.dispatchBlue)
        ]

        return [ConfettiPosition.foreground, ConfettiPosition.background].flatMap { position in
            return [ConfettiShape.rectangle, ConfettiShape.circle].flatMap { shape in
                return confettiColors.map { color in
                    return ConfettiType(color: color, shape: shape, position: position)
                }
            }
        }
    }()

    lazy var confettiCells: [CAEmitterCell] = {
        return confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.beginTime = 0.1
            cell.birthRate = 10
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.lifetime = 3
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 30
            cell.yAcceleration = 150

            return cell
        }
    }()
    
    lazy var rootController: UIHostingController<CheckoutSuccessView> = {
        .init(rootView: CheckoutSuccessView(viewModel: viewModel))
    }()
    
    let viewModel: CheckoutSuccessViewModel
    
    init(viewModel: CheckoutSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(rootController)
        view.addSubview(rootController.view)
        
        rootController.didMove(toParent: self)
        rootController.view.translatesAutoresizingMaskIntoConstraints = false
        rootController.view.backgroundColor = .clear

        NSLayoutConstraint.activate([
            rootController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootController.view.topAnchor.constraint(equalTo: view.topAnchor),
            rootController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.addSublayer(confettiLayer)
    }
}

struct CheckoutSuccessView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutSuccessViewModel
    
    var body: some View {
        VStack {
            // TODO: How are we doing headers? UINavigationBar?
            if let imageUrlString = viewModel.checkout.product.baseImages.first, let url = URL(string: imageUrlString) {
                AsyncImage(url: url, content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    ProgressView()
                        .foregroundStyle(.primary)
                })
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipShape(Rectangle())
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Success!")
                            .font(.footnote.bold())
                            .foregroundStyle(Color.dispatchBlue)
                        Text("Your order is on its way.")
                            .font(.title2.bold())
                        Text("")
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    Divider()
                    CheckoutOverviewDetailRow(title: "Order Number", showChevron: false) {
                        Text(viewModel.orderNumber)
                            .minimumScaleFactor(0.5)
                            .truncationMode(.middle)
                            .lineLimit(1)
                    } handler: {}
                    Divider()
                    CheckoutOverviewDetailRow(title: "Shipping Address", showChevron: false) {
                        Text(viewModel.shippingAddress.formattedString)
                            .multilineTextAlignment(.leading)
                    } handler: {}
                    Divider()
                    if let billingInfo = viewModel.billingInfo {
                        CheckoutOverviewDetailRow(title: "Payment", showChevron: false) {
                            HStack {
                                Text(billingInfo.cardPreview)
                                if let icon = billingInfo.cardType.iconImage {
                                    Image(uiImage: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 16)
                                }
                            }
                            .foregroundStyle(.primary)
                        } handler: {}
                        Divider()
                    }
                }
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    viewModel.onMainCtaButtonTapped()
                }) {
                    Text("Keep Shopping") // TODO: Where does this come from?
                }
                .buttonStyle(PrimaryButtonStyle())
                FooterView()
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let viewModel = CheckoutSuccessViewModel(
        checkout: .mock(),
        orderNumber: "C0192329328",
        shippingAddress: "1234 Town\nBrooklyn NY 11211",
        payment: "4242 [VISA]"
    )
    return CheckoutSuccessView(
        viewModel: viewModel
    )
}
