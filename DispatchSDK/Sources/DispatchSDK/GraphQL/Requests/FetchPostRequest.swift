import Foundation

struct FetchPostRequest: GraphQLRequest {
    typealias Output = Post
    typealias Input = IDInput

    var operationString: String {
        """
        query Post($id: ID!) {
          post(id: $id) {
            id
            title
            body
          }
        }
        """
    }

    var input: IDInput

    init(id: String) {
        self.input = IDInput(id: id)
    }
}

struct IDInput: Encodable {
    let id: String
}

struct Post: Decodable {
    let id: String
    let title: String
    let body: String
}

