import SwiftUI
import SwiftData

// MARK: - Trick Tracker View

struct TrickTrackerView: View {
    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query(sort: \PersonalTrick.addedAt, order: .reverse) private var allTricks: [PersonalTrick]
    @Query private var users: [AppUser]

    @State private var selectedCategory: TrickCategory? = nil
    @State private var showAdd = false
    @State private var searchText = ""

    private var currentUsername: String { users.first?.username ?? "" }

    private var myTricks: [PersonalTrick] {
        allTricks.filter { $0.username == currentUsername }
    }

    private var filtered: [PersonalTrick] {
        myTricks.filter { trick in
            let matchCat  = selectedCategory == nil || trick.category == selectedCategory
            let matchText = searchText.isEmpty || trick.name.localizedCaseInsensitiveContains(searchText)
            return matchCat && matchText
        }
    }

    private func tricks(for status: TrickStatus) -> [PersonalTrick] {
        filtered.filter { $0.status == status }
            .sorted { $0.difficulty.rawValue > $1.difficulty.rawValue }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    statsRow
                    searchBar
                    categoryFilter
                    Divider().background(Color.white.opacity(0.07))
                    tricksList
                }
            }
            .navigationTitle("Trick Tracker")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddTrickSheet(username: currentUsername)
                    .presentationBackground(Color.black)
            }
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            ForEach(TrickStatus.allCases) { status in
                let count = myTricks.filter { $0.status == status }.count
                VStack(spacing: 4) {
                    Text("\(count)")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(Color(hex: status.colorHex))
                    Text(status.label)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                if status != TrickStatus.allCases.last {
                    Divider().frame(height: 32).background(Color.white.opacity(0.1))
                }
            }
        }
        .background(Color.white.opacity(0.05))
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search tricks…", text: $searchText)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All pill
                filterPill(label: "All", colorHex: "#CCFF40", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(TrickCategory.allCases) { cat in
                    filterPill(label: cat.label, colorHex: cat.colorHex,
                               isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func filterPill(label: String, colorHex: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: isSelected ? .black : .regular))
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(isSelected ? Color(hex: colorHex) : Color.white.opacity(0.07))
                .foregroundStyle(isSelected ? Color.black : Color.secondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tricks List

    @ViewBuilder
    private var tricksList: some View {
        if myTricks.isEmpty {
            emptyState
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(TrickStatus.allCases) { status in
                        let section = tricks(for: status)
                        if !section.isEmpty {
                            Section {
                                ForEach(section) { trick in
                                    trickRow(trick)
                                        .swipeActions(edge: .leading) {
                                            if trick.status != .landed {
                                                Button {
                                                    withAnimation { trick.setStatus(trick.status.nextStatus) }
                                                    try? modelContext.save()
                                                } label: {
                                                    Label(trick.status == .wantToLearn ? "Learning" : "Landed!",
                                                          systemImage: trick.status == .wantToLearn ? "arrow.triangle.2.circlepath" : "checkmark.circle.fill")
                                                }
                                                .tint(Color(hex: trick.status.nextStatus.colorHex))
                                            }
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                modelContext.delete(trick)
                                                try? modelContext.save()
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            } header: {
                                statusHeader(status, count: section.count)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }

    private func statusHeader(_ status: TrickStatus, count: Int) -> some View {
        HStack(spacing: 8) {
            Image(systemName: status.icon)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: status.colorHex))
            Text(status.label.uppercased())
                .font(.system(size: 10, weight: .black))
                .tracking(1.0)
                .foregroundStyle(Color(hex: status.colorHex))
            Text("\(count)")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.black)
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(Color(hex: status.colorHex))
                .clipShape(Capsule())
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black)
    }

    @ViewBuilder
    private func trickRow(_ trick: PersonalTrick) -> some View {
        HStack(spacing: 14) {
            // Status indicator
            Image(systemName: trick.status.icon)
                .font(.system(size: 18))
                .foregroundStyle(Color(hex: trick.status.colorHex))
                .frame(width: 28)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(trick.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    // Category pill
                    Text(trick.category.label)
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(Color(hex: trick.category.colorHex))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: trick.category.colorHex).opacity(0.12))
                        .clipShape(Capsule())

                    // Difficulty stars
                    Text(trick.difficulty.stars)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: "#FFD700"))

                    if let landedAt = trick.landedAt, trick.status == .landed {
                        Text("·").font(.caption2).foregroundStyle(.secondary)
                        Text(landedAt.skRelative)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            // Advance status button (not shown if already landed)
            if trick.status != .landed {
                Button {
                    withAnimation(.spring(response: 0.3)) { trick.setStatus(trick.status.nextStatus) }
                    try? modelContext.save()
                } label: {
                    Image(systemName: trick.status == .wantToLearn
                          ? "arrow.triangle.2.circlepath.circle"
                          : "checkmark.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: trick.status.nextStatus.colorHex))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)

        Divider().background(Color.white.opacity(0.06)).padding(.leading, 58)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "list.star")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No tricks tracked yet")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Start adding tricks you can land,\nare working on, or want to learn.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button { showAdd = true } label: {
                Text("Add Your First Trick")
                    .font(.subheadline.weight(.black))
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.orange)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
            Spacer()
        }
    }
}

// MARK: - Add Trick Sheet

struct AddTrickSheet: View {
    let username: String

    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext

    @State private var trickName     = ""
    @State private var category      = TrickCategory.flatground
    @State private var difficulty    = TrickDifficulty.intermediate
    @State private var status        = TrickStatus.wantToLearn
    @State private var showSuggestions = true

    private var canSave: Bool { !trickName.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Trick name
                        trickNameField

                        // Suggestions
                        if showSuggestions {
                            suggestionGrid
                        }

                        // Category picker
                        categoryPicker

                        // Difficulty
                        difficultyPicker

                        // Status
                        statusPicker

                        Spacer(minLength: 24)
                        saveButton
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Add a Trick")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Trick Name

    private var trickNameField: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("TRICK NAME")
            HStack {
                TextField("e.g. Kickflip, Nosegrind…", text: $trickName)
                    .foregroundStyle(Color.white)
                    .autocorrectionDisabled()
                    .onChange(of: trickName) { _, new in
                        showSuggestions = new.isEmpty
                    }
                if !trickName.isEmpty {
                    Button { trickName = ""; showSuggestions = true } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Suggestion Grid

    private var suggestionGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("QUICK ADD — \(category.label.uppercased())")
            FlowLayoutTrick(spacing: 7) {
                ForEach(category.suggestions, id: \.self) { name in
                    Button {
                        trickName = name
                        showSuggestions = false
                    } label: {
                        Text(name)
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Color.white.opacity(0.08))
                            .foregroundStyle(.secondary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("CATEGORY")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(TrickCategory.allCases) { cat in
                        let isSelected = category == cat
                        Button { withAnimation(.spring(response: 0.25)) { category = cat } } label: {
                            VStack(spacing: 4) {
                                Text(cat.emoji).font(.system(size: 18))
                                Text(cat.label)
                                    .font(.system(size: 9, weight: isSelected ? .black : .regular))
                                    .foregroundStyle(isSelected ? Color(hex: cat.colorHex) : Color.secondary)
                            }
                            .frame(width: 72)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color(hex: cat.colorHex).opacity(0.12) : Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color(hex: cat.colorHex).opacity(0.4) : Color.clear, lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Difficulty Picker

    private var difficultyPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("DIFFICULTY")
            HStack(spacing: 8) {
                ForEach(TrickDifficulty.allCases) { d in
                    let isSelected = difficulty == d
                    Button { withAnimation(.spring(response: 0.25)) { difficulty = d } } label: {
                        VStack(spacing: 4) {
                            Text(String(repeating: "★", count: d.rawValue))
                                .font(.system(size: 13))
                                .foregroundStyle(isSelected ? Color(hex: "#FFD700") : Color.secondary.opacity(0.5))
                            Text(d.label)
                                .font(.system(size: 8, weight: isSelected ? .black : .regular))
                                .foregroundStyle(isSelected ? Color(hex: "#FFD700") : Color.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color(hex: "#FFD700").opacity(0.10) : Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color(hex: "#FFD700").opacity(0.4) : Color.clear, lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Status Picker

    private var statusPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("STATUS")
            HStack(spacing: 8) {
                ForEach(TrickStatus.allCases) { s in
                    let isSelected = status == s
                    Button { withAnimation(.spring(response: 0.25)) { status = s } } label: {
                        VStack(spacing: 5) {
                            Image(systemName: s.icon)
                                .font(.system(size: 18))
                                .foregroundStyle(isSelected ? Color(hex: s.colorHex) : Color.secondary.opacity(0.5))
                            Text(s.label)
                                .font(.system(size: 9, weight: isSelected ? .black : .regular))
                                .foregroundStyle(isSelected ? Color(hex: s.colorHex) : Color.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color(hex: s.colorHex).opacity(0.12) : Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color(hex: s.colorHex).opacity(0.4) : Color.clear, lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Save

    private var saveButton: some View {
        Button { save() } label: {
            Text("ADD TRICK")
                .font(.headline.weight(.black))
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(canSave ? Color.orange : Color.white.opacity(0.10))
                .foregroundStyle(canSave ? Color.black : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!canSave)
    }

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .black))
            .tracking(1.0)
            .foregroundStyle(.secondary)
    }

    private func save() {
        let name = trickName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        let trick = PersonalTrick(username: username, name: name,
                                  category: category, difficulty: difficulty, status: status)
        modelContext.insert(trick)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Flow Layout (reused from SkateJournalView, renamed to avoid conflict)

private struct FlowLayoutTrick: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0; var y: CGFloat = 0; var rowH: CGFloat = 0
        for view in subviews {
            let s = view.sizeThatFits(.unspecified)
            if x + s.width > maxWidth, x > 0 { y += rowH + spacing; x = 0; rowH = 0 }
            rowH = max(rowH, s.height); x += s.width + spacing
        }
        return CGSize(width: maxWidth, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x = bounds.minX; var y = bounds.minY; var rowH: CGFloat = 0
        for view in subviews {
            let s = view.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX, x > bounds.minX { y += rowH + spacing; x = bounds.minX; rowH = 0 }
            view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            rowH = max(rowH, s.height); x += s.width + spacing
        }
    }
}
