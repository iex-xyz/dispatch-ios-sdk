import SwiftUI
import UIKit

class NoRotationNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}


@available(iOS 15.0, *)
class LandscapeOverlayView: UIView {
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Rotate Your Device to Shop"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(iconImageView)
        blurEffectView.contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func updateOrientation(_ orientation: UIDeviceOrientation) {
        switch orientation {
        case .landscapeLeft:
            iconImageView.image = UIImage(systemName: "rotate.right.fill")
        case .landscapeRight:
            iconImageView.image = UIImage(systemName: "rotate.left.fill")
        default:
            iconImageView.image = nil
        }
    }
}
@available(iOS 15.0, *)
class NoRotationHostingController<Content: View>: UIHostingController<Content> {
    private var landscapeOverlayView: LandscapeOverlayView?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLandscapeOverlay()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orientationDidChange()
    }
    
    private func setupLandscapeOverlay() {
        landscapeOverlayView = LandscapeOverlayView(frame: view.bounds)
        landscapeOverlayView?.isHidden = true
        if let overlay = landscapeOverlayView {
            view.addSubview(overlay)
        }
    }
    
    @objc private func orientationDidChange() {
        guard let overlay = landscapeOverlayView else { return }
        let orientation = UIDevice.current.orientation
        if orientation.isLandscape {
            overlay.isHidden = false
            overlay.updateOrientation(orientation)
        } else {
            overlay.isHidden = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        landscapeOverlayView?.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

}
