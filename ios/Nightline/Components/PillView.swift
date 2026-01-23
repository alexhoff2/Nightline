import SwiftUI

struct PillView: View {
    let text: String
    var background: Color = Color.nightlineCard

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(background)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

#Preview {
    PillView(text: "Pool Table")
        .padding()
        .background(Color.nightlineBackground)
}
