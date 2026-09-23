import SwiftUI

struct SkateCityHomeView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @State private var showCustomize = false
    @State private var dailyChallenge: SkateChallenge = SKMockData.challenges[0]
    @State private var xpPulse = false

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
                        levelCard
                        homeRoomCard
                        dailyChallengeCard
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
            Button { showCustomize = true } label: {
                SKMiniSkater(style: state.profile.avatarStyle, size: 48)
                    .frame(width: 48, height: 48)
                    .background(Color.skCard)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.skLime, lineWidth: 1.5))
            }
        }
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

    // MARK: - Home Room

    private var homeRoomCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "HOME ROOM") { showCustomize = true }
                .padding(.bottom, 4)
            SKRoomIllustration(
                theme: state.profile.homeTheme,
                boardAccentHex: SKMockData.boards.first(where: { $0.id == state.profile.selectedBoard })?.accentHex ?? "#CCFF40",
                avatarStyle: state.profile.avatarStyle
            )
            .frame(height: 140)
            HStack(spacing: 8) {
                SKTag(label: state.profile.homeTheme.rawValue)
                if let board = SKMockData.boards.first(where: { $0.id == state.profile.selectedBoard }) {
                    SKTag(label: board.name, color: Color(hex: board.accentHex))
                }
                Spacer()
                Button { showCustomize = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Customize")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.skLime)
                }
            }
        }
        .skCard()
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

    // MARK: - Crew Activity

    private var crewActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "CREW ACTIVITY")
            VStack(spacing: 10) {
                ForEach(state.clips.prefix(3)) { clip in
                    crewClipRow(clip)
                }
            }
        }
        .skCard()
    }

    private func crewClipRow(_ clip: SkateClip) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.skMuted)
                    .frame(width: 38, height: 38)
                Text(String(clip.creatorName.prefix(1)))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.skLime)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(clip.creatorName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.skText)
                Text(clip.challengeTitle)
                    .font(.caption)
                    .foregroundStyle(.skSub)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(clip.score)")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(.skLime)
                Text(clip.createdAt.skRelative)
                    .font(.caption2)
                    .foregroundStyle(.skSub)
            }
        }
    }
}
