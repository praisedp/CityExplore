import SwiftUI
import MapKit
internal import CoreData

struct AddPlaceView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = LocationManager()

    var existingPlace: Place?

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var notes: String = ""
    @State private var isFavorite: Bool = false

    @State private var showingLocationPicker = false
    @State private var showingLocationAlert = false
    @State private var locationAlertMessage = ""

    init(existingPlace: Place?) {
        self.existingPlace = existingPlace
        _name = State(initialValue: existingPlace?.name ?? "")
        _category = State(initialValue: existingPlace?.category ?? "")
        _latitude = State(initialValue: existingPlace?.latitude != nil ? String(existingPlace!.latitude) : "")
        _longitude = State(initialValue: existingPlace?.longitude != nil ? String(existingPlace!.longitude) : "")
        _notes = State(initialValue: existingPlace?.notes ?? "")
        _isFavorite = State(initialValue: existingPlace?.isFavorite ?? false)
    }

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $name)
                TextField("Category", text: $category)
            }

            Section(header: Text("Location")) {
                if !latitude.isEmpty && !longitude.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selected Coordinates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Lat: \(latitude)")
                        Text("Long: \(longitude)")
                    }
                } else {
                    Text("No location selected yet.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Button {
                    showingLocationPicker = true
                } label: {
                    Label("Pick on Map", systemImage: "map")
                }

                Button {
                    useCurrentLocation()
                } label: {
                    Label("Use Current Location", systemImage: "location")
                }
            }

            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(height: 100)
            }

            Section {
                Toggle("Favorite", isOn: $isFavorite)
            }
        }
        .navigationTitle(existingPlace == nil ? "Add Place" : "Edit Place")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    savePlace()
                }
                .disabled(name.isEmpty || latitude.isEmpty || longitude.isEmpty)
            }
        }
        .sheet(isPresented: $showingLocationPicker) {
            NavigationStack {
                LocationPickerView(latitude: $latitude, longitude: $longitude)
            }
        }
        .alert("Location Access Needed", isPresented: $showingLocationAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(locationAlertMessage)
        })
    }

    private func useCurrentLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.lastLocation {
                let coordinate = location.coordinate
                latitude = String(coordinate.latitude)
                longitude = String(coordinate.longitude)
            } else {
                locationManager.requestLocation()
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationAlertMessage = "Enable Location Services for City Explorer in Settings to use your current location."
            showingLocationAlert = true
        default:
            break
        }
    }

    private func savePlace() {
        let place = existingPlace ?? Place(context: viewContext)
        
        if existingPlace == nil {
            place.id = UUID()
        }
        
        place.name = name
        place.category = category
        place.latitude = Double(latitude) ?? 0.0
        place.longitude = Double(longitude) ?? 0.0
        place.notes = notes
        place.isFavorite = isFavorite
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var latitude: String
    @Binding var longitude: String

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Map(position: $cameraPosition)
                    .onMapCameraChange { context in
                        selectedCoordinate = context.region.center
                    }
                    .ignoresSafeArea(edges: .top)

                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                if let coord = selectedCoordinate {
                    Text("Lat: \(coord.latitude)")
                    Text("Long: \(coord.longitude)")
                } else {
                    Text("Move the map to choose a location.")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Use This Location") {
                        if let coord = selectedCoordinate {
                            latitude = String(coord.latitude)
                            longitude = String(coord.longitude)
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedCoordinate == nil)
                }
            }
            .padding()
            .background(.regularMaterial)
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let lat = Double(latitude),
               let lon = Double(longitude) {
                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
                cameraPosition = .region(region)
                selectedCoordinate = region.center
            } else {
                cameraPosition = .automatic
            }
        }
    }
}

