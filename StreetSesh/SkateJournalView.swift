import SwiftUI
import SwiftData

// MARK: - Journal View

struct SkateJournalView: View {
    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query(sort: \SessionNote.date, order: .reverse) private var notes: [SessionNote]
    @Query private var checkIns: [SpotCheckIn]
    @Query private var users:    [AppUser]

    @State private var searchText = ""
    @State private var showAdd    = false
    @State private var editTarget: SessionNote? = nil

    private var currentUsername: String { users.first?.username ?? "" }

    private var recentSpotNames: [String] {
        let myCheckIns = checkIns.filter { $0.username == currentUsername }
        var seen = Set<String>()
        return myCheckIns.compactMap { seen.insert($0.spotName).inserted ? $0.spotName : nil }
            .prefix(20)
            .map { $0 }
    }

    private var filteredNotes: [SessionNote] {
        guard !searchText.isEmpty else { return notes }
        let q = searchText.lowercased()
        return notes.filter {
            $0.text.lowercased().contains(q) ||
            $0.spotName.lowercased().contains(q) ||
            $0.tags.contains { $0.lowercased().contains(q) }
        }
    }

    private var groupedNotes: [(key: String, notes: [SessionNote])] {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: filteredNotes) { fmt.string(from: $0.date) }
        return grouped.map { (key: $0.key, notes: $0.value) }
            .sorted { a, b in
                let af = fmt.date(from: a.key) ?? .distantPast
                let bf = fmt.date(from: b.key) ?? .distantPast
                return af > bf
            }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                Group {
                    if notes.isEmpty {
                        emptyState
                    } else {
                        notesList
                    }
                }
            }
            .navigationTitle("Skate Journal")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddJournalEntrySheet(recentSpots: recentSpotNames)
                    .presentationBackground(Color.black)
            }
            .sheet(item: $editTarget) { note in
                AddJournalEntrySheet(editingNote: note, recentSpots: recentSpotNames)
                    .presentationBackground(Color.black)
            }
        }
    }

    // MARK: - Notes List

    private var notesList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                if filteredNotes.isEmpty {
                    noResultsState
                } else {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(groupedNotes, id: \.key) { group in
                            Section {
                                ForEach(group.notes) { note in
                                    noteRow(note)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                modelContext.delete(note)
                                                try? modelContext.save()
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            Button {
                                                editTarget = note
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.orange)
                                        }
                                }
                            } header: {
                                monthHeader(group.key)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search entries…", text: $searchText)
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
    }

    private func monthHeader(_ title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .black))
                .tracking(1.0)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black)
    }

    @ViewBuilder
    private func noteRow(_ note: SessionNote) -> some View {
        Button { editTarget = note } label: {
            HStack(spacing: 14) {
                // Mood indicator
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: note.mood.colorHex).opacity(0.15))
                            .frame(width: 36, height: 36)
                        Text(note.mood.emoji)
                            .font(.system(size: 17))
                    }
                    Spacer(minLength: 0)
                }

                // Content
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 6) {
                        if !note.spotName.isEmpty {
                            Text(note.spotName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(note.date.skRelative)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Text(note.text)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if !note.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 5) {
                                ForEach(note.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundStyle(Color(hex: note.mood.colorHex))
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 3)
                                        .background(Color(hex: note.mood.colorHex).opacity(0.12))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)

        Divider()
            .background(Color.white.opacity(0.06))
            .padding(.leading, 66)
    }

    // MARK: - Empty / No Results

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "book.closed")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No entries yet")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Log what you felt, what you landed,\nand where you skated.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button { showAdd = true } label: {
                Text("Write First Entry")
                    .font(.subheadline.weight(.black))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
            Spacer()
        }
    }

    private var noResultsState: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 60)
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text("No entries matching \"\(searchText)\"")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Add / Edit Sheet

struct AddJournalEntrySheet: View {
    var editingNote: SessionNote? = nil
    let recentSpots: [String]

    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query private var checkIns:  [SpotCheckIn]
    @Query private var users:     [AppUser]

    @State private var date:      Date
    @State private var spotName:  String
    @State private var text:      String
    @State private var mood:      NoteMood
    @State private var tags:      Set<String>
    @State private var showSpotPicker = false

