import SwiftUI
import SwiftData
import CoreLocation

struct SpotDiscoverView: View {
    let userCoordinate: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    @Query private var spots: [Spot]
    @Query private var checkIns: [SpotCheckIn]
    @Query private var users: [AppUser]

    @State private var bustFilter: BustStatus? = nil
    @State private var fameFilter: FameTier? = nil
    @State private var unvisitedOnly = false

    private var username: String? { users.first?.username }

    private var visitedSpotNames: Set<String> {
        guard let me = username else { return [] }
        return Set(checkIns.filter { $0.username == me }.map { $0.spotName })
    }

    private var filtered: [Spot] {
        var result = spots.filter { !$0.isRetired }
        if let bust = bustFilter { result = result.filter { $0.bustStatus == bust } }
        if let fame = fameFilter { result = result.filter { $0.fameTier == fame } }
        if unvisitedOnly { result = result.filter { !visitedSpotNames.contains($0.name) } }

        if let coord = userCoordinate {
            let userLoc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            return result.sorted {
                userLoc.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude)) <
                userLoc.distance(from: CLLocation(latitude: $1.latitude, longitude: $1.longitude))
            }
        }

        let fameSortOrder: [FameTier: Int] = [.legendary: 0, .iconic: 1, .local: 2, .hidden: 3]
        return result.sorted { (fameSortOrder[$0.fameTier] ?? 9) < (fameSortOrder[$1.fameTier] ?? 9) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    filterBar
                    Divider().background(Color.white.opacity(0.08))
                    if filtered.isEmpty {
                        Spacer()
                        VStack(spacing: 14) {
                            Image(systemName: "scope")
                                .font(.system(size: 44))
                                .foregroundStyle(.orange.opacity(0.35))
                            Text("No spots match your filters.")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    } else {
                        List(filtered) { spot in
                            DiscoverSpotRow(
                                spot: spot,
                                userCoordinate: userCoordinate,
                                visited: visitedSpotNames.contains(spot.name)
                            )
                            .listRowBackground(Color.black)
                            .listRowSeparatorTint(Color.white.opacity(0.08))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Discover Spots")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Filter Bar

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("All bust", selected: bustFilter == nil)  { bustFilter = nil }
                chip("Safe",     selected: bustFilter == .green)  { bustFilter = bustFilter == .green  ? nil : .green }
                chip("Sketchy",  selected: bustFilter == .yellow) { bustFilter = bustFilter == .yellow ? nil : .yellow }
                chip("Hot",      selected: bustFilter == .red)    { bustFilter = bustFilter == .red    ? nil : .red }

                Rectangle().fill(Color.white.opacity(0.12)).frame(width: 1, height: 18)

                chip("Legendary", selected: fameFilter == .legendary) { fameFilter = fameFilter == .legendary ? nil : .legendary }
                chip("Iconic",    selected: fameFilter == .iconic)    { fameFilter = fameFilter == .iconic    ? nil : .iconic }
                chip("Local",     selected: fameFilter == .local)     { fameFilter = fameFilter == .local     ? nil : .local }

                Rectangle().fill(Color.white.opacity(0.12)).frame(width: 1, height: 18)

                chip("New to me", selected: unvisitedOnly) { unvisitedOnly.toggle() }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    @ViewBuilder
    private func chip(_ label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(selected ? Color.orange : Color.white.opacity(0.09))
                .foregroundStyle(selected ? Color.black : Color.white)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Spot Row

struct DiscoverSpotRow: View {
    let spot: Spot
    let userCoordinate: CLLocationCoordinate2D?
    let visited: Bool

    private var distanceLabel: String? {
        guard let coord = userCoordinate else { return nil }
        let meters = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            .distance(from: CLLocation(latitude: spot.latitude, longitude: spot.longitude))
        return meters < 1000 ? "\(Int(meters))m" : String(format: "%.1fkm", meters / 1000)
    }

    private var bustColor: Color {
        switch spot.bustStatus {
        case .green:  return .green
        case .yellow: return .yellow
        case .red:    return .red
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(bustColor).frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(spot.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(spot.fameTier.label.uppercased())
                        .font(.system(size: 9, weight: .black))
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                }
                if !spot.obstacles.isEmpty {
                    Text(spot.obstacles.prefix(3).joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if let dist = distanceLabel {
                    Text(dist).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                }
                if visited {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
