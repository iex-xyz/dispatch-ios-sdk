import Foundation
import SwiftUI
import Combine
import UIKit
import Foundation

struct VariantPickerView: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
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
