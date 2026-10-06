import SwiftUI
import SwiftData
import CoreLocation

struct SkateCityHomeView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Query private var allNotifications: [NotificationItem]
    @Query private var allUsers: [AppUser]
    @Query(sort: \LiveSession.startedAt,   order: .reverse) private var recentSessions: [LiveSession]
    @Query(sort: \Trophy.earnedAt,         order: .reverse) private var recentTrophies: [Trophy]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var recentCheckIns: [SpotCheckIn]
    @Query(sort: \Spot.submittedAt,        order: .reverse) private var recentSpots: [Spot]

    @State private var showCustomize     = false
    @State private var showSkateCity     = false
    @State private var showNotifications = false
    @State private var showActivityFeed  = false
    @State private var showDiscover      = false

    private var unreadCount: Int { allNotifications.filter { !$0.isRead }.count }
    @State private var dailyChallenge: SkateChallenge = SKMockData.challenges[0]
    @State private var xpPulse = false
    @State private var gearTab = 0
    @State private var spotGuess        = ""
    @State private var spotAnswered     = false
    @State private var spotCorrect      = false

    private let gearTabs = ["DECK", "GRIP", "TRUCKS", "WHEELS"]

    // Rotates through all spots by day-of-year so it resets daily
    private var dailyKnowledgeSpot: SkateSpot {
        let all = SKMockData.realSpots + SKMockData.fresnoSpots
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return all[(day - 1) % all.count]
    }

    private var nearestShop: SkateShop { SKMockData.shops[0] }
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "What's good"
        case 17..<21: return "Evening sesh?"
        default:      return "Night skate?"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        shopEntryBanner
                        skateCityComingSoonCard
                        levelCard
                        knowTheSpotCard
                        dailyChallengeCard
                        discoverBanner
                        nearbySection
                        crewActivitySection
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("")
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(isPresented: $showCustomize) {
            SkateCityCustomizeSheet()
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        .sheet(isPresented: $showNotifications) {
            NotificationCenterView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showActivityFeed) {
            ActivityFeedView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showDiscover) {
            DiscoverView()
                .presentationBackground(Color.black)
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showSkateCity) {
            SkateCityGameView(
                username: state.profile.handle,
                skinHex: state.profile.avatarStyle.skinTone,
                hoodieHex: state.profile.avatarStyle.top,
                deckHex: boardAccentHex
            )
        }
        #endif
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(greeting),")
                    .font(.subheadline)
                    .foregroundStyle(.skSub)
                Text(state.profile.displayName)
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.skText)
            }
            Spacer()
            HStack(spacing: 10) {
                // Bell with unread badge
                Button { showNotifications = true } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.skText)
                            .frame(width: 44, height: 44)
                            .background(Color.skCard)
                            .clipShape(Circle())
                        if unreadCount > 0 {
                            Text("\(min(unreadCount, 99))")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 4)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(Color.orange)
                                .clipShape(Capsule())
                                .offset(x: 5, y: -5)
                        }
                    }
                }
                // Avatar / customize
                Button { showCustomize = true } label: {
                    SKMiniSkater(style: state.profile.avatarStyle, size: 48)
                        .frame(width: 48, height: 48)
                        .background(Color.skCard)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.skLime, lineWidth: 1.5))
                }
            }
        }
    }

    // MARK: - SkateCity Coming Soon Card

    private var boardAccentHex: String {
        SKMockData.boards.first(where: { $0.id == state.profile.selectedBoard })?.accentHex ?? "#E74C3C"
    }

    private var skateCityComingSoonCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: "#0D1117"), Color(hex: "#1A2332"), Color(hex: "#2D1B4E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))

            // City skyline silhouette
            HStack(alignment: .bottom, spacing: 2) {
                ForEach([24, 38, 28, 52, 34, 44, 20, 58, 30, 42], id: \.self) { h in
                    Rectangle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 12, height: CGFloat(h))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)

            // Lime glow
            Circle()
                .fill(Color.skLime.opacity(0.10))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: 60, y: 20)

            VStack(alignment: .leading, spacing: 8) {
                // Mobile game badge (replaces LIVE WORLD)
                HStack(spacing: 6) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(Color.skLime)
                    Text("MOBILE GAME")
                        .font(.system(size: 10, weight: .black))
                        .tracking(1.5)
                        .foregroundStyle(Color.skLime)
                }
                HStack(spacing: 0) {
                    Text("Skate")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(Color.white)
                    Text("City")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(Color.skLime)
                }
                Text("A standalone skate game. Coming soon.")
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.6))

                Text("COMING SOON")
                    .font(.system(size: 11, weight: .black))
                    .tracking(1.5)
                    .foregroundStyle(Color.skLime.opacity(0.7))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.skLime.opacity(0.08))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.skLime.opacity(0.25), lineWidth: 1))
            }
            .padding(18)
        }
        .frame(height: 162)
    }

    // MARK: - Shop Entry Banner

    private var shopEntryBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: nearestShop.accentColorHex).opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: "storefront.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: nearestShop.accentColorHex))
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(nearestShop.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.skText)
                    if nearestShop.isOpen {
                        Text("OPEN")
                            .font(.system(size: 9, weight: .black))
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }
                Text("\(nearestShop.neighborhood) · \(nearestShop.distanceText)")
                    .font(.caption)
                    .foregroundStyle(.skSub)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.skSub)
        }
        .skCard()
    }

    // MARK: - Level Card

    private var levelCard: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("LVL \(state.profile.level)")
                            .font(.system(size: 22, weight: .black))
                            .foregroundStyle(.skLime)
                        Text(state.profile.crewName)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .background(Color.skMuted)
                            .foregroundStyle(.skSub)
                            .clipShape(Capsule())
                    }
                    Text(state.profile.handle)
                        .font(.caption)
                        .foregroundStyle(.skSub)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.skMuted, lineWidth: 4)
                        .frame(width: 54, height: 54)
                    Circle()
                        .trim(from: 0, to: state.profile.xpProgress)
                        .stroke(Color.skLime, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 54, height: 54)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.8), value: state.profile.xpProgress)
                    Text("\(Int(state.profile.xpProgress * 100))%")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(.skLime)
                }
            }
            SKXPBar(progress: state.profile.xpProgress, xp: state.profile.xp, xpMax: state.profile.xpMax)
        }
        .skCard()
    }

    // MARK: - Know The Spot

    private var knowTheSpotCard: some View {
        let spot = dailyKnowledgeSpot
        let region = spot.coordinate.latitude > 37.0 ? "Bay Area" : "Central Valley"

        return VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.skLime)
                        Text("KNOW THE SPOT")
                            .font(.system(size: 12, weight: .black))
                            .tracking(1.4)
                            .foregroundStyle(Color.skLime)
                    }
                    Text("Daily skate knowledge drop")
                        .font(.system(size: 10))
                        .foregroundStyle(.skSub)
                }
                Spacer()
                Text("DAILY")
                    .font(.system(size: 9, weight: .black))
                    .tracking(1)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.skLime)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 12)

            // Illustration
            SpotIllustrationView(terrainTags: spot.terrainTags)
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 0))

            VStack(alignment: .leading, spacing: 14) {

                // Clue chips
                VStack(alignment: .leading, spacing: 8) {
                    Text("CLUES")
                        .font(.system(size: 9, weight: .black))
                        .tracking(1.2)
                        .foregroundStyle(.skSub)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            clueChip(icon: "square.stack.3d.up.fill",
                                     text: spot.terrainTags.prefix(2).joined(separator: " · "),
                                     color: .skLime)
                            clueChip(icon: "flame.fill",
                                     text: spot.difficulty.rawValue,
                                     color: spot.difficulty.color)
                            clueChip(icon: "skateboard",
                                     text: spot.featuredTrick,
                                     color: .skCoral)
                            clueChip(icon: "location.fill",
                                     text: region,
                                     color: Color(hex: "#3AB5E6"))
                        }
                    }
                }

                if spotAnswered {
                    // Result state
                    HStack(spacing: 12) {
                        Image(systemName: spotCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(spotCorrect ? Color.skLime : Color.skCoral)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(spotCorrect ? "You got it!" : "Not quite.")
                                .font(.subheadline.bold())
                                .foregroundStyle(.skText)
                            Text(spot.name)
                                .font(.caption)
                                .foregroundStyle(.skSub)
                            if spotCorrect {
                                Text("+150 XP earned")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundStyle(.skLime)
                            } else {
                                Text("Check back tomorrow.")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.skSub)
                            }
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color.skMuted)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // Input state
                    VStack(spacing: 10) {
                        TextField("Name this spot…", text: $spotGuess)
                            .font(.subheadline)
                            .foregroundStyle(.skText)
                            .padding(13)
                            .background(Color.skMuted)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.skBorder, lineWidth: 1)
                            )
                            .submitLabel(.done)
                            .onSubmit { submitSpotGuess(spot) }

                        Button { submitSpotGuess(spot) } label: {
                            HStack {
                                Text("LOCK IN")
                                    .font(.system(size: 13, weight: .black))
                                    .tracking(1)
                                Spacer()
                                Text("+150 XP")
                                    .font(.system(size: 12, weight: .black))
                                Image(systemName: "arrow.right")
                                    .font(.caption.weight(.black))
                            }
                            .foregroundStyle(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(spotGuess.trimmingCharacters(in: .whitespaces).isEmpty
                                        ? Color.skMuted : Color.skLime)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(spotGuess.trimmingCharacters(in: .whitespaces).isEmpty)
                        .animation(.easeInOut(duration: 0.15), value: spotGuess.isEmpty)
                    }
                }
            }
            .padding(16)
        }
        .background(Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func clueChip(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.skText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.10))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
    }

    private func submitSpotGuess(_ spot: SkateSpot) {
        let guess = spotGuess.lowercased().trimmingCharacters(in: .whitespaces)
        let name  = spot.name.lowercased()
        let correct = guess.count >= 3 && (name.contains(guess) || guess.contains(name.split(separator: " ").first.map(String.init) ?? ""))
        withAnimation(.spring(response: 0.35)) {
            spotCorrect  = correct
            spotAnswered = true
        }
        if correct { state.earnXP(150) }
    }

    // MARK: - Home Room (Gear Locker)

    private var homeRoomCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            boardLockerSection
        }
        .background(Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // Board picker — DECK / GRIP / TRUCKS / WHEELS tabs
    private var boardLockerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tab row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(Array(gearTabs.enumerated()), id: \.offset) { i, tab in
                        Button { withAnimation(.easeInOut(duration: 0.15)) { gearTab = i } } label: {
                            Text(tab)
                                .font(.system(size: 11, weight: .black))
                                .tracking(1.2)
                                .foregroundStyle(gearTab == i ? .black : .skSub)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(gearTab == i ? Color.skLime : Color.skMuted)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
            }
            .padding(.top, 14)
            .padding(.bottom, 10)

            // Items for selected tab
            if gearTab == 0 {
                // DECK — real board data
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(SKMockData.boards) { board in
                            let selected = state.profile.selectedBoard == board.id
                            Button { state.profile.selectedBoard = board.id } label: {
                                VStack(spacing: 8) {
                                    SKBoardMini(accentHex: board.accentHex, width: 22, height: 60)
                                    Text(board.name)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(selected ? Color(hex: board.accentHex) : .skSub)
                                        .lineLimit(1)
                                        .frame(width: 64)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 8)
                                .frame(width: 80)
                                .background(selected ? Color(hex: board.accentHex).opacity(0.12) : Color.skMuted)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selected ? Color(hex: board.accentHex) : Color.clear, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                }
            } else {
                // GRIP / TRUCKS / WHEELS — color swatches
                let swatches: [(hex: String, label: String)] = gearTab == 1
                    ? [("#1a1b1e","Black"), ("#F5F5DC","Natural"), ("#FF5A35","Coral"), ("#CCFF40","Lime"), ("#C77DFF","Purple")]
                    : gearTab == 2
                    ? [("#AABAC4","Silver"), ("#1a1b1e","Black"), ("#F4D03F","Gold"), ("#E8E8E8","Raw"), ("#C0392B","Red")]
                    : [("#F6EFE0","Cream"), ("#1a1b1e","Black"), ("#FF5A35","Orange"), ("#CCFF40","Lime"), ("#4FC3F7","Blue")]
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(swatches.enumerated()), id: \.offset) { i, swatch in
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: swatch.hex))
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(i == 0 ? Color.skLime : Color.clear, lineWidth: 2))
                                    .shadow(color: .black.opacity(0.3), radius: 2)
                                Text(swatch.label)
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundStyle(i == 0 ? .skLime : .skSub)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                }
                .padding(.bottom, 4)
            }

            // Bottom row — selected board name + confirm
            if let board = SKMockData.boards.first(where: { $0.id == state.profile.selectedBoard }) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(board.name.uppercased())
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(.skText)
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: board.accentHex))
                                .frame(width: 6, height: 6)
                            Text("POWERED")
                                .font(.system(size: 9, weight: .black))
                                .tracking(1)
                                .foregroundStyle(Color(hex: board.accentHex))
                        }
                    }
                    Spacer()
                    Text("LOOKS GOOD JR.")
                        .font(.system(size: 11, weight: .black))
                        .tracking(0.5)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(Color.skLime)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 14)
            }
        }
    }

    // MARK: - Daily Challenge

    private var dailyChallengeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "DAILY CHALLENGE")
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dailyChallenge.title)
                            .font(.headline.bold())
                            .foregroundStyle(.skText)
                        Text(dailyChallenge.shopName)
                            .font(.caption)
                            .foregroundStyle(.skSub)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("+\(dailyChallenge.rewardXP) XP")
                            .font(.system(size: 15, weight: .black))
                            .foregroundStyle(.skLime)
                        Text(dailyChallenge.duration)
                            .font(.caption2)
                            .foregroundStyle(.skSub)
                    }
                }
                Text(dailyChallenge.description)
                    .font(.subheadline)
                    .foregroundStyle(.skSub)
                    .fixedSize(horizontal: false, vertical: true)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        SKTag(label: dailyChallenge.difficulty, color: .skCoral)
                        ForEach(dailyChallenge.trickTags, id: \.self) { tag in
                            SKTag(label: tag, small: true)
                        }
                    }
                }
                SKButton(title: dailyChallenge.isCompleted ? "✓ Done" : "Accept Challenge", style: dailyChallenge.isCompleted ? .ghost : .primary) {
                    if !dailyChallenge.isCompleted {
                        dailyChallenge.isCompleted = true
                        state.earnXP(dailyChallenge.rewardXP)
                    }
                }
            }
            .padding(14)
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .skCard()
    }

    // MARK: - Discover Banner

    private var discoverBanner: some View {
        let hotCount = recentSessions.filter { $0.isActive }.count
        let spotCount = recentSpots.filter { !$0.isRetired }.count
        return Button { showDiscover = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#CCFF40").opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "sparkles")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#CCFF40"))
                }
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Discover Spots")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        if hotCount > 0 {
                            Label("\(hotCount) live", systemImage: "bolt.fill")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color(hex: "#CCFF40"))
                                .clipShape(Capsule())
                        }
                    }
                    Text("\(spotCount) spots · personalized for you")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#CCFF40").opacity(0.18), lineWidth: 1))
        }
    }

    // MARK: - Nearby Energy

    private var nearbySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "NEARBY ENERGY")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SKMockData.shops) { shop in
                        nearbyShopCard(shop)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func nearbyShopCard(_ shop: SkateShop) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: shop.accentColorHex).opacity(0.12))
                    .frame(width: 100, height: 70)
                VStack(spacing: 4) {
                    Image(systemName: "storefront.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: shop.accentColorHex))
                    if shop.isOpen {
                        Text("OPEN")
                            .font(.system(size: 8, weight: .black))
                            .foregroundStyle(.green)
                    } else {
                        Text("CLOSED")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.skSub)
                    }
                }
            }
            Text(shop.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.skText)
                .lineLimit(1)
                .frame(width: 100, alignment: .leading)
            Text(shop.distanceText)
                .font(.system(size: 11))
                .foregroundStyle(.skSub)
        }
    }

    // MARK: - Crew Activity (live)

    private var homeFeedItems: [FeedItem] {
        let username = allUsers.first?.username ?? ""
        guard !username.isEmpty else { return [] }
        return FeedService.shared.buildMyFeed(
            sessions: recentSessions,
            trophies: recentTrophies,
            checkIns: recentCheckIns,
            spots: recentSpots,
            username: username
        )
    }

    private var crewActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SKSectionHeader(title: "YOUR ACTIVITY")
                Spacer()
                Button { showActivityFeed = true } label: {
                    HStack(spacing: 3) {
                        Text("See All")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.skLime)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.skLime)
                    }
                }
            }
            if homeFeedItems.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(.skSub)
                    Text("Start a session to see your activity here.")
                        .font(.caption)
                        .foregroundStyle(.skSub)
                }
                .padding(.vertical, 4)
            } else {
                VStack(spacing: 0) {
                    ForEach(homeFeedItems.prefix(3)) { item in
                        homeFeedRow(item)
                        if item.id != homeFeedItems.prefix(3).last?.id {
                            Divider().background(Color.white.opacity(0.06)).padding(.leading, 50)
                        }
                    }
                }
            }
        }
        .skCard()
    }

    private func homeFeedRow(_ item: FeedItem) -> some View {
        let accent = Color(hex: item.kind.colorHex)
        return HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: item.kind.iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.headline)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.skText)
                Text(item.detail)
                    .font(.caption)
                    .foregroundStyle(.skSub)
                    .lineLimit(1)
            }
            Spacer()
            Text(item.happenedAt.skRelative)
                .font(.system(size: 10))
                .foregroundStyle(.skSub)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Spot Illustration

