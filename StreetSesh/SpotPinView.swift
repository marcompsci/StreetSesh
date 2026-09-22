import SwiftUI

struct SpotPinView: View {
    let spot: Spot
    let hasLiveSession: Bool

    var bustColor: Color {
        switch spot.bustStatus {
        case .green:  return .green
        case .yellow: return .yellow
        case .red:    return .red
        }
    }

    var body: some View {
        ZStack {
            if hasLiveSession {
                Circle()
                    .stroke(Color.orange, lineWidth: 2.5)
                    .frame(width: 22, height: 22)
            }
            Circle()
                .fill(bustColor)
                .frame(width: 13, height: 13)
                .overlay {
                    if spot.fameTier == .legendary {
                        Image(systemName: "star.fill")
                            .font(.system(size: 5))
                            .foregroundStyle(.white)
                    }
                }
        }
        .shadow(color: bustColor.opacity(0.5), radius: 4)
    }
}

struct LiveSessionPinView: View {
    let session: LiveSession

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.orange)
                .frame(width: 34, height: 34)
            Text(String(session.username.prefix(2)).uppercased())
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(.black)
        }
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .shadow(color: Color.orange.opacity(0.6), radius: 8)
    }
}
