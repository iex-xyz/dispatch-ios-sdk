import SwiftUI

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

#Preview {
    @State var state: String = ""
    return StatePickerControl(state: $state)
        .frame(width: 160)
}
