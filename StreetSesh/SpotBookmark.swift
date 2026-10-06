import Foundation
import SwiftData

@Model
final class SpotBookmark {
    var spotName: String
    var bustStatusRaw: String
    var fameTierRaw: String
    var obstacles: [String]
    var latitude: Double
    var longitude: Double
    var addedAt: Date
    var notes: String

    var bustStatus: BustStatus {
        get { BustStatus(rawValue: bustStatusRaw) ?? .green }
        set { bustStatusRaw = newValue.rawValue }
    }

    var fameTier: FameTier {
        get { FameTier(rawValue: fameTierRaw) ?? .local }
        set { fameTierRaw = newValue.rawValue }
    }

    init(from spot: Spot, notes: String = "") {
        self.spotName      = spot.name
        self.bustStatusRaw = spot.bustStatusRaw
        self.fameTierRaw   = spot.fameTierRaw
        self.obstacles     = spot.obstacles
        self.latitude      = spot.latitude
        self.longitude     = spot.longitude
        self.addedAt       = Date()
        self.notes         = notes
    }
}
