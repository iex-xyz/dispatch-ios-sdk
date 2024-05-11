import SwiftUI

@available(iOS 15.0, *)
struct ShippingMethodsView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ShippingMethodViewModel
    
    init(viewModel: ShippingMethodViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                switch viewModel.state {
                case .idle:
                    EmptyView()
                case .loading:
                    ForEach(0..<3) { idx in
                        ShippingMethodCell.SkeletonView()
                    }
                case let .loaded(shippingMethods):
                    ForEach(shippingMethods) { shippingMethod in
                        Button(action: {
                            viewModel.onShippingMethodTapped(shippingMethod)
                        }) {
                            ShippingMethodCell(shippingMethod: shippingMethod)
                                .tint(.primary)
                        }
                        .disabled(viewModel.shippingMethodState.isButtonDisabled)
                    }
                    
                case .error:
                    Text("Something went wrong")
                }
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    let viewModel: ShippingMethodViewModel = ShippingMethodViewModel(
        apiClient: GraphQLClient(networkService: PreviewNetworkService(), environment: .staging),
        orderId: "123"
    )
    viewModel.state = .loaded([.random(), .random()])
    
    return VStack {
        ShippingMethodsView(
            viewModel: viewModel
        )
        .preferredColorScheme(.dark)
        ShippingMethodsView(
            viewModel: viewModel
        )
        .preferredColorScheme(.light)
    }
}
