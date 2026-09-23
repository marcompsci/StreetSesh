import SwiftUI

struct SkateCityCustomizeSheet: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Environment(\.dismiss) private var dismiss

    // Local draft — committed on "Save"
    @State private var draft: UserProfile = UserProfile(
        id: UUID(), displayName: "", handle: "", city: "", crewName: "",
        level: 1, xp: 0, xpMax: 500,
        avatarStyle: AvatarStyle(), selectedBoard: "asphalt_ghost",
        homeTheme: .concrete, privacySettings: PrivacySettings()
    )
    @State private var tab: CustomizeTab = .avatar

    enum CustomizeTab: String, CaseIterable {
        case avatar = "Avatar"
        case board  = "Board"
        case room   = "Room"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    previewSection
                    tabPicker
                    ScrollView(showsIndicators: false) {
                        Group {
                            switch tab {
                            case .avatar: avatarEditor
                            case .board:  boardEditor
                            case .room:   roomEditor
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Customize")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.skSub)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        state.profile = draft
                        dismiss()
                    }
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.skLime)
                }
            }
        }
        .onAppear { draft = state.profile }
    }

    // MARK: - Preview

    private var previewSection: some View {
        ZStack {
            LinearGradient(
                colors: draft.homeTheme.wallGradient,
                startPoint: .top, endPoint: .bottom
            )
            HStack(spacing: 40) {
                SKMiniSkater(style: draft.avatarStyle, size: 80)
                if let board = SKMockData.boards.first(where: { $0.id == draft.selectedBoard }) {
                    SKBoardMini(accentHex: board.accentHex, width: 26, height: 60)
                }
            }
        }
        .frame(height: 110)
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(CustomizeTab.allCases, id: \.self) { t in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { tab = t }
                } label: {
                    VStack(spacing: 6) {
                        Text(t.rawValue)
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(tab == t ? .skLime : .skSub)
                        Rectangle()
                            .fill(tab == t ? Color.skLime : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.skDark)
    }

    // MARK: - Avatar Editor

    private var avatarEditor: some View {
        VStack(alignment: .leading, spacing: 18) {
            colorPicker(
                label: "SKIN TONE",
                palette: AvatarData.skinPalette,
                selected: draft.avatarStyle.skinTone
            ) { draft.avatarStyle.skinTone = $0 }

            chipPicker(
                label: "HAIR STYLE",
                options: AvatarData.hairStyleNames,
                selected: AvatarData.hairStyleNames[safe: draft.avatarStyle.hairStyle] ?? "Short"
            ) { name in
                draft.avatarStyle.hairStyle = AvatarData.hairStyleNames.firstIndex(of: name) ?? 0
            }

            colorPicker(
                label: "HAIR COLOR",
                palette: AvatarData.hairPalette,
                selected: draft.avatarStyle.hairColor
            ) { draft.avatarStyle.hairColor = $0 }

            colorPicker(
                label: "TOP",
                palette: AvatarData.clothesPalette,
                selected: draft.avatarStyle.top
            ) { draft.avatarStyle.top = $0 }

            colorPicker(
                label: "PANTS",
                palette: AvatarData.clothesPalette,
                selected: draft.avatarStyle.pants
            ) { draft.avatarStyle.pants = $0 }

            colorPicker(
                label: "SHOES",
                palette: AvatarData.clothesPalette,
                selected: draft.avatarStyle.shoes
            ) { draft.avatarStyle.shoes = $0 }
        }
    }

    // MARK: - Board Editor

    private var boardEditor: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("CHOOSE YOUR DECK")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.skSub)

            ForEach(SKMockData.boards) { board in
                Button { draft.selectedBoard = board.id } label: {
                    boardOptionRow(board)
                }
            }
        }
    }

    private func boardOptionRow(_ board: SKBoard) -> some View {
        let selected = draft.selectedBoard == board.id
        return HStack(spacing: 14) {
            SKBoardMini(accentHex: board.accentHex, width: 22, height: 52)
                .frame(width: 50, height: 52)
            VStack(alignment: .leading, spacing: 4) {
                Text(board.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(selected ? Color(hex: board.accentHex) : .skText)
                Text(board.tagline)
                    .font(.caption)
                    .foregroundStyle(.skSub)
            }
            Spacer()
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: board.accentHex))
            }
        }
        .padding(14)
        .background(Color.skMuted)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(selected ? Color(hex: board.accentHex) : Color.clear, lineWidth: 1.5)
        )
    }

    // MARK: - Room Editor

    private var roomEditor: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("ROOM THEME")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.skSub)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(HomeTheme.allCases, id: \.self) { theme in
                    roomThemeCard(theme)
                }
            }
        }
    }

    private func roomThemeCard(_ theme: HomeTheme) -> some View {
        let selected = draft.homeTheme == theme
        return Button { draft.homeTheme = theme } label: {
            VStack(spacing: 8) {
                ZStack {
                    LinearGradient(colors: theme.wallGradient, startPoint: .top, endPoint: .bottom)
                        .frame(height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    // Small accent dot
                    Circle()
                        .fill(theme.accent)
                        .frame(width: 14, height: 14)
                }
                Text(theme.rawValue)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(selected ? theme.accent : .skSub)
            }
            .padding(10)
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected ? theme.accent : Color.clear, lineWidth: 2)
            )
        }
    }

    // MARK: - Helpers

    private func colorPicker(
        label: String,
        palette: [String],
        selected: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(palette, id: \.self) { hex in
                        let isSelected = hex == selected
                        Button { onSelect(hex) } label: {
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(isSelected ? Color.skLime : Color.clear, lineWidth: 2.5)
                                        .padding(-3)
                                )
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private func chipPicker(
        label: String,
        options: [String],
        selected: String,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        let isSelected = option == selected
                        Button { onSelect(option) } label: {
                            Text(option)
                                .font(.system(size: 13, weight: isSelected ? .black : .regular))
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(isSelected ? Color.skLime : Color.skMuted)
                                .foregroundStyle(isSelected ? Color.black : Color.skSub)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
}
