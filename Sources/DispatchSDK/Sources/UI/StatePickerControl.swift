import SwiftUI

@available(iOS 15.0, *)
struct ZonePickerControl: View {
    @Preference(\.theme) var theme
    @Binding var selectedZone: Country.Zone

    let country: Country
    let zones: [Country.Zone]

    init(country: Country, zones: [Country.Zone], selectedZone: Binding<Country.Zone>) {
        self.country = country
        self.zones = zones
        _selectedZone = selectedZone
    }

    var body: some View {
        Menu {
            Picker(country.labels.zone, selection: $selectedZone) {
                ForEach(zones, id: \.code) {
                    Text($0.name)
                        .tag($0)
                }
            }
        } label: {
            HStack {
                Text(selectedZone.name.isEmpty ? country.labels.zone : selectedZone.name)
                    .foregroundStyle(
                        selectedZone.id == Country.Zone.empty.id ? Colors.placeholderColor : .primary
                    )
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

@available(iOS 15.0, *)
#Preview {
    let zones: [Country.Zone] = [] // Your list of Zone models
    @State var selectedZone: Country.Zone = .empty
    return ZonePickerControl(
        country: .unitedStates,
        zones: zones,
        selectedZone: $selectedZone
    )
        .frame(width: 160)
}

@available(iOS 15.0, *)
struct StatePickerControl: View {
    @Preference(\.theme) var theme
    @Binding var state: String

    private let usStates = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                    "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                    "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                    "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                            "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var body: some View {
        Menu {
            Picker("State", selection: $state) {
                ForEach(usStates, id: \.self) {
                    Text($0)
                }
            }
        } label: {
            HStack {
                Text(state.isEmpty ? "State" : state)
                    .foregroundStyle(state.isEmpty ? Colors.placeholderColor : .primary)
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

@available(iOS 15.0, *)
#Preview {
    @State var state: String = ""
    return StatePickerControl(state: $state)
        .frame(width: 160)
}
