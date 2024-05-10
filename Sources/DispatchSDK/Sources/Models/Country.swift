import Foundation

struct Country: Codable, Identifiable, Hashable {
    var id: String {
        code
    }

    let name: String
    let code: String
    let continent: String
    let phoneNumberPrefix: Int
    let autocompletionField: String
    let provinceKey: String?
    let labels: Labels
    let optionalLabels: OptionalLabels
    let formatting: Formatting
    let zones: [Zone]

    struct Labels: Codable, Hashable {
        let address1: String
        let address2: String
        let city: String
        let company: String
        let country: String
        let firstName: String
        let lastName: String
        let phone: String
        let postalCode: String
        let zone: String
    }

    struct OptionalLabels: Codable, Hashable {
        let address2: String
    }

    struct Formatting: Codable, Hashable {
        let edit: String
        let show: String
    }

    struct Zone: Codable, Identifiable, Hashable {
        var id: String {
            code
        }
        let name: String
        let code: String
    }
}

extension Country {
    func shouldShowField(_ field: String) -> Bool {
        // check if formatting.show string includes field
        return formatting.show.contains("{\(field)}")
    }
}

extension Country.Zone {
    static var empty: Self {
        Self(name: "", code: "none")
    }
}

extension Country {
    static var unitedStates: Country {
        Country(
            name: "United States",
            code: "US",
            continent: "North America",
            phoneNumberPrefix: 1,
            autocompletionField: "address1",
            provinceKey: "STATE",
            labels: .init(
                address1: "Address",
                address2: "Apartment, suite, etc.",
                city: "City",
                company: "Company",
                country: "Country/region",
                firstName: "First name",
                lastName: "Last name",
                phone: "Phone",
                postalCode: "ZIP code",
                zone: "State"
            ),
            optionalLabels: .init(address2: "Apartment, suite, etc. (optional)"),
            formatting: .init(
                edit: "{country}_{firstName}{lastName}_{company}_{address1}_{address2}_{city}{province}{zip}_{phone}",
                show: "{firstName} {lastName}_{company}_{address1}_{address2}_{city} {province} {zip}_{country}_{phone}"
            ),
            zones: [
                .init(name: "Alabama", code: "AL"),
                .init(name: "Alaska", code: "AK"),
                .init(name: "American Samoa", code: "AS"),
                .init(name: "Arizona", code: "AZ"),
                .init(name: "Arkansas", code: "AR"),
                .init(name: "California", code: "CA"),
                .init(name: "Colorado", code: "CO"),
                .init(name: "Connecticut", code: "CT"),
                .init(name: "Delaware", code: "DE"),
                .init(name: "Washington DC", code: "DC"),
                .init(name: "Micronesia", code: "FM"),
                .init(name: "Florida", code: "FL"),
                .init(name: "Georgia", code: "GA"),
                .init(name: "Guam", code: "GU"),
                .init(name: "Hawaii", code: "HI"),
                .init(name: "Idaho", code: "ID"),
                .init(name: "Illinois", code: "IL"),
                .init(name: "Indiana", code: "IN"),
                .init(name: "Iowa", code: "IA"),
                .init(name: "Kansas", code: "KS"),
                .init(name: "Kentucky", code: "KY"),
                .init(name: "Louisiana", code: "LA"),
                .init(name: "Maine", code: "ME"),
                .init(name: "Marshall Islands", code: "MH"),
                .init(name: "Maryland", code: "MD"),
                .init(name: "Massachusetts", code: "MA"),
                .init(name: "Michigan", code: "MI"),
                .init(name: "Minnesota", code: "MN"),
                .init(name: "Mississippi", code: "MS"),
                .init(name: "Missouri", code: "MO"),
                .init(name: "Montana", code: "MT"),
                .init(name: "Nebraska", code: "NE"),
                .init(name: "Nevada", code: "NV"),
                .init(name: "New Hampshire", code: "NH"),
                .init(name: "New Jersey", code: "NJ"),
                .init(name: "New Mexico", code: "NM"),
                .init(name: "New York", code: "NY"),
                .init(name: "North Carolina", code: "NC"),
                .init(name: "North Dakota", code: "ND"),
                .init(name: "Northern Mariana Islands", code: "MP"),
                .init(name: "Ohio", code: "OH"),
                .init(name: "Oklahoma", code: "OK"),
                .init(name: "Oregon", code: "OR"),
                .init(name: "Palau", code: "PW"),
                .init(name: "Pennsylvania", code: "PA"),
                .init(name: "Puerto Rico", code: "PR"),
                .init(name: "Rhode Island", code: "RI"),
                .init(name: "South Carolina", code: "SC"),
                .init(name: "South Dakota", code: "SD"),
                .init(name: "Tennessee", code: "TN"),
                .init(name: "Texas", code: "TX"),
                .init(name: "Utah", code: "UT"),
                .init(name: "Vermont", code: "VT"),
                .init(name: "U.S. Virgin Islands", code: "VI"),
                .init(name: "Virginia", code: "VA"),
                .init(name: "Washington", code: "WA"),
                .init(name: "West Virginia", code: "WV"),
                .init(name: "Wisconsin", code: "WI"),
                .init(name: "Wyoming", code: "WY"),
                .init(name: "Armed Forces Americas", code: "AA"),
                .init(name: "Armed Forces Europe", code: "AE"),
                .init(name: "Armed Forces Pacific", code: "AP"),
            ]
        )
    }
}
