import SwiftUI

struct CountryPickerControl: View {
    @Preference(\.theme) var theme
    @Binding var selectedCountry: Country
    
    @ObservedObject var viewModel: CountriesViewModel

    init(viewModel: CountriesViewModel, selectedCountry: Binding<Country>) {
        self.viewModel = viewModel
        self._selectedCountry = selectedCountry
    }
    
    var body: some View {
        Menu {
            Picker("Country", selection: $selectedCountry) {
                ForEach(viewModel.state.countries) { country in
                    HStack {
                        Text("\(country.emojiFlag() ?? "") \(country.name)")
                    }
                    .foregroundStyle(.primary)
                    .tag(country)
                }
            }
        } label: {
            HStack {
                Text("\(selectedCountry.emojiFlag() ?? "") \(selectedCountry.name)")
                        .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Colors.controlBackground)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
                    .stroke(Colors.borderGray, lineWidth: 4)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
            )
        }
        .colorScheme(theme.colorScheme)
    }
}
