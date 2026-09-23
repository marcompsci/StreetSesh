import SwiftUI
import SwiftData

struct AddClipView: View {
    let spotName: String
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]

    @State private var clipURL = ""
    @State private var clipTitle = ""

    private var currentUser: AppUser? { users.first }

    private var isValidURL: Bool {
        let trimmed = clipURL.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        return Foundation.URL(string: trimmed) != nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    fieldBlock(label: "CLIP URL") {
                        TextField("https://youtube.com/...", text: $clipURL)
                            .autocorrectionDisabled()
                    }
                    fieldBlock(label: "TITLE (optional)") {
                        TextField("e.g. Wallenberg gap attempt", text: $clipTitle)
                            .autocorrectionDisabled()
                    }

                    Spacer()

                    Button { saveClip() } label: {
                        Text("ADD CLIP")
                            .font(.headline.weight(.black))
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(isValidURL ? Color.orange : Color.white.opacity(0.1))
                            .foregroundStyle(isValidURL ? Color.black : Color.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(!isValidURL)
                }
                .padding()
            }
            .navigationTitle("Add a Clip")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }

    @ViewBuilder
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)
            content()
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
        }
    }

    private func saveClip() {
        let url = clipURL.trimmingCharacters(in: .whitespaces)
        guard isValidURL, let user = currentUser else { return }
        let title = clipTitle.trimmingCharacters(in: .whitespaces).isEmpty
            ? url
            : clipTitle.trimmingCharacters(in: .whitespaces)
        let clip = SpotClip(spotName: spotName, clipURL: url, title: title, addedBy: user.username)
        modelContext.insert(clip)
        Task { try? await SupabaseService.shared.pushClip(clip) }
        dismiss()
    }
}
