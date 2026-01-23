import SwiftUI

@MainActor
final class LiveViewModel: ObservableObject {
    @Published var checkIns: [CheckIn] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(using apiClient: APIClient) async {
        isLoading = true
        errorMessage = nil
        do {
            checkIns = try await apiClient.fetchLiveFeed()
        } catch {
            errorMessage = "Unable to load live feed."
        }
        isLoading = false
    }
}

struct LiveView: View {
    @EnvironmentObject private var apiClient: APIClient
    @StateObject private var viewModel = LiveViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.nightlineBackground
                    .ignoresSafeArea()

                List {
                    Section {
                        ForEach(viewModel.checkIns) { checkIn in
                            LiveRowView(checkIn: checkIn)
                                .listRowBackground(Color.nightlineCard)
                        }
                    } header: {
                        Text("Recent check-ins")
                            .foregroundStyle(.gray)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Live")
            .task {
                await viewModel.load(using: apiClient)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading activity...")
                        .padding()
                        .background(Color.nightlineCard)
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

struct LiveRowView: View {
    let checkIn: CheckIn

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(checkIn.bar?.name ?? "Unknown bar")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                BusyIndicatorView(crowdLevel: checkIn.crowdLevel)
            }
            Text(checkIn.bar?.address ?? "")
                .font(.caption)
                .foregroundStyle(.gray)
            if !checkIn.observations.isEmpty {
                WrapStack(items: checkIn.observations) { observation in
                    PillView(text: observation)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    LiveView()
        .environmentObject(APIClient())
}
