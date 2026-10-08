import SwiftUI
import SwiftData

// MARK: - Skate Coach
// Personalized practice plans derived from the user's own trick tracker, sessions,
// and journal data. Gated behind StreetSesh Pro.

struct SkateCoachView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var tricks: [PersonalTrick]
    @Query(sort: \SessionNote.date, order: .reverse)  private var notes: [SessionNote]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var checkIns: [SpotCheckIn]

    @State private var activeTab: CoachTab = .plan
    @State private var generatingPlan      = false
    @State private var practicePlan: [PracticeItem] = []
    @State private var showPaywall         = false

    private let store = StoreKitManager.shared

    enum CoachTab: String, CaseIterable {
        case plan  = "Practice Plan"
        case stats = "My Stats"
        case goals = "Goals"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    if store.isPro {
                        tabBar
                        Group {
                            switch activeTab {
                            case .plan:  planTab
                            case .stats: statsTab
                            case .goals: goalsTab
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: activeTab)
                    } else {
                        lockedState
                    }
                }
            }
            .navigationTitle("Skate Coach")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                if store.isPro {
                    ToolbarItem(placement: .primaryAction) {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(Color(hex: "#FFD700"))
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                ProPaywallView().presentationBackground(Color.black)
            }
            .task {
                AnalyticsService.shared.track(.featureOpened, meta: "skate_coach")
                if store.isPro && practicePlan.isEmpty {
                    await generatePlan()
                }
            }
        }
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(CoachTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.snappy) { activeTab = tab }
                } label: {
                    VStack(spacing: 0) {
                        Text(tab.rawValue)
                            .font(.system(size: 13, weight: .black))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(activeTab == tab ? Color.white : Color.secondary)
                        Rectangle()
                            .fill(activeTab == tab ? Color(hex: "#C77DFF") : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .background(Color.white.opacity(0.04))
    }

    // MARK: - Practice Plan Tab

    private var planTab: some View {
        Group {
            if generatingPlan {
                generatingState
            } else if practicePlan.isEmpty {
                emptyPlanState
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        planHeader
                        ForEach(practicePlan) { item in practiceCard(item) }
                        refreshButton
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private var generatingState: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView().tint(Color(hex: "#C77DFF"))
            Text("Analyzing your skate data…")
                .font(.subheadline).foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var emptyPlanState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .foregroundStyle(Color(hex: "#C77DFF"))
            Text("Ready to coach.")
                .font(.title3.bold()).foregroundStyle(.white)
            Text("Generates a plan based on your trick tracker and session history.")
                .font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 32)
            Button { Task { await generatePlan() } } label: {
                Text("Generate Plan")
                    .font(.system(size: 14, weight: .black)).foregroundStyle(.black)
                    .padding(.horizontal, 28).padding(.vertical, 13)
                    .background(Color(hex: "#C77DFF")).clipShape(Capsule())
            }
            Spacer()
        }
    }

    private var planHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TODAY'S FOCUS")
                .font(.system(size: 10, weight: .black))
                .tracking(1.2)
                .foregroundStyle(Color(hex: "#C77DFF").opacity(0.8))
            Text("Personalized practice plan")
                .font(.title3.bold()).foregroundStyle(.white)
            Text("Based on \(tricks.filter { $0.status == .learning }.count) tricks in progress · \(recentSessionCount) sessions this month")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#C77DFF").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func practiceCard(_ item: PracticeItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: item.colorHex).opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: item.icon)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: item.colorHex))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.subheadline.bold()).foregroundStyle(.white)
                    Text(item.category)
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(item.reps)")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(Color(hex: item.colorHex))
                    Text("reps")
                        .font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }
            Text(item.tip)
                .font(.caption).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var refreshButton: some View {
        Button { Task { await generatePlan() } } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh Plan")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color(hex: "#C77DFF"))
            .frame(maxWidth: .infinity).padding(.vertical, 12)
            .background(Color(hex: "#C77DFF").opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Stats Tab

    private var statsTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                HStack(spacing: 10) {
                    statBox("\(tricks.filter { $0.status == .landed }.count)",  label: "Landed",   color: "#34C759")
                    statBox("\(tricks.filter { $0.status == .learning }.count)", label: "Learning", color: "#FF9500")
                    statBox("\(recentSessionCount)", label: "Sessions\nThis Month", color: "#3AB5E6")
                }
                categoryBreakdownCard
                if !notes.isEmpty { moodTrendCard }
            }
            .padding(16).padding(.bottom, 40)
        }
    }

    private func statBox(_ value: String, label: String, color: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(Color(hex: color))
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 16)
        .background(Color(hex: color).opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var categoryBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BY CATEGORY")
                .font(.system(size: 10, weight: .black)).tracking(1.2).foregroundStyle(.secondary)
            ForEach(TrickCategory.allCases) { cat in
                let landed = tricks.filter { $0.category == cat && $0.status == .landed }.count
                let total  = tricks.filter { $0.category == cat }.count
                if total > 0 { categoryRow(cat: cat, landed: landed, total: total) }
            }
            if tricks.isEmpty {
                Text("Add tricks to your tracker to see your breakdown.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func categoryRow(cat: TrickCategory, landed: Int, total: Int) -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(cat.emoji + " " + cat.label)
                    .font(.caption.weight(.semibold)).foregroundStyle(.white)
                Spacer()
                Text("\(landed) / \(total)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08)).frame(height: 4)
                    Capsule()
                        .fill(Color(hex: cat.colorHex))
                        .frame(width: total > 0 ? g.size.width * CGFloat(landed) / CGFloat(total) : 0,
                               height: 4)
                }
            }
            .frame(height: 4)
        }
    }

    private var moodTrendCard: some View {
        let recent = Array(notes.prefix(7))
        let moods  = recent.map { NoteMood(rawValue: $0.moodRaw) ?? .solid }
        let stoked = moods.filter { $0 == .stoked }.count
        let frustrated = moods.filter { $0 == .frustrated }.count
        let vibe = stoked > frustrated
            ? "You're in a good headspace. Push the tricks you've been learning."
            : "Consider a lighter session — rest is part of progression."

        return VStack(alignment: .leading, spacing: 10) {
            Text("RECENT VIBE")
                .font(.system(size: 10, weight: .black)).tracking(1.2).foregroundStyle(.secondary)
            HStack(spacing: 8) {
                ForEach(moods.indices, id: \.self) { i in
                    Text(moods[i].emoji).font(.title2)
                }
            }
            Text(vibe).font(.caption).foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Goals Tab

    private var goalsTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                let learning     = tricks.filter { $0.status == .learning }
                let wantToLearn  = tricks.filter { $0.status == .wantToLearn }
                if !learning.isEmpty {
                    goalSection("ACTIVE GOALS", icon: "arrow.triangle.2.circlepath",
                                color: "#FF9500", tricks: Array(learning.prefix(6)))
                }
                if !wantToLearn.isEmpty {
                    goalSection("QUEUED UP", icon: "bookmark.circle.fill",
                                color: "#8E8E93", tricks: Array(wantToLearn.prefix(6)))
                }
                if learning.isEmpty && wantToLearn.isEmpty {
                    noGoalsPlaceholder
                }
            }
            .padding(16).padding(.bottom, 40)
        }
    }

    private func goalSection(_ title: String, icon: String, color: String, tricks: [PersonalTrick]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 10)).foregroundStyle(Color(hex: color))
                Text(title)
                    .font(.system(size: 10, weight: .black)).tracking(1.2)
                    .foregroundStyle(Color(hex: color).opacity(0.85))
            }
            ForEach(tricks) { trick in
                HStack(spacing: 12) {
                    Text(trick.category.emoji).font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(trick.name).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                        Text(trick.category.label + " · " + trick.difficulty.stars)
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var noGoalsPlaceholder: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)
            Image(systemName: "flag.fill")
                .font(.system(size: 40)).foregroundStyle(Color(hex: "#C77DFF"))
            Text("No goals yet.")
                .font(.title3.bold()).foregroundStyle(.white)
            Text("Mark tricks as 'Learning' or 'Want to Learn' in your Trick Tracker to set goals.")
                .font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 32)
        }
    }

    // MARK: - Locked State

    private var lockedState: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle().fill(Color(hex: "#C77DFF").opacity(0.15)).frame(width: 100, height: 100)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 44)).foregroundStyle(Color(hex: "#C77DFF"))
            }
            VStack(spacing: 8) {
                Text("Skate Coach")
                    .font(.system(size: 28, weight: .black)).foregroundStyle(.white)
                Text("Personalized practice plans, goal tracking, and mood-aware coaching — all from your own skate data.")
                    .font(.subheadline).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 32)
            }
            Button { showPaywall = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill").font(.system(size: 14))
                    Text("Unlock with Pro")
                        .font(.system(size: 15, weight: .black))
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity).frame(height: 54)
                .background(Color(hex: "#C77DFF"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)
            }
            Spacer()
        }
    }

    // MARK: - Helpers

    private var recentSessionCount: Int {
        let cutoff = Date().addingTimeInterval(-30 * 86400)
        return checkIns.filter { $0.checkedInAt >= cutoff }.count
    }

    @MainActor
    private func generatePlan() async {
        generatingPlan = true
        try? await Task.sleep(for: .seconds(1.1))
        practicePlan = buildPlan()
        generatingPlan = false
        AnalyticsService.shared.track(.coachPlanGenerated)
    }

    private func buildPlan() -> [PracticeItem] {
        var items: [PracticeItem] = []

        // Warm-up: cleanest landed flatground trick
        let warmup = tricks.first {
            $0.status == .landed && $0.category == .flatground && $0.difficulty.rawValue <= 2
        }
        items.append(PracticeItem(
            title: warmup?.name ?? "Ollies",
            category: "Warm-up",
            reps: 15,
            icon: "skateboard.fill",
            colorHex: "#3AB5E6",
            tip: "Loosen up. Consistent, clean execution — focus on board feel."
        ))

        // Focus: up to 3 tricks in learning state
        for trick in tricks.filter({ $0.status == .learning }).prefix(3) {
            let reps = max(5, 18 - trick.difficulty.rawValue * 2)
            items.append(PracticeItem(
                title: trick.name,
                category: trick.category.label + " Focus",
                reps: reps,
                icon: "figure.skating",
                colorHex: trick.category.colorHex,
                tip: categoryTip(for: trick.category)
            ))
        }

        // Explore: first want-to-learn trick
        if let next = tricks.first(where: { $0.status == .wantToLearn }) {
            items.append(PracticeItem(
                title: next.name,
                category: "Explore",
                reps: 3,
                icon: "lightbulb.fill",
                colorHex: "#FFD700",
                tip: "Just a few tries. Plant the seed — don't force it today."
            ))
        }

        // Fallback if trick tracker is empty
        if items.count == 1 {
            items.append(PracticeItem(
                title: "Kickflips",
                category: "Flatground Focus",
                reps: 10,
                icon: "figure.skating",
                colorHex: "#FF9500",
                tip: "Add tricks to your Trick Tracker for a fully personalized plan."
            ))
        }

        return items
    }

    private func categoryTip(for cat: TrickCategory) -> String {
        switch cat {
        case .flatground:  return "Focus on pop timing and shoulder rotation. Film from the side."
        case .grinds:      return "Approach at 45°. Lock in the grind position before committing."
        case .manual:      return "Weight over the back bolts. Look ahead, not at the ground."
        case .park:        return "Commit fully — hesitation causes falls. Drop in with purpose."
        case .street:      return "Scout the landing first. Approach speed matters more than you think."
        case .nollieSwtch: return "Your rotation is different from regular. Go slow to build muscle memory."
        }
    }
}

// MARK: - Practice Item Model

struct PracticeItem: Identifiable {
    let id       = UUID()
    let title:    String
    let category: String
    let reps:     Int
    let icon:     String
    let colorHex: String
    let tip:      String
}
