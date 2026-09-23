import Foundation
import SwiftUI
import Combine

// MARK: - SkateCityAppState

final class SkateCityAppState: ObservableObject {
    @Published var profile: UserProfile
    @Published var clips: [SkateClip]
    @Published var sessions: [CrewSession]
    @Published var savedSpotIDs: Set<UUID> = []
    @Published var hasSynced = false

    init() {
        self.profile = UserProfile(
            id: UUID(),
            displayName: "Skater",
            handle: "@skater",
            city: "Daly City, CA",
            crewName: "Local Shredders",
            level: 4,
            xp: 320,
            xpMax: 500,
            avatarStyle: AvatarStyle(),
            selectedBoard: "asphalt_ghost",
            homeTheme: .concrete,
            privacySettings: PrivacySettings()
        )
        self.clips = SKMockData.clips
        self.sessions = SKMockData.sessions
    }

    // MARK: - Sync from SwiftData AppUser

    func syncFromAppUser(_ user: AppUser) {
        guard !hasSynced else { return }
        hasSynced = true

        let ad = user.avatar
        let bd = user.board

        let skinTone  = AvatarData.skinPalette[safe: ad.skinToneIndex]   ?? "#F3A96A"
        let hairColor = AvatarData.hairPalette[safe: ad.hairColorIndex]  ?? "#1A1A1A"
        let top       = AvatarData.clothesPalette[safe: ad.topColorIndex]    ?? "#E74C3C"
        let pants     = AvatarData.clothesPalette[safe: ad.pantsColorIndex]  ?? "#2C3E50"
        let shoes     = AvatarData.clothesPalette[safe: ad.shoeColorIndex]   ?? "#F1C40F"

        let boardID: String
        switch bd.deckColorIndex % SKMockData.boards.count {
        case 0:  boardID = "asphalt_ghost"
        case 1:  boardID = "cinder_block"
        case 2:  boardID = "tide_line"
        default: boardID = "iron_ledge"
        }

        profile = UserProfile(
            id: UUID(),
            displayName: user.username,
            handle: "@\(user.username.lowercased().replacingOccurrences(of: " ", with: "_"))",
            city: user.city.isEmpty ? "Daly City, CA" : user.city,
            crewName: "Local Shredders",
            level: max(1, user.sessionCount / 3 + 1),
            xp: (user.sessionCount * 40) % 500,
            xpMax: 500,
            avatarStyle: AvatarStyle(
                skinTone: skinTone,
                hairStyle: ad.hairStyle,
                hairColor: hairColor,
                top: top,
                pants: pants,
                shoes: shoes,
                accessory: "none"
            ),
            selectedBoard: boardID,
            homeTheme: .concrete,
            privacySettings: PrivacySettings()
        )
    }

    // MARK: - Mutations

    func toggleLike(clipID: UUID) {
        guard let idx = clips.firstIndex(where: { $0.id == clipID }) else { return }
        clips[idx].isLiked.toggle()
        clips[idx].likes += clips[idx].isLiked ? 1 : -1
    }

    func saveSpot(_ id: UUID) { savedSpotIDs.insert(id) }
    func removeSpot(_ id: UUID) { savedSpotIDs.remove(id) }
    func isSaved(_ id: UUID) -> Bool { savedSpotIDs.contains(id) }

    func postClip(_ clip: SkateClip) {
        clips.insert(clip, at: 0)
    }

    func joinSession(_ id: UUID) {
        guard let idx = sessions.firstIndex(where: { $0.id == id }) else { return }
        sessions[idx].participantCount = min(sessions[idx].participantCount + 1, sessions[idx].maxParticipants)
    }

    func addSession(_ session: CrewSession) {
        sessions.insert(session, at: 0)
    }

    func earnXP(_ amount: Int) {
        profile.xp = min(profile.xp + amount, profile.xpMax)
        if profile.xp >= profile.xpMax {
            profile.xp = 0
            profile.level += 1
            profile.xpMax = Int(Double(profile.xpMax) * 1.3)
        }
    }
}
