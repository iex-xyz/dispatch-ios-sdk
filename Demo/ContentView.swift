import SwiftUI
import DispatchSDK

struct ContentView: View {
    @State var environment: AppEnvironment = .staging
    
    let buildInfo = """
• Apple Pay is setup but needs proper mapping to Dispatch API models (line items, shipping methods, etc)

• Navigation hasn't been updated to match latest Figma. Still some questions/research around feasibility going sheet -> fullscreen

• Checkout order preview isn't wired to handle going in and editing values yet

• Billing info update was throwing an error on the API side. Needs investigation

• Shipping method text needs to match web formatting


"""
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
                
                Section("Current Build Information") {
                    Text(buildInfo)
                        .font(.caption.monospaced())
                        .multilineTextAlignment(.leading)
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
