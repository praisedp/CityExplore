import SwiftUI

struct SettingsView: View {
    @AppStorage("useCompactCards") private var useCompactCards = false
    @AppStorage("preferredColorScheme") private var preferredColorScheme: String = "system"
    @State private var showingShareSheet = false

    var body: some View {
        List {
            Section(header: Text("Appearance")) {
                Picker("Color Scheme", selection: $preferredColorScheme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
                .onChange(of: preferredColorScheme) { _ in
                    applyColorScheme()
                }
                
                Toggle("Use Compact Cards", isOn: $useCompactCards)
            }
            
            Section(header: Text("About")) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("City Explorer")
                        .font(.headline)
                    Text("Discover and save your favorite places.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Button {
                    showingShareSheet = true
                } label: {
                    Label("Share the App", systemImage: "square.and.arrow.up")
                }
            }
            
            Section(header: Text("Assignment Info")) {
                Text("This app was built for a mobile development course assignment. It demonstrates the use of SwiftUI, Core Data, and MapKit.")
                    .font(.footnote)
            }
        }
        .navigationTitle("Settings")
        .onAppear(perform: applyColorScheme)
        .sheet(isPresented: $showingShareSheet) {
            ActivityViewController(activityItems: ["Check out City Explorer!"])
        }
    }
    
    private func applyColorScheme() {
        switch preferredColorScheme {
        case "light":
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .keyWindow?
                .overrideUserInterfaceStyle = .light
        case "dark":
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .keyWindow?
                .overrideUserInterfaceStyle = .dark
        default:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .keyWindow?
                .overrideUserInterfaceStyle = .unspecified
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