struct SpotIllustrationView: View {
    let terrainTags: [String]

    private var hasStairs: Bool { terrainTags.contains { $0.lowercased().contains("stair") || $0.lowercased().contains("step") } }
    private var hasBanks:  Bool { terrainTags.contains { $0.lowercased().contains("bank") } }
    private var hasHubba:  Bool { terrainTags.contains { $0.lowercased().contains("hubba") } }
    private var hasManual: Bool { terrainTags.contains { $0.lowercased().contains("manual") } }

    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height

            // ── Background ────────────────────────────────────────────────
            ctx.fill(Path(CGRect(origin: .zero, size: size)),
                     with: .color(Color(hex: "#080C12")))

            // Subtle perspective grid
            let vanishX = w * 0.5, vanishY = h * 0.38
            for i in stride(from: 0, through: 8, by: 1) {
                let t = CGFloat(i) / 8.0
                var gLine = Path()
                gLine.move(to: CGPoint(x: vanishX, y: vanishY))
                gLine.addLine(to: CGPoint(x: w * t, y: h))
                ctx.stroke(gLine, with: .color(Color.white.opacity(0.03)), lineWidth: 1)
            }

            // ── City skyline silhouette ───────────────────────────────────
            let buildingData: [(CGFloat, CGFloat)] = [
                (0.06,0.48),(0.12,0.36),(0.18,0.52),(0.24,0.30),
                (0.30,0.44),(0.36,0.26),(0.56,0.28),(0.62,0.46),
                (0.68,0.33),(0.74,0.50),(0.80,0.38),(0.86,0.54),(0.92,0.29)
            ]
            let groundY = h * 0.68
            for (xFrac, heightFrac) in buildingData {
                let bw: CGFloat = w * 0.055
                let bh = h * heightFrac
                var bld = Path()
                bld.addRect(CGRect(x: w * xFrac, y: groundY - bh, width: bw, height: bh))
                ctx.fill(bld, with: .color(Color.white.opacity(0.045)))
                // Window glow dots
                for row in 0..<3 {
                    for col in 0..<2 {
                        var dot = Path()
                        dot.addEllipse(in: CGRect(
                            x: w * xFrac + bw * 0.2 + CGFloat(col) * bw * 0.4,
                            y: groundY - bh + 6 + CGFloat(row) * 9,
                            width: 2.5, height: 3))
                        ctx.fill(dot, with: .color(Color(hex: "#CCFF40").opacity(0.12)))
                    }
                }
            }

