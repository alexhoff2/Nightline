import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.nightlineBackground
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Text("Nightline Explorer")
                            .font(.title)
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ProfileStatRow(title: "Check-ins", value: "12")
                        ProfileStatRow(title: "Saved bars", value: "4")
                        ProfileStatRow(title: "Badges", value: "3")
                    }
                    .padding()
                    .background(Color.nightlineCard)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileStatRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .foregroundStyle(Color.nightlineAccent)
        }
    }
}

#Preview {
    ProfileView()
}