    private static let suggestedTags = [
        "kickflip", "heelflip", "fs grind", "bs grind", "nosegrind",
        "crooked", "bluntslide", "nollie", "switch", "manual",
        "bail", "landed it", "close", "first try", "foggy"
    ]

    init(editingNote: SessionNote? = nil, recentSpots: [String]) {
        self.editingNote = editingNote
        self.recentSpots = recentSpots
        _date     = State(initialValue: editingNote?.date ?? Date())
        _spotName = State(initialValue: editingNote?.spotName ?? "")
        _text     = State(initialValue: editingNote?.text ?? "")
        _mood     = State(initialValue: editingNote?.mood ?? .solid)
        _tags     = State(initialValue: Set(editingNote?.tags ?? []))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        moodPicker
                        spotAndDateRow
                        textSection
                        tagsSection
                        Spacer(minLength: 40)
                    }
                    .padding(16)
                }
            }
            .navigationTitle(editingNote == nil ? "New Entry" : "Edit Entry")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.bold)
                        .foregroundStyle(text.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.orange)
                        .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    // MARK: - Mood Picker

    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("HOW WAS IT?")
            HStack(spacing: 10) {
                ForEach(NoteMood.allCases) { m in
                    Button { withAnimation(.spring(response: 0.3)) { mood = m } } label: {
                        VStack(spacing: 6) {
                            Text(m.emoji).font(.system(size: 22))
                            Text(m.label)
                                .font(.system(size: 10, weight: mood == m ? .black : .regular))
                                .foregroundStyle(mood == m ? Color(hex: m.colorHex) : Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(mood == m ? Color(hex: m.colorHex).opacity(0.12) : Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(mood == m ? Color(hex: m.colorHex).opacity(0.4) : Color.clear, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Spot + Date

    private var spotAndDateRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("SESSION DETAILS")
            HStack(spacing: 12) {
                // Spot picker
                Button {
                    showSpotPicker.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.orange)
                            .font(.system(size: 14))
                        Text(spotName.isEmpty ? "Pick a spot" : spotName)
                            .font(.system(size: 13))
                            .foregroundStyle(spotName.isEmpty ? Color.gray : Color.white)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(Color.white.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)

                // Date picker
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .tint(.orange)
                    .colorScheme(.dark)
            }
            .confirmationDialog("Choose a Spot", isPresented: $showSpotPicker) {
                ForEach(recentSpots.prefix(10), id: \.self) { s in
                    Button(s) { spotName = s }
                }
                Button("Clear") { spotName = "" }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // MARK: - Text

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("WHAT HAPPENED?")
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Tricks you landed, vibe of the session, anything…")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary.opacity(0.5))
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $text)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 110)
                    .padding(6)
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Tags

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("TAGS (OPTIONAL)")
            FlowLayout(spacing: 8) {
                ForEach(Self.suggestedTags, id: \.self) { tag in
                    let selected = tags.contains(tag)
                    Button { withAnimation(.spring(response: 0.25)) {
                        if selected { tags.remove(tag) } else { tags.insert(tag) }
                    }} label: {
                        Text(tag)
                            .font(.system(size: 11, weight: selected ? .black : .regular))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(selected ? Color.orange : Color.white.opacity(0.08))
                            .foregroundStyle(selected ? .black : .secondary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .black))
            .tracking(1.0)
            .foregroundStyle(.secondary)
    }

    private func save() {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if let existing = editingNote {
            existing.date     = date
            existing.spotName = spotName
            existing.text     = trimmed
            existing.moodRaw  = mood.rawValue
            existing.tags     = Array(tags)
        } else {
            let note = SessionNote(date: date, spotName: spotName, text: trimmed,
                                   mood: mood, tags: Array(tags))
            modelContext.insert(note)
        }
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - FlowLayout helper (wrapping tag chips)

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                y += rowH + spacing
                x = 0
                rowH = 0
            }
            rowH = max(rowH, size.height)
            x += size.width + spacing
        }
        return CGSize(width: maxWidth, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x = bounds.minX
        var y = bounds.minY
        var rowH: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowH + spacing
                x = bounds.minX
                rowH = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            rowH = max(rowH, size.height)
            x += size.width + spacing
        }
    }
}
