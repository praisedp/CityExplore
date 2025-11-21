import SwiftUI
internal import CoreData

struct PlacesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.name, ascending: true)],
        animation: .default)
    private var places: FetchedResults<Place>
    
    @State private var showingAddPlace = false

    var body: some View {
        List {
            ForEach(places) { place in
                NavigationLink {
                    PlaceDetailView(place: place)
                } label: {
                    PlaceRow(place: place)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .navigationTitle("Places")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddPlace = true
                }) {
                    Label("Add Place", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPlace) {
            NavigationStack {
                AddPlaceView(existingPlace: nil)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlacesListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
