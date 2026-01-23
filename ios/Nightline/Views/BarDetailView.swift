import SwiftUI

struct BarDetailView: View {
    let bar: Bar

    var crowdLevel: CrowdLevel {
        switch bar.busyPercent {
        case 0..<30:
            return .chill
        case 30..<60:
            return .medium
        case 60..<85:
            return .busy
        default:
            return .packed
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                stats
                amenities
                recentActivity
            }
            .padding()
        }
        .background(Color.nightlineBackground)
        .navigationTitle(bar.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bar.name)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text("\(bar.address), \(bar.city)")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.nightlineCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var stats: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Busy now")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text("\(bar.busyPercent)%")
                    .font(.title2)
                    .foregroundStyle(.white)
            }

            Divider()
                .overlay(Color.gray.opacity(0.4))

            VStack(alignment: .leading, spacing: 4) {
                Text("Vibe")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text(bar.vibe)
                    .font(.title3)
                    .foregroundStyle(.white)
            }

            Spacer()
            BusyIndicatorView(crowdLevel: crowdLevel)
        }
        .padding()
        .background(Color.nightlineCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var amenities: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amenities")
                .font(.headline)
                .foregroundStyle(.white)

            WrapStack(items: bar.amenities) { amenity in
                PillView(text: amenity)
            }
        }
        .padding()
        .background(Color.nightlineCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live status")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Recent check-ins appear in the Live tab.")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.nightlineCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    BarDetailView(bar: Bar(
        id: "1",
        name: "The Interval",
        address: "2 Marina Blvd",
        city: "San Francisco",
        latitude: 37.8044,
        longitude: -122.4324,
        amenities: ["Food", "Outdoor", "Cocktails"],
        vibe: "Mixed",
        busyPercent: 62,
        updatedAt: Date()
    ))
}
