import SwiftUI

struct PaymentOptionsPickerView: View {
    let theme: Theme
    var body: some View {
        VStack {
            HStack {
                Text("Payment Options")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark")
                }
                .border(.black, width: 1)
                .cornerRadius(4)
            }
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Pay")
                }
                .font(.headline.bold())
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    theme: theme,
                    isLoading: false,
                    isDisabled: false,
                    foregroundColor: Color(UIColor.systemBackground),
                    backgroundColor: .primary
                )
            )
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "creditcard.fill")
                    Text("Card")
                }
                .font(.headline.bold())
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    theme: theme,
                    isLoading: false,
                    isDisabled: false,
                    foregroundColor: .white,
                    backgroundColor: .blue
                )
            )
            
            HStack(spacing: 32) {
                Text("powered by dispatch")
                Text("shop on nike.com")
            }
        }
        .padding()
    }
}

struct PaymentOptionsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentOptionsPickerView(
            theme: Theme()
        )
//            .previewDevice("iPhone 12") // Specify the device here
    }
}
