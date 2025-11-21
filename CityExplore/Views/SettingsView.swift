import SwiftUI

struct SettingsView: View {
    @AppStorage("useCompactCards") private var useCompactCards = false

    var body: some View {
        Form {
            Section(header: Text("About")) {
                VStack(alignment: .leading) {
                    Text("City Explorer")
                        .font(.headline)
                    Text("Discover and save your favorite places.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Assignment Info")) {
                Text("This app was built for a mobile development course assignment. It demonstrates the use of SwiftUI, Core Data, and MapKit.")
                    .font(.footnote)
            }

            Section(header: Text("Preferences")) {
                Toggle("Use Compact Cards", isOn: $useCompactCards)
            }
        }
        .navigationTitle("Settings")
    }
}
