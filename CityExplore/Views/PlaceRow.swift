import SwiftUI

struct PlaceRow: View {
    @ObservedObject var place: Place
    @AppStorage("useCompactCards") private var useCompactCards = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name ?? "Unknown Place")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(place.category ?? "Uncategorized")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if place.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .transition(.scale)
            } else {
                Image(systemName: "star")
                    .foregroundColor(.gray)
                    .transition(.scale)
            }
        }
        .padding(useCompactCards ? 10 : 16)
        .background(.ultraThinMaterial)
        .cornerRadius(useCompactCards ? 10 : 16)
        .shadow(color: Color.black.opacity(0.1), radius: useCompactCards ? 2 : 4, x: 0, y: 2)
        .padding(.vertical, useCompactCards ? 2 : 6)
    }
}
