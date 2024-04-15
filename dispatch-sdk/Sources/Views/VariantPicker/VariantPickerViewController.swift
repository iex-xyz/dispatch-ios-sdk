import Foundation
import SwiftUI
import Combine
import UIKit

class VariantPickerViewModel: ObservableObject {
    @Published var variations: [Variation]
    @Published var selectedVariation: Variation?
    
    init(variations: [Variation], selectedVariation: Variation? = nil) {
        self.variations = variations
        self.selectedVariation = selectedVariation
    }
    
    func onVariationTapped(_ variation: Variation) {
        guard 
            let quantityAvailable = variation.quantityAvailable,
            quantityAvailable > 0
        else {
            return
        }

        if selectedVariation != variation {
            selectedVariation = variation
        }
    }
}

class VariationCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .blue
                contentView.layer.borderColor = UIColor.white.cgColor
                contentView.layer.borderWidth = 2
                checkmarkImageView.isHidden = false
            } else {
                contentView.backgroundColor = .lightGray
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.borderWidth = 0
                checkmarkImageView.isHidden = true
            }
        }
    }
    
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                self.backgroundColor = .white.withAlphaComponent(0.25)
                self.label.alpha = 1
            } else {
                self.backgroundColor = .clear
                self.label.alpha = 0.5
            }
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.textColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(label)
        contentView.addSubview(checkmarkImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),

            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            checkmarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with variation: Variation) {
        label.text = variation.id
        isEnabled = (variation.quantityAvailable ?? 0) > 0
    }
}

class VariantPickerViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section: Hashable {
        case variants
    }
    
    enum Item: Hashable {
        case variation(Variation)
    }

    let viewModel: VariantPickerViewModel

    private(set) lazy var collectionView = createCollectionView()
    private(set) lazy var layout: UICollectionViewCompositionalLayout = createLayout()
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> =  setupDiffableDataSource()

    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: VariantPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        Publishers.CombineLatest(
            viewModel.variations.publisher,
            viewModel.selectedVariation.publisher
        )
        .sink { [weak self] _ in
            self?.updateData()
            
        }
        .store(in: &cancellables)
        
        updateData()
    }
    
    func invalidateLayout() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
    }
    
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false

        return collectionView
    }
    
    // MARK: Layouts
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] idx, env in
            return self?.section(for: .variants, environment: env)
        }, configuration: config)
        
        return layout
    }
    
    func section(for section: Section, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch section {
        case .variants:
            return createSection(withColumns: 2)
        }
    }
    
    func setupDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let variationRegistration = UICollectionView.CellRegistration<VariationCollectionViewCell, Item> { cell, indexPath, item in
            guard case let .variation(variation) = item else {
                return
            }
            
            cell.contentConfiguration = UIHostingConfigurationBackport {
                ZStack {
                    Text(variation.id)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.blue))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .margins(.all, 0)

            cell.backgroundConfiguration = .clear()
        }
        

        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .variation:
                return collectionView.dequeueConfiguredReusableCell(using: variationRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        }
        
        return dataSource

    }
    
    func createSection(withColumns columns: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.absolute(40)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }

    func updateData(animated: Bool = true) {
        let snapshot = createSnapshot()
        self.dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([.variants])
        snapshot.appendItems(viewModel.variations.map { .variation($0) }, toSection: .variants)

        return snapshot
    }
    
    func didSelect(item: Item, at indexPath: IndexPath) {
        let vc = VariantPickerViewController(viewModel: viewModel)
        vc.isModalInPresentation = true
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(vc, animated: true, completion: nil)
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

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}
