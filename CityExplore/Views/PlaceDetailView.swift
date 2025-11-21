import SwiftUI
import MapKit
internal import CoreData

struct PlaceDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var place: Place
    @State private var showingEditSheet = false
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                locationMap
                
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    favoriteButton
                    locationCards
                    notesCard
                }
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [.blue.opacity(0.05), .clear], startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
        )
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
        .onAppear(perform: updateCameraPosition)
    }
    
    private var locationMap: some View {
        Map(position: $cameraPosition, interactionModes: []) {
            Annotation(place.name ?? "Place", coordinate: coordinate) {
                Image(systemName: place.isFavorite ? "star.circle.fill" : "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(place.isFavorite ? .yellow : .red)
                    .shadow(radius: 4)
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Text(place.category ?? "Category")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
        }
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.name ?? "Unknown Place")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(place.category ?? "Uncategorized")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
    
    private var favoriteButton: some View {
        Button(action: toggleFavorite) {
            HStack {
                Image(systemName: place.isFavorite ? "star.fill" : "star")
                    .foregroundColor(place.isFavorite ? .yellow : .gray)
                Text(place.isFavorite ? "Favorited" : "Mark as Favorite")
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
        }
    }
    
    private var locationCards: some View {
        HStack(spacing: 16) {
            InfoCard(title: "Latitude", value: String(format: "%.4f", place.latitude))
            InfoCard(title: "Longitude", value: String(format: "%.4f", place.longitude))
        }
    }
    
    private var notesCard: some View {
        Group {
            if let notes = place.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Notes", systemImage: "text.justify")
                        .font(.headline)
                    Text(notes)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
            }
        }
    }

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
    }
    
    private func updateCameraPosition() {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        cameraPosition = .region(region)
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

private struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

