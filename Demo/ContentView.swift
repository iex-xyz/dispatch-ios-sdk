import SwiftUI
import DispatchSDK

struct ContentView: View {
    @State var environment: AppEnvironment = .staging
    var body: some View {
            List {
                Section("Options") {
                    Picker("Environment", selection: $environment) {
                        Text("Staging").tag(AppEnvironment.staging)
                        Text("Demo").tag(AppEnvironment.demo)
                        Text("Production").tag(AppEnvironment.production)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
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
                
                Section("Scenarios") {
                    Button(action: {
                        handleItemTapped(.testSuccessfulOrder)
                    }) {
                        Text("Successful Order")
                    }
                }

            }
            .listStyle(.insetGrouped)
    }
    
    func handleItemTapped(_ route: DeepLinkRoute) {
        DispatchSDK.shared.setEnvironment(environment)
        DispatchSDK.shared.present(with: route)

    }
}

#Preview {
    ContentView()
}
