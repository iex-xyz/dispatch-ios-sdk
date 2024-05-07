import SwiftUI
import DispatchSDK

struct ContentView: View {
    @State var environment: AppEnvironment = .staging
    
    let buildInfo = """
• Navigation hasn't been updated to match latest Figma. Still some questions/research around feasibility going sheet -> fullscreen

• Checkout preview needs some testing with multiple attribute variant

• SVG image support is not sizing properly

• HTML needs more testing with various tags and test cases. Staging presets have weird characters and missing HTML tags

• Confetti success needs to be polished

• PhoneNumberTextfield needs more testing to verify full global support works as intended

• Rotation indicator is not implemented yet

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
                        Text("Yeti Cooler")
                    }
                    Button(action: {
                        handleItemTapped(.testYetiMugCheckout)
                    }) {
                        Text("Yeti Mug")
                    }
                    Button(action: {
                        handleItemTapped(.testMysteryCheckout)
                    }) {
                        Text("Mystery Box")
                    }
                    Button(action: {
                        handleItemTapped(.testTidePods)
                    }) {
                        Text("Tide Pods")
                    }
                    Button(action: {
                        handleItemTapped(.testNanoX)
                    }) {
                        Text("Ledger Nano X")
                    }
                    Button(action: {
                        handleItemTapped(.testFaitesUnDonPour)
                    }) {
                        Text("Faites un don pour")
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
    
    func handleItemTapped(_ route: DispatchRoute) {
        let config: DispatchConfig = DispatchConfig(
            applicationId: "64b86c02453510acde70250f",
            environment: .staging,
            merchantId: "merchant.co.dispatch.checkout"
        )
        DispatchSDK.shared.setup(using: config)
        DispatchSDK.shared.present(with: route)

    }
}

#Preview {
    ContentView()
}
