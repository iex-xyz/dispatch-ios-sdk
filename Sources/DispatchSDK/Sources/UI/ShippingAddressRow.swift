import SwiftUI

struct ShippingAddressRow: View {
    let address: AddressLookupResult
    var body: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .foregroundStyle(Color.dispatchBlue)
            VStack(alignment: .leading) {
                Text(address.address1)
                    .foregroundStyle(.primary)
                    .font(.headline)
//                    .fontWeight(.medium)
                Text("\(address.city), \(address.state)")
                    .foregroundStyle(.primary)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

#Preview {
    VStack {
        ShippingAddressRow(
            address: .init(
                address1: "612 Fresh Pond Rd",
                city: "New York",
                state: "NY",
                postalCode: "10009",
                country: "United States"
            )
        )
        ShippingAddressRow(
            address: .init(
                address1: "612 East 14th St",
                city: "New York",
                state: "NY",
                postalCode: "10003",
                country: "United States"
            )
        )
    }
}
