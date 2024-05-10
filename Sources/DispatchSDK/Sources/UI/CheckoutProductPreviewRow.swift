import SwiftUI

struct CheckoutProductPreviewRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            if 
                let imageUrlString = product.baseImages.first,
                let url = URL(string: imageUrlString)
            {
                AsyncImage(url: url, content: { content in
                    content
                        .image?
                        .resizable()
                        .scaledToFill()
                })
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            Text(product.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    CheckoutProductPreviewRow(product: .mock())
}
