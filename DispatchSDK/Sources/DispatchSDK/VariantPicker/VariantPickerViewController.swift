import Foundation
import SwiftUI
import Combine
import UIKit
import Foundation

extension Collection {
    public func chunked(into chunkSize: Int) -> [[Element]] {
        var result = [[Element]]()
        var currentIndex = startIndex
        
        while currentIndex < endIndex {
            let endIndex = self.index(currentIndex, offsetBy: chunkSize, limitedBy: endIndex) ?? self.endIndex
            let chunk = Array(self[currentIndex..<endIndex])
            result.append(chunk)
            currentIndex = endIndex
        }
        
        return result
    }
}


struct VariantPickerView: View {
    @StateObject var viewModel: AttributeViewModel

    enum ColumnType {
        case single
        case double
    }
    @State var columns: ColumnType
    
    func DoubleColumns() -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.variations.chunked(into: 2).map { ($0, $0.map { $0.id })}, id: \.1) { variants, _ in
                    HStack(spacing: 8) {
                        ForEach(variants) { variant in
                            Button(action: {
                                viewModel.onVariationTapped(variant)
                            }) {
                                VariantPickerCell(text: variant.attributes?[viewModel.attribute.id] ?? "--", isSelected: viewModel.selectedVariant?.id == variant.id)
                            }
                            .foregroundStyle(.primary)
                            .frame(width: (geometry.size.width / 2) - 8)
                        }
                    }
                }
            }
        }
    }
    
    func SingleColumn() -> some View {
        VStack(spacing: 8) {
            ForEach(viewModel.variations) { variant in
                Button(action: {
                    viewModel.onVariationTapped(variant)
                }) {
                    VariantPickerCell(text: variant.attributes?[viewModel.attribute.id] ?? "--", isSelected: viewModel.selectedVariant?.id == variant.id)
                }
                .frame(maxWidth: .infinity)
                .background(.red)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select \(viewModel.attribute.title)")
                .font(.title3.bold())
            ScrollView {
                VStack {
                    switch columns {
                    case .single:
                        SingleColumn()
                    case .double:
                        DoubleColumns()
                    }
                }
            }
        }
        .padding()
    }
}

struct VariantPickerViewOld: UIViewControllerRepresentable {
    var viewModel: AttributeViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        VariantPickerViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}

class VariantPickerViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section: Hashable {
        case variants
    }
    
    enum Item: Hashable {
        case variation(Variation, Bool)
    }

    let viewModel: AttributeViewModel

    private(set) lazy var collectionView = createCollectionView()
    private(set) lazy var layout: UICollectionViewCompositionalLayout = createLayout()
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> =  setupDiffableDataSource()

    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: AttributeViewModel) {
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
        
        
        Preferences.standard.preferencesChangedSubject.filter { keypath in
            keypath == \Preferences.theme
        }.sink { [weak self] _ in
            self?.view.backgroundColor = Preferences.standard.theme.mode == .dark ? .black : .white
        }
        .store(in: &cancellables)
        
        view.backgroundColor = Preferences.standard.theme.mode == .dark ? .black : .white

        Publishers.CombineLatest(
            viewModel.$variations,
            viewModel.$selectedVariant
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
        let variationRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { [weak self] cell, indexPath, item in
            guard
                let self,
                case let .variation(variation, isSelected) = item,
                let name = variation.attributes?[self.viewModel.attribute.id]
            else {
                return
            }
            
            cell.contentConfiguration = UIHostingConfigurationBackport {
                VariantPickerCell(
                    text: name,
                    isSelected: isSelected
                )
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
        snapshot.appendItems(viewModel.variations.map { .variation($0, viewModel.selectedVariant?.id == $0.id) }, toSection: .variants)
        
        print("Selected variation: \(viewModel.selectedVariant?.id)", snapshot.itemIdentifiers)

        return snapshot
    }
    
    func didSelect(item: Item, at indexPath: IndexPath) {
        guard case let .variation(variation, _) = item else {
            return
        }

        viewModel.onVariationTapped(variation)
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
