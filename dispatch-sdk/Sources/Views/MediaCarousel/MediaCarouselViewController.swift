import UIKit
import Combine
import Foundation

class MediaCarouselViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section: Hashable {
        case carousel
        case minimap
    }
    
    enum Item: Hashable {
        case image(String)
        case imagePreview(String)
    }

    let viewModel: ProductMediaViewModel

    private(set) lazy var collectionView = createCollectionView()
    private(set) lazy var layout: UICollectionViewCompositionalLayout = createLayout()
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> =  setupDiffableDataSource()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: ProductMediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        viewModel
            .images
            .publisher
            .sink { [weak self] _ in
                self?.updateData()
            }
            .store(in: &cancellables)
    }
    
    func invalidateLayout() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        layout.configuration = configuration
    }
    
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.isPagingEnabled = true

        return collectionView
    }
    
    // MARK: Layouts
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] idx, env in
            return self?.section(for: .carousel, environment: env)
        }, configuration: config)
        
        return layout
    }
    
    func section(for section: Section, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch section {
        case .carousel:
            return carouselSection(for: environment)
        case .minimap:
            fatalError("Not implemented")
        }
    }
    
    func setupDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let imageRegistration = UICollectionView.CellRegistration<MediaCarouselLargeImageCell, Item> { [weak self] cell, indexPath, item in
            guard let self, case let .image(urlString) = item, let url = URL(string: urlString) else {
                return
            }
            
            cell.updateURL(url)
            
            cell.backgroundConfiguration = .clear()
        }
        
        let imagePreviewRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { [weak self] cell, indexPath, item in
            guard let self, case let .imagePreview(id) = item else {
                return
            }
            
            cell.backgroundConfiguration = .clear()
            cell.backgroundColor = .red
        }

        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: imageRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case .imagePreview:
                return collectionView.dequeueConfiguredReusableCell(using: imagePreviewRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        }
        
        return dataSource

    }
    
    private func carouselSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    
    func updateData(animated: Bool = true) {
        let snapshot = createSnapshot()
        self.dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([.carousel])
        snapshot.appendItems(viewModel.images.map { .image($0) }, toSection: .carousel)

        return snapshot
    }
    
    func didSelect(item: Item, at indexPath: IndexPath) {
        
    }

    func didDeselect(item: Item, at indexPath: IndexPath) {
        
    }

    func didHighlight(item: Item, at indexPath: IndexPath) {
        
    }

    func didUnhighlight(item: Item, at indexPath: IndexPath) {
        
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        didHighlight(item: item, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        didUnhighlight(item: item, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        didSelect(item: item, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        didDeselect(item: item, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        //
    }
    
    
    // MARK: Scroll handlers
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
                             y: scrollView.bounds.height / 2)
        if let indexPath = collectionView.indexPathForItem(at: center), indexPath.item != viewModel.currentIndex {
            viewModel.onCurrentIndexDidChange(indexPath.item)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}

