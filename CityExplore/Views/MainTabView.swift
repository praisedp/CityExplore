import SwiftUI
internal import CoreData

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                PlacesListView()
            }
            .tabItem {
                Label("Places", systemImage: "list.bullet")
            }

            NavigationStack {
                PlacesMapView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
