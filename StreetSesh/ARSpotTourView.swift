import SwiftUI
import QuickLook

// MARK: - AR Spot Tour
// Curated grid of every spot with a USDZ model — the App Store hero feature.

struct ARSpotTourView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedURL: URL?
    @State private var showAR      = false
    @State private var searchText  = ""

    private let arSpots: [(name: String, file: String, city: String, type: String)] = [
        // San Francisco iconic spots
        ("EMB",                "sf-emb",                 "San Francisco", "Street"),
        ("Pier 7",             "sf-pier-7",              "San Francisco", "Street"),
        ("Wallenberg",         "sf-wallenberg",          "San Francisco", "Street"),
        ("China Banks",        "sf-china-banks",         "San Francisco", "Street"),
        ("Hubba Hideout",      "sf-hubba-hideout",       "San Francisco", "Street"),
        ("Dolores Hill",       "sf-dolores-hill",        "San Francisco", "Street"),
        ("Clipper Hubba",      "sf-clipper-hubba",       "San Francisco", "Street"),
        ("3 Up 3 Down",        "sf-3up3down",            "San Francisco", "Street"),
        ("6th Ave Hubba",      "sf-6th-ave",             "San Francisco", "Street"),
        ("Balboa Park",        "sf-balboa",              "San Francisco", "Park"),
        ("BART Wallride",      "sf-bart-wallride",       "San Francisco", "Street"),
        ("Bay Blocks",         "sf-bay-blocks",          "San Francisco", "Street"),
        ("Dolores Double Kink","sf-dolores-double-kink", "San Francisco", "Street"),
        ("Fort Miley",         "sf-fort-miley",          "San Francisco", "Street"),
        ("Hilltop",            "sf-hilltop",             "San Francisco", "Street"),
        ("Lincoln High",       "sf-lincoln-high",        "San Francisco", "Street"),
        ("Pier 15 Bench",      "sf-pier-15-bench",       "San Francisco", "Street"),
        ("Potrero del Sol",    "sf-potrero-del-sol",     "San Francisco", "Park"),
        ("SOMA West",          "sf-soma-west",           "San Francisco", "Street"),
        ("Twin Peaks",         "sf-twin-peaks",          "San Francisco", "Street"),
        ("UN Plaza",           "sf-un-plaza",            "San Francisco", "Street"),
        ("Union Square",       "sf-union-square",        "San Francisco", "Street"),
        ("Waller Ledges",      "sf-waller-ledges",       "San Francisco", "Street"),
        ("3rd Army",           "sf-3rd-army",            "San Francisco", "Street"),
        // Bay Area
        ("Oakland Town Park",  "oak-town-park",          "Oakland",       "Park"),
        ("Berkeley McCrary",   "berk-mccrary",           "Berkeley",      "Street"),
        ("Mountain View",      "mv-rengstorff",          "Mountain View", "Park"),
        ("Ala Skatepark",      "ala-skatepark",          "Alameda",       "Park"),
        ("Lake Cunningham",    "sj-lake-cunningham",     "San Jose",      "Park"),
        ("Orange Cove",        "oc-orange-cove",         "Orange Cove",   "Park"),
        ("CL Library Hubba",   "cl-library-hubba",       "Colma",         "Street"),
        // Shops with 3D models
        ("FTC Skateboarding",  "shop-ftc",               "San Francisco", "Shop"),
        ("Skates on Haight",   "shop-skates-on-haight",  "San Francisco", "Shop"),
        ("510 Skateboarding",  "shop-510",               "Oakland",       "Shop"),
        ("MacArthur",          "shop-macarthur",         "Oakland",       "Shop"),
        ("Low Key",            "shop-low-key",           "Bay Area",      "Shop"),
        ("Mission Skates",     "shop-mission",           "San Francisco", "Shop"),
        ("Prodigy",            "shop-prodigy",           "Bay Area",      "Shop"),
        ("Red Curbs",          "shop-red-curbs",         "Bay Area",      "Shop"),
    ]

    private var filtered: [(name: String, file: String, city: String, type: String)] {
        guard !searchText.isEmpty else { return arSpots }
        return arSpots.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.city.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                heroHeader
                searchBar
                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 12
                    ) {
                        ForEach(filtered, id: \.file) { spot in
                            arSpotCard(spot)
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
        }
        .fullScreenCover(isPresented: $showAR) {
            if let url = selectedURL {
                ARQuickLookView(url: url).ignoresSafeArea()
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: "#0A0F1A"), Color(hex: "#1A0A2E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // AR grid lines
            Canvas { ctx, size in
                for i in 0..<10 {
                    let x = size.width * CGFloat(i) / 9
                    var line = Path()
                    line.move(to: CGPoint(x: size.width / 2, y: size.height * 0.2))
                    line.addLine(to: CGPoint(x: x, y: size.height))
                    ctx.stroke(line, with: .color(Color(hex: "#C77DFF").opacity(0.07)), lineWidth: 1)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "arkit")
                        .font(.system(size: 11))
                        .foregroundStyle(Color(hex: "#C77DFF"))
                    Text("AR SPOT TOUR")
                        .font(.system(size: 11, weight: .black))
                        .tracking(1.5)
                        .foregroundStyle(Color(hex: "#C77DFF"))
                }
                Text("See spots\nbefore you go.")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                Text("\(arSpots.count) locations in augmented reality")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(20)
            .padding(.bottom, 12)

            // Dismiss
            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 32, height: 32)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.top, 56)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .frame(height: 180)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 14))
            TextField("Search spots, cities…", text: $searchText)
                .font(.subheadline)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: - Spot Card

    private func arSpotCard(_ spot: (name: String, file: String, city: String, type: String)) -> some View {
        let typeColor = typeColorHex(spot.type)
        return Button {
            if let url = Bundle.main.url(forResource: spot.file, withExtension: "usdz") {
                selectedURL = url
                AnalyticsService.shared.track(.arPreviewOpened, meta: spot.name)
                showAR = true
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // AR preview area
                ZStack {
                    Color(hex: "#0D0A20")

                    // Wireframe grid effect
                    Canvas { ctx, size in
                        let step: CGFloat = 18
                        for x in stride(from: CGFloat(0), through: size.width, by: step) {
                            var v = Path()
                            v.move(to: CGPoint(x: x, y: 0))
                            v.addLine(to: CGPoint(x: x, y: size.height))
                            ctx.stroke(v, with: .color(Color(hex: "#C77DFF").opacity(0.07)), lineWidth: 0.5)
                        }
                        for y in stride(from: CGFloat(0), through: size.height, by: step) {
                            var h = Path()
                            h.move(to: CGPoint(x: 0, y: y))
                            h.addLine(to: CGPoint(x: size.width, y: y))
                            ctx.stroke(h, with: .color(Color(hex: "#C77DFF").opacity(0.07)), lineWidth: 0.5)
                        }
                    }

                    VStack(spacing: 6) {
                        Image(systemName: "arkit")
                            .font(.system(size: 26))
                            .foregroundStyle(Color(hex: "#C77DFF"))
                        Text("VIEW IN AR")
                            .font(.system(size: 8, weight: .black))
                            .tracking(1.2)
                            .foregroundStyle(Color(hex: "#C77DFF").opacity(0.7))
                    }
                }
                .frame(height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(spot.name)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    HStack(spacing: 5) {
                        Text(spot.city)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        Text("·")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        Text(spot.type)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color(hex: typeColor))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            }
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(hex: "#C77DFF").opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func typeColorHex(_ type: String) -> String {
        switch type {
        case "Park":   return "#34C759"
        case "Shop":   return "#FF9500"
        case "Street": return "#3AB5E6"
        default:       return "#8E8E93"
        }
    }
}
