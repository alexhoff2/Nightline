import SwiftUI
import MapKit

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var bars: [Bar] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(using apiClient: APIClient) async {
        isLoading = true
        errorMessage = nil
        do {
            bars = try await apiClient.fetchBars()
        } catch {
            errorMessage = "Unable to load bars."
        }
        isLoading = false
    }
}

struct ExploreView: View {
    @EnvironmentObject private var apiClient: APIClient
    @StateObject private var viewModel = ExploreViewModel()
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var filteredBars: [Bar] {
        guard !searchText.isEmpty else { return viewModel.bars }
        return viewModel.bars.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.city.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.nightlineBackground
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    header

                    Map(coordinateRegion: $region, annotationItems: filteredBars) { bar in
                        MapAnnotation(coordinate: bar.coordinate) {
                            Circle()
                                .fill(Color.nightlineAccent)
                                .frame(width: 12, height: 12)
                        }
                    }
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredBars) { bar in
                                NavigationLink(destination: BarDetailView(bar: bar)) {
                                    BarCardView(bar: bar)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load(using: apiClient)
            }
            .overlay(alignment: .bottom) {
                if viewModel.isLoading {
                    ProgressView("Loading bars...")
                        .padding()
                        .background(Color.nightlineCard)
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                        .padding(.bottom, 24)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .clipShape(Capsule())
                        .padding(.bottom, 24)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What’s near you tonight?")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("Search bars or city", text: $searchText)
                    .textInputAutocapitalization(.words)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color.nightlineCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    PillView(text: "Pool table")
                    PillView(text: "Food")
                    PillView(text: "Darts")
                    PillView(text: "Not busy")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct BarCardView: View {
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bar.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("\(bar.address), \(bar.city)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                BusyIndicatorView(crowdLevel: crowdLevel)
            }

            HStack(spacing: 8) {
                ForEach(bar.amenities.prefix(3), id: \.self) { amenity in
                    PillView(text: amenity)
                }
            }
        }
        .padding()
        .background(Color.nightlineCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ExploreView()
        .environmentObject(APIClient())
}
