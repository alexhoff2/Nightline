import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "map")
                }

            LiveView()
                .tabItem {
                    Label("Live", systemImage: "waveform.path.ecg")
                }

            CheckInView()
                .tabItem {
                    Label("Check-in", systemImage: "plus.circle.fill")
                }

            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(Color.nightlineAccent)
    }
}

#Preview {
    ContentView()
        .environmentObject(APIClient())
}
