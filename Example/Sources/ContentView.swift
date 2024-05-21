import SwiftUI
import DispatchSDK

struct ContentView: View {
    @State var environment: AppEnvironment = .demo
    @State var events: [LoggedDispatchEvent] = []
    
    let applicationId: String = "<INSERT_APPLICATION_ID>"
    
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
            if applicationId == "<INSERT_APPLICATION_ID>" {
                Section("Warnings") {
                    Button("Application ID must be set") {}
                        .foregroundStyle(.red)
                }
            }
            
            Section("Staging Checkouts") {
                Button(action: {
                    handleItemTapped(.testYetiCheckout)
                }) {
                    Text("Yeti Cooler")
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
            
            Section("Demo Checkouts") {
                Button(action: {
                    handleItemTapped(.testStanleyCheckout)
                }) {
                    Text("Stanley Cup")
                }
            }
            
            Section("Content") {
                Button(action: {
                    handleItemTapped(.testQuantityPicker)
                }) {
                    Text("Quantity Picker")
                }
            }
            
            Section("Logged Analytics Events") {
                if events.isEmpty {
                    Text("No analytics events logged yet")
                        .foregroundStyle(.secondary)
                }
                ForEach(events, id: \.id) { event in
                    EventRow(for: event)
                }
                
                if !events.isEmpty {
                    Button(role: .destructive, action: {
                        events.removeAll()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    func EventRow(for event: LoggedDispatchEvent) -> some View {
        VStack(alignment: .leading) {
            Text(event.event.name)
                .font(.caption.monospaced().bold())
            if !event.event.params.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(Array(event.event.params.keys), id: \.self) { key in
                        Text("\(key): \(String(describing: event.event.params[key]))")
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }
                }
            }
        }
    }
    func handleItemTapped(_ route: DispatchRoute) {
        let config: DispatchConfig = DispatchConfig(
            applicationId: applicationId,
            environment: environment,
            merchantId: nil, // Set a Merchant ID here to enable Apple Pay
            orderCompletionCTA: "Back to List"
        )
        DispatchSDK.shared.setup(using: config)
        DispatchSDK.shared.present(with: route)
        DispatchSDK.shared.registerForEvents { event in
            self.events.append(event)
        }

    }
}

#Preview {
    ContentView()
}
