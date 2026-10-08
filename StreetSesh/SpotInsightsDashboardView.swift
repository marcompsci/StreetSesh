import SwiftUI
import SwiftData
import UIKit

// MARK: - Spot Insights Dashboard
// Aggregated analytics for the StreetSesh spot network.
// This data forms the foundation for B2B data licensing conversations
// (parks departments, urban planners, skate brands).

struct SpotInsightsDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \SpotCheckIn.checkedInAt,   order: .reverse) private var checkIns:   [SpotCheckIn]
    @Query(sort: \SpotCondition.reportedAt,  order: .reverse) private var conditions: [SpotCondition]
    @Query(sort: \LiveSession.startedAt,     order: .reverse) private var sessions:   [LiveSession]
    @Query private var spots: [Spot]

    private struct SpotRow: Identifiable {
        let id           = UUID()
        let name:        String
        let checkIns:    Int
        let sessions:    Int
        let conditions:  Int
        var score: Int   { checkIns * 3 + sessions * 5 + conditions * 2 }
    }

    private var spotRows: [SpotRow] {
        let names = Set(spots.map { $0.name })
        return names.map { name in
            SpotRow(
                name:       name,
                checkIns:   checkIns.filter  { $0.spotName == name }.count,
                sessions:   sessions.filter  { $0.spotName == name }.count,
                conditions: conditions.filter { $0.spotName == name }.count
            )
        }
        .filter { $0.score > 0 }
        .sorted { $0.score > $1.score }
    }

    private var hourDistribution: [(hour: Int, count: Int)] {
        var dist = [Int: Int]()
        for ci in checkIns {
            let h = Calendar.current.component(.hour, from: ci.checkedInAt)
            dist[h, default: 0] += 1
        }
        return (0..<24).map { h in (hour: h, count: dist[h] ?? 0) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        summaryRow
                        topSpotsCard
                        activityByHourCard
                        exportCard
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Spot Insights")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
            .task { AnalyticsService.shared.track(.featureOpened, meta: "spot_insights") }
        }
    }

    // MARK: - Summary Row

    private var summaryRow: some View {
        HStack(spacing: 10) {
            insightBox("\(spots.count)",      label: "Spots\nTracked",     colorHex: "#CCFF40")
            insightBox("\(checkIns.count)",   label: "Total\nCheck-Ins",   colorHex: "#3AB5E6")
            insightBox("\(conditions.count)", label: "Condition\nReports", colorHex: "#FF9500")
        }
    }

    private func insightBox(_ value: String, label: String, colorHex: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(Color(hex: colorHex))
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14)
        .background(Color(hex: colorHex).opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Top Spots

    private var topSpotsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("MOST ACTIVE SPOTS", icon: "flame.fill", colorHex: "#FF5A35")

            let maxScore = spotRows.first?.score ?? 1
            if spotRows.isEmpty {
                Text("Check in to spots to see activity data here.")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(spotRows.prefix(8)) { row in
                    VStack(spacing: 4) {
                        HStack {
                            Text(row.name)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white).lineLimit(1)
                            Spacer()
                            Text("\(row.checkIns) check-ins · \(row.sessions) sessions")
                                .font(.system(size: 10)).foregroundStyle(.secondary)
                        }
                        GeometryReader { g in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.08)).frame(height: 4)
                                Capsule()
                                    .fill(Color(hex: "#FF5A35"))
                                    .frame(
                                        width: maxScore > 0
                                            ? g.size.width * CGFloat(row.score) / CGFloat(maxScore)
                                            : 0,
                                        height: 4
                                    )
                            }
                        }
                        .frame(height: 4)
                    }
                    .padding(.vertical, 3)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Activity by Hour

    private var activityByHourCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("WHEN SKATERS ARE OUT", icon: "clock.fill", colorHex: "#3AB5E6")

            let maxCount = hourDistribution.map { $0.count }.max() ?? 1
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 3) {
                    ForEach(hourDistribution, id: \.hour) { entry in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: "#3AB5E6")
                                    .opacity(maxCount > 0
                                        ? 0.12 + 0.88 * Double(entry.count) / Double(maxCount)
                                        : 0.12))
                                .frame(
                                    width: 14,
                                    height: max(4, 52 * CGFloat(entry.count) / CGFloat(maxCount))
                                )
                            if entry.hour % 6 == 0 {
                                Text(hourLabel(entry.hour))
                                    .font(.system(size: 7))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 72)

            if checkIns.isEmpty {
                Text("Session data will appear as you and your crew check in to spots.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Export Card

    private var exportCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("PARTNERSHIP DATA", icon: "arrow.up.doc.fill", colorHex: "#C77DFF")
            Text("Aggregated spot activity data — no personal information included — can be licensed to parks departments, urban planners, or skate brands evaluating skateable public space.")
                .font(.caption).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Button { exportCSV() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export Spot Activity CSV")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#C77DFF"))
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(Color(hex: "#C77DFF").opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#C77DFF").opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Helpers

    private func sectionLabel(_ title: String, icon: String, colorHex: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 10)).foregroundStyle(Color(hex: colorHex))
            Text(title)
                .font(.system(size: 10, weight: .black)).tracking(1.2)
                .foregroundStyle(Color(hex: colorHex).opacity(0.85))
        }
    }

    private func hourLabel(_ hour: Int) -> String {
        switch hour {
        case 0:  return "12a"
        case 12: return "12p"
        default: return hour < 12 ? "\(hour)a" : "\(hour - 12)p"
        }
    }

    private func exportCSV() {
        var csv = "Spot Name,Check-Ins,Sessions,Condition Reports,Activity Score\n"
        for row in spotRows {
            csv += "\"\(row.name)\",\(row.checkIns),\(row.sessions),\(row.conditions),\(row.score)\n"
        }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("streetsesh_spot_insights.csv")
        guard (try? csv.write(to: url, atomically: true, encoding: .utf8)) != nil else { return }

        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root  = scene.windows.first?.rootViewController {
            root.present(vc, animated: true)
        }
    }
}
