//  Spot3DDetailSheet.swift
//  Full 3D viewer sheet for Spot3D pins — spins the model, shows features, Directions + AR.

import SwiftUI
import MapKit

struct Spot3DDetailSheet: View {
    let spot: Spot3D
    @State private var showAR = false
    @State private var arURL: URL?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                ZStack(alignment: .topLeading) {
                    Spot3DView(spot: spot)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    HStack(spacing: 6) {
                        Label(spot.kindLabel, systemImage: spot.category.symbol)
                        if let badge = spot.statusBadge {
                            Text(badge.text).foregroundStyle(badge.color)
                        }
                    }
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(12)
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("Drag to spin · pinch to zoom")
                        .font(.caption2).foregroundStyle(.secondary)
                        .padding(8).background(.ultraThinMaterial, in: Capsule()).padding(10)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(spot.name).font(.title2.bold())
                    Text(spot.address).font(.subheadline).foregroundStyle(.secondary)
                }

                if !spot.notes.isEmpty {
                    Text(spot.notes).font(.body)
                }

                if spot.access != "public" && spot.access != "business" {
                    Label(spot.access.capitalized, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote).foregroundStyle(.orange)
                }

                featureChips

                HStack(spacing: 10) {
                    Button { directions() } label: {
                        Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent).tint(spot.category.tint)

                    Button {
                        arURL = SpotSceneFactory.usdzForAR(spot); showAR = arURL != nil
                    } label: {
                        Label("View in AR", systemImage: "arkit").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .controlSize(.large)

                if !spot.coordVerified {
                    Text("Pin placed from the street address — it gets sharpened automatically on first launch.")
                        .font(.caption2).foregroundStyle(.tertiary)
                }
            }
            .padding(20)
        }
        .fullScreenCover(isPresented: $showAR) {
            if let arURL { ARQuickLookView(url: arURL).ignoresSafeArea() }
        }
    }

    @ViewBuilder private var featureChips: some View {
        let chips = featureList
        if !chips.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(chips, id: \.self) { c in
                        Text(c).font(.caption.weight(.medium))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(spot.category.tint.opacity(0.15), in: Capsule())
                    }
                }
            }
        }
    }

    private var featureList: [String] {
        guard let f = spot.features else { return spot.category == .shop ? ["Decks", "Wheels", "Shoes", "Tools"] : [] }
        var out: [String] = []
        if let n = f.stairs { out.append("\(n) stair") }
        if let r = f.rail, r != "none" { out.append(r == "doubleKink" ? "Double-kink rail" : "Handrail") }
        if let n = f.ledges, n > 0 { out.append("\(n) ledge\(n > 1 ? "s" : "")") }
        if let n = f.hubbas ?? f.hubbaSides, n > 0 { out.append("Hubba") }
        if let n = f.bowls, n > 0 { out.append(f.bowlDepthM.map { "Bowl · \(String(format: "%.1f", $0)) m deep" } ?? "Bowl") }
        if let n = f.banks, n > 0 { out.append("Banks") }
        if let n = f.rails, n > 0 { out.append("Rails") }
        if f.fullPipe == true { out.append("Full pipe") }
        if f.pyramid == true { out.append("Pyramid") }
        if f.gap == true || f.gapLengthM != nil { out.append("Gap") }
        if let g = f.gradePct { out.append("Hill · \(Int(g))% grade") }
        if f.wallHeightM != nil { out.append("Wallride") }
        if let s = f.surface { out.append(s.capitalized) }
        return out
    }

    private func directions() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: spot.coordinate))
        item.name = spot.name
        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
    }
}
