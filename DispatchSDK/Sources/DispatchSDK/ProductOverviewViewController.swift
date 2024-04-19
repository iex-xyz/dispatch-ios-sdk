import Foundation
import UIKit

class ProductOverviewViewController: UIViewController {
    let viewModel: ProductMediaViewModel
    
    private lazy var carouselViewController: MediaCarouselViewController = {
        MediaCarouselViewController(viewModel: viewModel)
    }()
    
    init(viewModel: ProductMediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addChild(carouselViewController)
        view.addSubview(carouselViewController.view)
        carouselViewController.didMove(toParent: self)
        
        carouselViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            carouselViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            carouselViewController.view.heightAnchor.constraint(equalToConstant: 172)
        ])
    }
}