            // ── Ground plane ─────────────────────────────────────────────
            var ground = Path()
            ground.move(to: CGPoint(x: 0, y: groundY))
            ground.addLine(to: CGPoint(x: w, y: groundY))
            ctx.stroke(ground, with: .color(Color.white.opacity(0.18)), lineWidth: 1)

            // Ground fill below
            var groundFill = Path()
            groundFill.addRect(CGRect(x: 0, y: groundY, width: w, height: h - groundY))
            ctx.fill(groundFill, with: .color(Color.white.opacity(0.025)))

            // ── Terrain element ───────────────────────────────────────────
            if hasStairs {
                drawStairs(ctx: ctx, w: w, h: h, groundY: groundY)
            } else if hasBanks {
                drawBanks(ctx: ctx, w: w, h: h, groundY: groundY)
            } else if hasHubba {
                drawHubba(ctx: ctx, w: w, h: h, groundY: groundY)
            } else if hasManual {
                drawManualPad(ctx: ctx, w: w, h: h, groundY: groundY)
            } else {
                drawLedge(ctx: ctx, w: w, h: h, groundY: groundY)
            }

            // ── Lime corner glow ─────────────────────────────────────────
            var glow = Path()
            glow.addEllipse(in: CGRect(x: w * 0.55, y: h * 0.55, width: w * 0.5, height: h * 0.3))
            ctx.fill(glow, with: .color(Color(hex: "#CCFF40").opacity(0.055)))
        }
    }

    // ── Terrain drawings ──────────────────────────────────────────────────

    private func drawStairs(ctx: GraphicsContext, w: CGFloat, h: CGFloat, groundY: CGFloat) {
        let steps = 6
        let sw = w * 0.11, sh = h * 0.058
        let startX = w * 0.18, startY = groundY

        // Step fill + outline
        for i in 0..<steps {
            let x = startX + CGFloat(i) * sw
            let y = startY - CGFloat(i + 1) * sh
            var step = Path()
            step.addRect(CGRect(x: x, y: y, width: sw, height: sh * CGFloat(i + 1)))
            ctx.fill(step, with: .color(Color.white.opacity(0.07)))
            var edge = Path()
            edge.move(to: CGPoint(x: x, y: y))
            edge.addLine(to: CGPoint(x: x + sw, y: y))
            edge.addLine(to: CGPoint(x: x + sw, y: groundY))
            ctx.stroke(edge, with: .color(Color.white.opacity(0.35)), lineWidth: 1.5)
        }

        // Handrail
        var rail = Path()
        rail.move(to: CGPoint(x: startX + sw * 0.5, y: groundY - sh * 0.8))
        rail.addLine(to: CGPoint(x: startX + CGFloat(steps) * sw + sw * 0.5,
                                  y: groundY - CGFloat(steps + 1) * sh + sh * 0.8))
        ctx.stroke(rail, with: .color(Color(hex: "#CCFF40").opacity(0.7)), lineWidth: 2)

        // Rail end caps
        for pt in [CGPoint(x: startX + sw * 0.5, y: groundY - sh * 0.8),
                   CGPoint(x: startX + CGFloat(steps) * sw + sw * 0.5,
                           y: groundY - CGFloat(steps + 1) * sh + sh * 0.8)] {
            var cap = Path()
            cap.addEllipse(in: CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6))
            ctx.fill(cap, with: .color(Color(hex: "#CCFF40").opacity(0.8)))
        }
    }

    private func drawLedge(ctx: GraphicsContext, w: CGFloat, h: CGFloat, groundY: CGFloat) {
        let lx = w * 0.15, ly = groundY - h * 0.14
        let lw = w * 0.7, lh = h * 0.05

        // Ledge body
        var ledge = Path()
        ledge.addRect(CGRect(x: lx, y: ly, width: lw, height: lh))
        ctx.fill(ledge, with: .color(Color.white.opacity(0.08)))

        // Ledge top edge (waxed highlight)
        var topEdge = Path()
        topEdge.move(to: CGPoint(x: lx, y: ly))
        topEdge.addLine(to: CGPoint(x: lx + lw, y: ly))
        ctx.stroke(topEdge, with: .color(Color(hex: "#CCFF40").opacity(0.7)), lineWidth: 2.5)

        // Ledge front face
        var front = Path()
        front.move(to: CGPoint(x: lx, y: ly + lh))
        front.addLine(to: CGPoint(x: lx + lw, y: ly + lh))
        ctx.stroke(front, with: .color(Color.white.opacity(0.25)), lineWidth: 1)

        // Support blocks under ledge
        for xPos in [lx + lw * 0.15, lx + lw * 0.5, lx + lw * 0.82] {
            var block = Path()
            block.addRect(CGRect(x: xPos - 8, y: ly + lh, width: 16, height: groundY - ly - lh))
            ctx.fill(block, with: .color(Color.white.opacity(0.06)))
            ctx.stroke(block, with: .color(Color.white.opacity(0.15)), lineWidth: 1)
        }
    }

    private func drawBanks(ctx: GraphicsContext, w: CGFloat, h: CGFloat, groundY: CGFloat) {
        let bankH = h * 0.28

        // Left bank
        var leftBank = Path()
        leftBank.move(to: CGPoint(x: w * 0.15, y: groundY))
        leftBank.addLine(to: CGPoint(x: w * 0.45, y: groundY))
        leftBank.addLine(to: CGPoint(x: w * 0.15, y: groundY - bankH))
        leftBank.closeSubpath()
        ctx.fill(leftBank, with: .color(Color.white.opacity(0.07)))
        ctx.stroke(leftBank, with: .color(Color.white.opacity(0.3)), lineWidth: 1.5)

        // Right bank
        var rightBank = Path()
        rightBank.move(to: CGPoint(x: w * 0.55, y: groundY))
        rightBank.addLine(to: CGPoint(x: w * 0.85, y: groundY))
        rightBank.addLine(to: CGPoint(x: w * 0.85, y: groundY - bankH))
        rightBank.closeSubpath()
        ctx.fill(rightBank, with: .color(Color.white.opacity(0.07)))
        ctx.stroke(rightBank, with: .color(Color.white.opacity(0.3)), lineWidth: 1.5)

        // Center channel lime line
        var channel = Path()
        channel.move(to: CGPoint(x: w * 0.45, y: groundY))
        channel.addLine(to: CGPoint(x: w * 0.55, y: groundY))
        ctx.stroke(channel, with: .color(Color(hex: "#CCFF40").opacity(0.8)), lineWidth: 3)
    }

    private func drawHubba(ctx: GraphicsContext, w: CGFloat, h: CGFloat, groundY: CGFloat) {
        let steps = 4
        let sw = w * 0.09, sh = h * 0.055
        let startX = w * 0.25

        // Steps
        for i in 0..<steps {
            let x = startX + CGFloat(i) * sw
            let y = groundY - CGFloat(i + 1) * sh
            var s = Path()
            s.addRect(CGRect(x: x, y: y, width: sw, height: sh * CGFloat(i + 1)))
            ctx.fill(s, with: .color(Color.white.opacity(0.07)))
            var e = Path()
            e.move(to: CGPoint(x: x, y: y))
            e.addLine(to: CGPoint(x: x + sw, y: y))
            ctx.stroke(e, with: .color(Color.white.opacity(0.3)), lineWidth: 1.2)
        }

        // Hubba ledge along the side — the diagonal stone
        let hubbaStartX = startX, hubbaStartY = groundY - sh
        let hubbaEndX   = startX + CGFloat(steps) * sw
        let hubbaEndY   = groundY - CGFloat(steps + 1) * sh

        var hubba = Path()
        hubba.move(to: CGPoint(x: hubbaStartX - 6, y: hubbaStartY))
        hubba.addLine(to: CGPoint(x: hubbaEndX - 6, y: hubbaEndY))
        hubba.addLine(to: CGPoint(x: hubbaEndX + 6, y: hubbaEndY))
        hubba.addLine(to: CGPoint(x: hubbaStartX + 6, y: hubbaStartY))
        hubba.closeSubpath()
        ctx.fill(hubba, with: .color(Color.white.opacity(0.12)))
        ctx.stroke(hubba, with: .color(Color(hex: "#CCFF40").opacity(0.75)), lineWidth: 2)
    }

    private func drawManualPad(ctx: GraphicsContext, w: CGFloat, h: CGFloat, groundY: CGFloat) {
        let padW = w * 0.6, padH = h * 0.04, padH2 = h * 0.02
        let px = w * 0.2, py = groundY - padH

        // Pad top surface
        var top = Path()
        top.addRect(CGRect(x: px, y: py, width: padW, height: padH))
        ctx.fill(top, with: .color(Color.white.opacity(0.09)))

        // Top edge (waxed)
        var topLine = Path()
        topLine.move(to: CGPoint(x: px, y: py))
        topLine.addLine(to: CGPoint(x: px + padW, y: py))
        ctx.stroke(topLine, with: .color(Color(hex: "#CCFF40").opacity(0.75)), lineWidth: 2.5)

        // Side bevel
        var side = Path()
        side.move(to: CGPoint(x: px, y: py))
        side.addLine(to: CGPoint(x: px - padH2 * 1.5, y: py + padH))
        side.addLine(to: CGPoint(x: px, y: py + padH))
        side.closeSubpath()
        ctx.fill(side, with: .color(Color.white.opacity(0.05)))
        ctx.stroke(side, with: .color(Color.white.opacity(0.2)), lineWidth: 1)

        // Wheel track lines on top
        for xOff in [padW * 0.25, padW * 0.75] {
            var track = Path()
            track.move(to: CGPoint(x: px + xOff, y: py + 2))
            track.addLine(to: CGPoint(x: px + xOff, y: py + padH - 2))
            ctx.stroke(track, with: .color(Color(hex: "#CCFF40").opacity(0.25)), lineWidth: 1)
        }
    }
}
