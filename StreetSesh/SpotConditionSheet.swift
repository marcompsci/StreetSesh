import SwiftUI
import SwiftData

struct SpotConditionSheet: View {
    let spotName: String

    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query(sort: \SpotCondition.reportedAt, order: .reverse) private var allConditions: [SpotCondition]
    @Query private var users:     [AppUser]
    @Query private var bookmarks: [SpotBookmark]

    @State private var selectedType: SpotConditionType? = nil
    @State private var notes = ""

    private var currentUser: AppUser? { users.first }

    private var currentCondition: SpotCondition? {
        allConditions.first { $0.spotName == spotName && !$0.isStale }
    }

    private var canSubmit: Bool { selectedType != nil }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        if let cond = currentCondition {
                            currentConditionCard(cond)
                        } else {
                            noReportCard
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            sectionLabel("WHAT'S THE SITUATION?")
                            conditionGrid
                        }

                        if selectedType != nil {
                            notesField
                        }

                        submitButton
                            .opacity(canSubmit ? 1 : 0.4)

                        Spacer(minLength: 24)
                    }
                    .padding(16)
                }
            }
            .navigationTitle(spotName)
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
        .presentationDetents([.large, .fraction(0.7)])
    }

    // MARK: - Current Condition Card

    private func currentConditionCard(_ cond: SpotCondition) -> some View {
        HStack(spacing: 14) {
            Text(cond.type.emoji)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 4) {
                Text(cond.type.label)
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.white)
                HStack(spacing: 5) {
                    Text("by \(cond.reporter)")
                    Text("·")
                    Text(cond.reportedAt.skRelative)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                if !cond.notes.isEmpty {
                    Text(cond.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.8))
                        .lineLimit(2)
                }
            }

            Spacer()

            freshnessBar(cond)
        }
        .padding(14)
        .background(Color(hex: cond.type.colorHex).opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: cond.type.colorHex).opacity(0.3), lineWidth: 1))
    }

    private func freshnessBar(_ cond: SpotCondition) -> some View {
        let progress = cond.freshnessProgress
        return VStack(spacing: 4) {
            Text("FRESH")
                .font(.system(size: 7, weight: .black))
                .foregroundStyle(Color(hex: cond.type.colorHex))
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 6, height: 40)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: cond.type.colorHex))
                    .frame(width: 6, height: CGFloat(40.0 * progress))
            }
            Text(cond.type.expiryLabel)
                .font(.system(size: 7))
                .foregroundStyle(.secondary)
        }
    }

    private var noReportCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                .font(.system(size: 20))
                .foregroundStyle(.secondary)
            Text("No recent condition reports for this spot.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Condition Grid

    private var conditionGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
            spacing: 10
        ) {
            ForEach(SpotConditionType.allCases) { type in
                let isSelected = selectedType == type
                Button {
                    withAnimation(.spring(response: 0.25)) {
                        selectedType = isSelected ? nil : type
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(type.emoji)
                            .font(.system(size: 26))
                        Text(type.label)
                            .font(.system(size: 10, weight: isSelected ? .black : .regular))
                            .foregroundStyle(isSelected ? Color(hex: type.colorHex) : Color.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isSelected ? Color(hex: type.colorHex).opacity(0.12) : Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(hex: type.colorHex).opacity(0.4) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Notes

    private var notesField: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("NOTES (OPTIONAL)")
            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("Any details…")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.secondary.opacity(0.5))
                        .padding(.top, 10)
                        .padding(.leading, 6)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $notes)
                    .font(.system(size: 13))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 72)
                    .padding(4)
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Submit

    private var submitButton: some View {
        Button { submit() } label: {
            HStack(spacing: 8) {
                if let type = selectedType {
                    Text(type.emoji).font(.system(size: 16))
                } else {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 16))
                }
                Text(selectedType != nil ? "REPORT \(selectedType!.label.uppercased())" : "SELECT A CONDITION")
                    .font(.headline.weight(.black))
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(canSubmit ? Color.orange : Color.white.opacity(0.10))
            .foregroundStyle(canSubmit ? Color.black : Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!canSubmit)
    }

    // MARK: - Helpers

    private func sectionLabel(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .black))
            .tracking(1.0)
            .foregroundStyle(.secondary)
    }

    private func submit() {
        guard let type = selectedType, let user = currentUser else { return }
        let condition = SpotCondition(
            spotName: spotName,
            reporter: user.username,
            type: type,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        modelContext.insert(condition)
        // Security alert for bookmarked spots
        if type == .security, bookmarks.contains(where: { $0.spotName == spotName }) {
            AppEventNotifier(context: modelContext).bookmarkedSpotLive(spotName: spotName)
        }
        try? modelContext.save()
        dismiss()
    }
}
