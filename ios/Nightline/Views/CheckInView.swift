import SwiftUI

@MainActor
final class CheckInViewModel: ObservableObject {
    @Published var bars: [Bar] = []
    @Published var selectedBar: Bar?
    @Published var crowdLevel: CrowdLevel = .medium
    @Published var observations: Set<String> = []
    @Published var isSubmitting = false
    @Published var statusMessage: String?

    let availableObservations = [
        "Long line",
        "DJ",
        "Live music",
        "Trivia",
        "Food available",
        "Outdoor seating"
    ]

    func load(using apiClient: APIClient) async {
        do {
            bars = try await apiClient.fetchBars()
            selectedBar = bars.first
        } catch {
            statusMessage = "Unable to load bars."
        }
    }

    func submit(using apiClient: APIClient) async {
        guard let selectedBar else { return }
        isSubmitting = true
        statusMessage = nil
        do {
            _ = try await apiClient.createCheckIn(request: CheckInRequest(
                barId: selectedBar.id,
                crowdLevel: crowdLevel,
                observations: Array(observations)
            ))
            statusMessage = "Thanks for checking in!"
            observations.removeAll()
        } catch {
            statusMessage = "Could not submit check-in."
        }
        isSubmitting = false
    }
}

struct CheckInView: View {
    @EnvironmentObject private var apiClient: APIClient
    @StateObject private var viewModel = CheckInViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.nightlineBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        barPicker
                        crowdLevelPicker
                        observationPicker
                        submitButton
                        statusText
                    }
                    .padding()
                }
            }
            .navigationTitle("Check-in")
            .task {
                await viewModel.load(using: apiClient)
            }
        }
    }

    private var barPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Where are you?")
                .font(.headline)
                .foregroundStyle(.white)

            Picker("Bar", selection: $viewModel.selectedBar) {
                ForEach(viewModel.bars) { bar in
                    Text(bar.name).tag(Optional(bar))
                }
            }
            .pickerStyle(.menu)
            .tint(Color.nightlineAccent)
            .padding()
            .background(Color.nightlineCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var crowdLevelPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How busy is it?")
                .font(.headline)
                .foregroundStyle(.white)

            HStack(spacing: 12) {
                ForEach(CrowdLevel.allCases) { level in
                    Button {
                        viewModel.crowdLevel = level
                    } label: {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: level.colorHex))
                                .frame(width: 14, height: 14)
                            Text(level.label)
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(viewModel.crowdLevel == level ? Color.nightlineAccent.opacity(0.2) : Color.nightlineCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }

    private var observationPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anything else?")
                .font(.headline)
                .foregroundStyle(.white)

            WrapStack(items: viewModel.availableObservations) { observation in
                Button {
                    if viewModel.observations.contains(observation) {
                        viewModel.observations.remove(observation)
                    } else {
                        viewModel.observations.insert(observation)
                    }
                } label: {
                    PillView(
                        text: observation,
                        background: viewModel.observations.contains(observation) ? Color.nightlineAccent.opacity(0.3) : Color.nightlineCard
                    )
                }
            }
        }
    }

    private var submitButton: some View {
        Button {
            Task {
                await viewModel.submit(using: apiClient)
            }
        } label: {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                }
                Text(viewModel.isSubmitting ? "Sending..." : "Submit check-in")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.nightlineAccent)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(viewModel.isSubmitting || viewModel.selectedBar == nil)
    }

    private var statusText: some View {
        Group {
            if let statusMessage = viewModel.statusMessage {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.top, 4)
            }
        }
    }
}

#Preview {
    CheckInView()
        .environmentObject(APIClient())
}
