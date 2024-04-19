import Foundation

struct LineItem: Codable {
    let coverTransactionCosts: Bool
    let externalProductId: String?
    let externalVariantId: String?
    let itemCost: Float
    let productId: String
    let productReference: Product
    let quantity: Float
    let variantId: String?
    
    /*
     
     enum CodingKeys: String, CodingKey {
         case coverTransactionCosts
         case externalProductId
         case externalVariantId
         case itemCost
         case productId
         case productReference
         case quantity
         case variantId
     }

     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         coverTransactionCosts = try container.decode(Bool.self, forKey: .coverTransactionCosts)
         externalProductId = try container.decodeIfPresent(String.self, forKey: .externalProductId)
         externalVariantId = try container.decodeIfPresent(String.self, forKey: .externalVariantId)
         itemCost = try container.decode(Float.self, forKey: .itemCost)
         productId = try container.decode(String.self, forKey: .productId)
         productReference = try container.decode(Product.self, forKey: .productReference)
         quantity = try container.decode(Float.self, forKey: .quantity)
         variantId = try container.decodeIfPresent(String.self, forKey: .variantId)
     }

     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(coverTransactionCosts, forKey: .coverTransactionCosts)
         try container.encodeIfPresent(externalProductId, forKey: .externalProductId)
         try container.encodeIfPresent(externalVariantId, forKey: .externalVariantId)
         try container.encode(itemCost, forKey: .itemCost)
         try container.encode(productId, forKey: .productId)
         try container.encode(productReference, forKey: .productReference)
         try container.encode(quantity, forKey: .quantity)
         try container.encodeIfPresent(variantId, forKey: .variantId)
     }

     */
    
}
