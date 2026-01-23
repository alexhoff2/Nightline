import SwiftUI

struct SavedView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.nightlineBackground
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.nightlineAccent)
                    Text("No saved spots yet")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Save a bar from Explore to see it here.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .navigationTitle("Saved")
        }
    }
}

#Preview {
    SavedView()
}
