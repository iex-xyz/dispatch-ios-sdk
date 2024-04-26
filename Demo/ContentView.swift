import SwiftUI
import DispatchSDK

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Checkouts") {
                    Button(action: {
                        handleItemTapped(.testYetiCheckout)
                    }) {
                        Text("Yeti")
                    }
                    Button(action: {
                        handleItemTapped(.testMysteryCheckout)
                    }) {
                        Text("Mystery Box")
                    }
                }
                
                Section("Content") {
                    Button(action: {
                        handleItemTapped(.testQuantityPicker)
                    }) {
                        Text("Quantity Picker")
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Dispatch SDK")
        .navigationBarTitleDisplayMode(.automatic)
    }
    
    func handleItemTapped(_ route: DeepLinkRoute) {
        DispatchSDK.shared.setEnvironment(.staging)
        DispatchSDK.shared.present(with: route)

    }
}

#Preview {
    ContentView()
}
