import Foundation

struct GetCountriesRequest: GraphQLRequest {
    typealias Output = Response
    typealias Input = RequestInput
    
    struct Response: Codable {
        let countries: [Country]
    }
    
    struct RequestInput: Encodable {
        fileprivate let locale: String
    }

    var operationString: String {
        """
        query {
            getCountryList(locale: \"\(input.locale)\") {
              countries {
                name
                code
                continent
                phoneNumberPrefix
                autocompletionField
                provinceKey
                labels {
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  postalCode
                  zone
                }
                optionalLabels {
                  address2
                }
                formatting {
                  edit
                  show
                }
                zones {
                  name
                  code
                }
              }
            }
          }
        """
    }

    var input: Input

    init(locale: String) {
        self.input = .init(locale: locale)
    }
}
