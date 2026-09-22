import SwiftUI
import SwiftData

struct CrewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var crews: [Crew]
    @Query private var users: [AppUser]

    @State private var crewName = ""
    @State private var crewTag = ""
    @State private var newMemberName = ""
    @State private var showAddMember = false

    var currentUser: AppUser? { users.first }
    var myCrew: Crew? {
        guard let user = currentUser else { return nil }
        return crews.first { $0.ownerUsername == user.username || $0.memberList.contains(user.username) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if let crew = myCrew {
                    crewDetail(crew)
                } else {
                    createCrewForm
                }
            }
            .navigationTitle("Crew")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
            .alert("Add Member", isPresented: $showAddMember) {
                TextField("Username", text: $newMemberName)
                    .autocorrectionDisabled()
                Button("Add") { addMember() }
                Button("Cancel", role: .cancel) { newMemberName = "" }
            } message: {
                Text("Enter the username of the person to add.")
            }
        }
    }

    // MARK: - Create Crew

    private var createCrewForm: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                    Text("Start Your Crew")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Crew members share spot access and see each other's live sessions.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 24)

                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CREW NAME")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.secondary)
                        TextField("e.g. SF Street Crew", text: $crewName)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                            .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("CREW TAG (max 5 chars)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.secondary)
                        TextField("e.g. SFSK8", text: $crewTag)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                            .autocorrectionDisabled()
                            .onChange(of: crewTag) { _, new in
                                crewTag = String(new.uppercased().prefix(5))
                            }
                    }
                }

                Button { createCrew() } label: {
                    Text("CREATE CREW")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(canCreate ? Color.orange : Color.white.opacity(0.1))
                        .foregroundStyle(canCreate ? Color.black : Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!canCreate)
            }
            .padding()
        }
    }

    private var canCreate: Bool {
        !crewName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !crewTag.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Crew Detail

    @ViewBuilder
    private func crewDetail(_ crew: Crew) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // Crew header card
                VStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.orange).frame(width: 64, height: 64)
                        Text(crew.tag)
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.black)
                    }
                    Text(crew.name)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    if !crew.city.isEmpty {
                        Text(crew.city)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Members
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("MEMBERS")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button {
                            newMemberName = ""
                            showAddMember = true
                        } label: {
                            Label("Add", systemImage: "plus")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.orange)
                        }
                    }

                    VStack(spacing: 0) {
                        ForEach(crew.memberList, id: \.self) { member in
                            memberRow(member, isOwner: member == crew.ownerUsername)
                            if member != crew.memberList.last {
                                Divider().background(Color.white.opacity(0.06))
                            }
                        }
                    }
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func memberRow(_ username: String, isOwner: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(username == currentUser?.username ? Color.orange : Color.white.opacity(0.15))
                    .frame(width: 36, height: 36)
                Text(String(username.prefix(2)).uppercased())
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(username == currentUser?.username ? .black : .white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(username)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                if isOwner {
                    Text("Owner")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - Actions

    private func createCrew() {
        guard let user = currentUser, canCreate else { return }
        let crew = Crew(
            name: crewName.trimmingCharacters(in: .whitespaces),
            tag: crewTag,
            ownerUsername: user.username,
            city: user.city
        )
        modelContext.insert(crew)
    }

    private func addMember() {
        let trimmed = newMemberName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let crew = myCrew, !crew.memberList.contains(trimmed) else {
            newMemberName = ""
            return
        }
        var list = crew.memberList
        list.append(trimmed)
        crew.memberList = list
        newMemberName = ""
    }
}
