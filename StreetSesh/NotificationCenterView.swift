import SwiftUI
import SwiftData

struct NotificationCenterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \NotificationItem.createdAt, order: .reverse) private var notifications: [NotificationItem]

    private var unread: [NotificationItem] { notifications.filter { !$0.isRead } }
    private var read:   [NotificationItem] { notifications.filter {  $0.isRead } }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if notifications.isEmpty {
                    emptyState
                } else {
                    List {
                        if !unread.isEmpty {
                            Section {
                                ForEach(unread) { notifRow($0) }
                            } header: {
                                sectionLabel("NEW")
                            }
                        }
                        if !read.isEmpty {
                            Section {
                                ForEach(read) { notifRow($0) }
                            } header: {
                                sectionLabel("EARLIER")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Notifications")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                if !unread.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Mark all read") {
                            unread.forEach { $0.isRead = true }
                            try? modelContext.save()
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                    }
                }
            }
        }
    }

    // MARK: - Empty

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No notifications yet")
                .font(.headline).foregroundStyle(.white)
            Text("Comments, trophy unlocks, crew activity,\nand nearby sessions will appear here.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Row

    @ViewBuilder
    private func notifRow(_ item: NotificationItem) -> some View {
        Button {
            item.isRead = true
            try? modelContext.save()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: item.tintHex).opacity(item.isRead ? 0.12 : 0.22))
                        .frame(width: 46, height: 46)
                    Image(systemName: item.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: item.tintHex))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.subheadline.weight(item.isRead ? .regular : .semibold))
                        .foregroundStyle(item.isRead ? Color.secondary : Color.white)
                        .lineLimit(1)
                    Text(item.body)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    Text(item.createdAt.skRelative)
                        .font(.caption2)
                        .foregroundStyle(.secondary.opacity(0.6))
                }

                Spacer()

                if !item.isRead {
                    Circle().fill(Color.orange).frame(width: 9, height: 9)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.white.opacity(item.isRead ? 0.03 : 0.08))
        .listRowSeparatorTint(Color.white.opacity(0.06))
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(.secondary)
    }
}
