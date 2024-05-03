import Foundation
import SwiftUI
import Combine
import UIKit
import Foundation

class VariantPickerViewModel: ObservableObject {
    @Published var selectedVariation: Variation
    let attribute: Attribute
    let variations: [Variation]
    let quantity: Int

    init(
        attribute: Attribute,
        variations: [Variation],
        selectedVariation: Variation,
        quantity: Int
    ) {
        self.attribute = attribute
        self.variations = variations
        self.selectedVariation = selectedVariation
        self.quantity = quantity
    }
    
    func onVariantTapped(_ variant: Variation) {
        self.selectedVariation = variant
    }
    
    func isVariationEnabled(_ variation: Variation) -> Bool {
        guard 
            let quantityAvailable = variation.quantityAvailable
        else {
            return false
        }
        
        return Int(quantityAvailable) >= quantity
    }
}

struct VariantPickerView: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: VariantPickerViewModel

    enum ColumnType {
        case single
        case double
    }
    @State var columns: ColumnType
    
    func VariantCell(for variant: Variation) -> some View {
        Button(action: {
            viewModel.onVariantTapped(variant)
        }) {
            if
                let attributeKey = variant.attributes?[viewModel.attribute.id],
                let selectedValue = viewModel.attribute.options[attributeKey]?.title
            {
                VariantPickerCell(
                    text: selectedValue,
                    isSelected: viewModel.selectedVariation.id == variant.id
                )
            }
        }
        .foregroundStyle(.primary)
        .opacity(viewModel.isVariationEnabled(variant) ? 1 : 0.5)
        .disabled(!viewModel.isVariationEnabled(variant))
    }
    
    func DoubleColumns() -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.variations.chunked(into: 2).map { ($0, $0.map { $0.id })}, id: \.1) { variants, _ in
                    HStack(spacing: 8) {
                        ForEach(variants) { variant in
                            VariantCell(for: variant)
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
                VariantCell(for: variant)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Select \(viewModel.attribute.title)")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Icons.close
                }
            }
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
            
            HStack {
                Spacer()
                FooterView()
                Spacer()
            }
        }
        .padding()
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}
