import SwiftUI

struct BusyIndicatorView: View {
    let crowdLevel: CrowdLevel

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color(hex: crowdLevel.colorHex))
                .frame(width: 10, height: 10)
            Text(crowdLevel.label)
                .font(.caption)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.nightlineCard)
        .clipShape(Capsule())
    }
}

#Preview {
    BusyIndicatorView(crowdLevel: .busy)
        .padding()
        .background(Color.nightlineBackground)
}
