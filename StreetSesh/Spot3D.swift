//  Spot3D.swift
//  StreetSesh — 3D spot + shop data model (decodes Data/streetsesh_spots.json)

import Foundation
import CoreLocation
import SwiftUI
import UIKit

struct SpotCatalog: Codable {
    let version: Int
    let generated: String
    let regions: [String]
    let spots: [Spot3D]
}

enum SpotCategory: String, Codable, CaseIterable, Identifiable {
    case skatepark, street, shop
    var id: String { rawValue }
    var label: String {
        switch self {
        case .skatepark: return "Parks"
        case .street:    return "Street"
        case .shop:      return "Shops"
        }
    }
    var symbol: String {
        switch self {
        case .skatepark: return "figure.skateboarding"
        case .street:    return "road.lanes"
        case .shop:      return "storefront"
        }
    }
    var tint: Color {
        switch self {
        case .skatepark: return Color(red: 0.20, green: 0.78, blue: 0.45)
        case .street:    return Color(red: 1.00, green: 0.42, blue: 0.10)
        case .shop:      return Color(red: 0.45, green: 0.40, blue: 1.00)
        }
    }
}

struct SpotFeatures: Codable, Hashable {
    var bowls: Int?; var rails: Int?; var ledges: Int?; var banks: Int?; var stairs: Int?
    var hubbas: Int?; var krails: Int?; var benches: Int?; var blocks: Int?; var sets: Int?
    var gapStairs: Int?; var hubbaSides: Int?
    var bowlDepthM: Double?; var ledgeHeightM: Double?; var ledgeLengthM: Double?
    var gapLengthM: Double?; var dropM: Double?; var wallHeightM: Double?
    var bankAngle: Double?; var gradePct: Double?
    var rail: String?; var surface: String?
    var overpass: Bool?; var miniBowl: Bool?; var pyramid: Bool?; var snakeRun: Bool?
    var fullPipe: Bool?; var spine: Bool?; var murals: Bool?; var dirt: Bool?; var gap: Bool?
    var bricks: Bool?; var slabs: Bool?; var palms: Bool?; var upDown: Bool?; var bunker: Bool?
    var flatTop: Bool?; var bankBottom: Bool?; var railToBank: Bool?; var cones: Bool?; var flats: Bool?
}

struct ShopFacade: Codable, Hashable {
    var style: String
    var color: String
    var accent: String
    var awning: String
    var stories: Int
    var mural: Bool?
}

struct Spot3D: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: SpotCategory
    let region: String
    let city: String
    let address: String
    var latitude: Double
    var longitude: Double
    var coordVerified: Bool
    let kind: String
    let features: SpotFeatures?
    let shopType: String?
    let facade: ShopFacade?
    let status: String
    let access: String
    let notes: String
    let modelFile: String

    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
    var isGhost: Bool { status == "demolished" }

    var kindLabel: String {
        switch kind {
        case "bowlpark": return "Bowl park"
        case "plazapark": return "Plaza park"
        case "flatground": return "Flatground"
        case "storefront": return shopType == "roller" ? "Roller skate shop" : "Skate shop"
        default: return kind.capitalized
        }
    }

    var statusBadge: (text: String, color: Color)? {
        switch status {
        case "endangered": return ("Endangered", .orange)
        case "partially-demolished": return ("Partly gone", .yellow)
        case "demolished": return ("Legend · gone", .gray)
        default: return nil
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let s = hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var v: UInt64 = 0; Scanner(string: s).scanHexInt64(&v)
        self.init(red: CGFloat((v >> 16) & 0xFF) / 255,
                  green: CGFloat((v >> 8) & 0xFF) / 255,
                  blue: CGFloat(v & 0xFF) / 255,
                  alpha: 1)
    }
}
