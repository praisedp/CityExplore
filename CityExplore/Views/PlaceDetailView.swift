import SwiftUI
internal import CoreData

struct PlaceDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var place: Place
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(place.name ?? "Unknown Place")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(place.category ?? "Uncategorized")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: place.isFavorite ? "star.fill" : "star")
                            .foregroundColor(place.isFavorite ? .yellow : .gray)
                        Text(place.isFavorite ? "Favorite" : "Add to Favorites")
                    }
                    .font(.headline)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }

                if let notes = place.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                    Text("Lat: \(place.latitude)")
                    Text("Long: \(place.longitude)")
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    deletePlace()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                AddPlaceView(existingPlace: place)
            }
        }
    }

    private func toggleFavorite() {
        withAnimation(.spring()) {
            place.isFavorite.toggle()
            saveContext()
        }
    }

    private func deletePlace() {
        viewContext.delete(place)
        saveContext()
        dismiss()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

