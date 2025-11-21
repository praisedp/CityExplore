import SwiftUI
import MapKit
internal import CoreData

struct PlacesMapView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.name, ascending: true)],
        animation: .default)
    private var places: FetchedResults<Place>
    
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(places) { place in
                Annotation(place.name ?? "Place", coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)) {
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        Image(systemName: place.isFavorite ? "star.circle.fill" : "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(place.isFavorite ? .yellow : .red)
                            .background(.white)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .navigationTitle("Map")
        .onAppear {
            if let firstPlace = places.first {
                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: firstPlace.latitude, longitude: firstPlace.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                cameraPosition = .region(region)
            }
        }
    }
}
