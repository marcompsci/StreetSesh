import Foundation
import CoreLocation

// MARK: - Real Los Angeles Skate Spots
// Source: findskatespots.com — accurate GPS coordinates

extension SKMockData {

    static let laSpots: [SkateSpot] = [
        SkateSpot(
            id: UUID(),
            name: "10 Stair",
            neighborhood: "10070-10074 Constellation Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.05901, longitude: -118.41511),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 13,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "10100 Santa Monica Blvd - 15 Stair",
            neighborhood: "10076 S Santa Monica Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.061928, longitude: -118.4168),
            difficulty: .pro,
            terrainTags: ["15 Stair"],
            popularity: 47,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "11 Stair Rail",
            neighborhood: "4939-4945 W Slauson Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.98771, longitude: -118.36416),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 75,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "11 Stair/Pop out ledge",
            neighborhood: "1718 Mariachi Plaza De Los Angele",
            coordinate: CLLocationCoordinate2D(latitude: 34.04739, longitude: -118.21947),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Ledge"],
            popularity: 86,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "13 Stair Rail",
            neighborhood: "4949 W Slauson Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.98773, longitude: -118.36445),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 87,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "14 Stair Hubba",
            neighborhood: "1740 E Gage Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.98191, longitude: -118.24177),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Hubba"],
            popularity: 76,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "14 Stair Rail",
            neighborhood: "12800-13098 S Carlton Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.9159, longitude: -118.27271),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 12,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "15 Stair Popout Rail/Gap",
            neighborhood: "857 Green Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.05077, longitude: -118.27181),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail", "Gap"],
            popularity: 94,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "15 Stair Rainbow Rail",
            neighborhood: "7750 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.09792, longitude: -118.35844),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 44,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "1st St - Bank To Gap Over Rail",
            neighborhood: "4130 1st St",
            coordinate: CLLocationCoordinate2D(latitude: 34.036823, longitude: -118.176315),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap", "Bank"],
            popularity: 55,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "2 Flat 3 Rail",
            neighborhood: "3400 Sawtelle Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.019794, longitude: -118.42608),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "3 Stair Ledge",
            neighborhood: "1809 West Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.04049, longitude: -118.33712),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Ledge"],
            popularity: 81,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "3 Stair Ledge",
            neighborhood: "530-598 W 6th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04871, longitude: -118.25524),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Ledge"],
            popularity: 13,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "3530 Wilshire - 10 Stair",
            neighborhood: "661 Irolo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.061268, longitude: -118.30091),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 40,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "3530 Wilshire - 6 Stair Gap Over Rail",
            neighborhood: "3530 Wilshire Blvd Fl 16",
            coordinate: CLLocationCoordinate2D(latitude: 34.06135, longitude: -118.30099),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Rail", "Gap"],
            popularity: 28,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "4 stair over rail",
            neighborhood: "700-798 Ferry St",
            coordinate: CLLocationCoordinate2D(latitude: 33.74484, longitude: -118.26083),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Rail"],
            popularity: 81,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "4311 Wilshire - 10 Stair Gap Over Rail",
            neighborhood: "4311 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06232, longitude: -118.32193),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail", "Gap"],
            popularity: 55,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "4500 Wilshire - Drop In Rail",
            neighborhood: "21 Fremont Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.061462, longitude: -118.32768),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 41,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "5th Ave - Curb Cut Flat Gap",
            neighborhood: "1009 1/2 5th Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.993168, longitude: -118.47011),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 25,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "7 Stair",
            neighborhood: "155 W 69th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.97746, longitude: -118.27596),
            difficulty: .intermediate,
            terrainTags: ["7 Stair"],
            popularity: 100,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "7 Stair Rail",
            neighborhood: "W 98th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.94733, longitude: -118.31133),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 10,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "7-Eleven - Up Rail",
            neighborhood: "2512 S Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.028614, longitude: -118.27555),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 47,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "923 Sunset Blvd - Bank",
            neighborhood: "830 Bartlett St",
            coordinate: CLLocationCoordinate2D(latitude: 34.062813, longitude: -118.24571),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 15,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "A ju - Bump Over Wall",
            neighborhood: "3701 W 6th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06369, longitude: -118.30302),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Abbot Kinney Blvd - Bump To Bike Rack",
            neighborhood: "1144 Abbot Kinney Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.991413, longitude: -118.469315),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 44,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Abraham Lincoln High School - 7 Stair Hubba",
            neighborhood: "3501 N Broadway",
            coordinate: CLLocationCoordinate2D(latitude: 34.07446, longitude: -118.203995),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Hubba"],
            popularity: 54,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Air Cargo - DIY Bank Ledge",
            neighborhood: "6041 Imperial Hwy.",
            coordinate: CLLocationCoordinate2D(latitude: 33.93132, longitude: -118.39039),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Air Cargo - Wallie To Ledge",
            neighborhood: "6041 Imperial Hwy.",
            coordinate: CLLocationCoordinate2D(latitude: 33.93161, longitude: -118.39076),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Wall"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Airport Ave - Banks / Sign Wallride",
            neighborhood: "13115 Dewey St",
            coordinate: CLLocationCoordinate2D(latitude: 34.011494, longitude: -118.453804),
            difficulty: .advanced,
            terrainTags: ["Bank", "Wall"],
            popularity: 48,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "AJ Hair Clinic - Over Rail Into Bank",
            neighborhood: "4573 Melrose Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.083652, longitude: -118.29992),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 76,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Albion Riverside Park - Circle Manny Pads",
            neighborhood: "Albion Riverside Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.069256, longitude: -118.22273),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 12,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aldama Elementary School - Hill Bomb",
            neighborhood: "701 N Avenue 50",
            coordinate: CLLocationCoordinate2D(latitude: 34.110798, longitude: -118.20636),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Alessandro Elementary School - Pop out Ledge",
            neighborhood: "2555 Riverside Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.10114, longitude: -118.25137),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 79,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Alhambra Ave - Ledge To Rail",
            neighborhood: "2223 Alhambra Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.06362, longitude: -118.214676),
            difficulty: .advanced,
            terrainTags: ["Rail", "Ledge"],
            popularity: 18,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Allesandro Elementary School - Low To High Ledge",
            neighborhood: "2256 Riverside Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.102898, longitude: -118.25221),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 71,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Allesandro St - DIY Bank To Rail",
            neighborhood: "2158 3/4 Ewing St",
            coordinate: CLLocationCoordinate2D(latitude: 34.090176, longitude: -118.25846),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 28,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Alpine Recreation Center - Ride on Curve Ledge",
            neighborhood: "815 Yale St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06378, longitude: -118.24067),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 37,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Amabel St - Ride On Curb",
            neighborhood: "302 Amabel St",
            coordinate: CLLocationCoordinate2D(latitude: 34.088825, longitude: -118.215836),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 46,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ambrose Ave - 10 Stair Drop In Rail",
            neighborhood: "4583 Ambrose Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.11006, longitude: -118.29037),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 50,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Anchor Ledges",
            neighborhood: "300 S Harbor Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.74146, longitude: -118.27934),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Anderson St - Street Gap",
            neighborhood: "110 S Anderson St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04719, longitude: -118.22669),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 40,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Angus St - 11 Stair Rail",
            neighborhood: "3022 Angus St",
            coordinate: CLLocationCoordinate2D(latitude: 34.106262, longitude: -118.27078),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Angus St - Manny Pad",
            neighborhood: "2771 Angus St",
            coordinate: CLLocationCoordinate2D(latitude: 34.106483, longitude: -118.267),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 29,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Annandale Elementary School - Street Gap",
            neighborhood: "6954 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.129276, longitude: -118.18744),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 31,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "AON Center - 8 Stair",
            neighborhood: "601-619 S Hope St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04935, longitude: -118.25657),
            difficulty: .intermediate,
            terrainTags: ["8 Stair"],
            popularity: 43,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arabic Church - Euro Bump",
            neighborhood: "4310 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12979, longitude: -118.232544),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 40,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aragon 12 Stair",
            neighborhood: "3314 Loosmore St",
            coordinate: CLLocationCoordinate2D(latitude: 34.09477, longitude: -118.22547),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 100,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aragon Avenue Elementary School - 10 Stair Hubba",
            neighborhood: "1118 Aragon Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0946, longitude: -118.22552),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Hubba"],
            popularity: 100,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aragon Avenue Elementary School - Picnic Table To Bank",
            neighborhood: "1118 Aragon Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09495, longitude: -118.22569),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 90,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ardmore - Driveway Rails",
            neighborhood: "1852 Whitley Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.104916, longitude: -118.333244),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 53,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arizona Circle - Bump Gap",
            neighborhood: "6320 Arizona Cir",
            coordinate: CLLocationCoordinate2D(latitude: 33.98029, longitude: -118.39669),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 86,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arlington Ave - Pyramid Hubba",
            neighborhood: "2620 Arlington Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.031796, longitude: -118.31757),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 30,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arminta St - Flat Gap Ledges",
            neighborhood: "14529 Arminta St",
            coordinate: CLLocationCoordinate2D(latitude: 34.2135, longitude: -118.45003),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 70,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arroyo Seco Bridge Hubba",
            neighborhood: "463 N San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.079945, longitude: -118.22582),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 95,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Arroyo Seco Confluence - DIY Bank To Ledge",
            neighborhood: "201 N Ave 19",
            coordinate: CLLocationCoordinate2D(latitude: 34.079212, longitude: -118.22572),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Art Store - Bump To Bar",
            neighborhood: "3706 Tracy St",
            coordinate: CLLocationCoordinate2D(latitude: 34.10421, longitude: -118.27387),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 97,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Asbury St - Bank",
            neighborhood: "2901 Asbury St",
            coordinate: CLLocationCoordinate2D(latitude: 34.09779, longitude: -118.23141),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 44,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ashton Ave - Driveway Out Rail",
            neighborhood: "10471 Ashton Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.064358, longitude: -118.4305),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 60,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Athletic Club - 4 Up Gap Over Wall",
            neighborhood: "6525 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.09814, longitude: -118.33238),
            difficulty: .advanced,
            terrainTags: ["Gap", "Wall"],
            popularity: 100,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Atwater Avenue Elementary School - Planter Ledges",
            neighborhood: "3271 Silver Lake Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.114735, longitude: -118.25442),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 81,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aurora St - Flat Gap / Metal Ledge",
            neighborhood: "1727 N Spring St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07018, longitude: -118.226524),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 43,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Auto Zone - 7 Stair",
            neighborhood: "1463 N Alvarado St",
            coordinate: CLLocationCoordinate2D(latitude: 34.082294, longitude: -118.26085),
            difficulty: .intermediate,
            terrainTags: ["7 Stair"],
            popularity: 96,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ave 57 - Ledge",
            neighborhood: "5703 Monte Vista St",
            coordinate: CLLocationCoordinate2D(latitude: 34.1119, longitude: -118.194435),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 33,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aviation / Imperial Station - Bike Locker Flat Gap",
            neighborhood: "Aviation / Imperial",
            coordinate: CLLocationCoordinate2D(latitude: 33.929413, longitude: -118.37754),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 42,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Aviva - 5 Flat 5 Double Set / Gap To Rail",
            neighborhood: "7357 Hollywood Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.10177, longitude: -118.350464),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Back to back HandRails",
            neighborhood: "2445 Mariondale Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07462, longitude: -118.16571),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 81,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baldwin Hills - Bump",
            neighborhood: "6105 Hetzler Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.020195, longitude: -118.382454),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baltimore St - 16 Stair Rail",
            neighborhood: "5256 Baltimore St",
            coordinate: CLLocationCoordinate2D(latitude: 34.117558, longitude: -118.20142),
            difficulty: .pro,
            terrainTags: ["16 Stair", "Rail"],
            popularity: 51,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baltimore Street - Gap To Curb Cut",
            neighborhood: "4901 Baltimore St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11929, longitude: -118.20964),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 26,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bancroft Middle School - 9 Stair Rail",
            neighborhood: "929 N Las Palmas Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.087593, longitude: -118.33679),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 80,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bancroft Middle School - Planter Gap",
            neighborhood: "929 N Las Palmas Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.088093, longitude: -118.3368),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 31,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bandini Street Elementary 11 Stair Rail",
            neighborhood: "425 N Bandini St",
            coordinate: CLLocationCoordinate2D(latitude: 33.746254, longitude: -118.29906),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 91,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bank of America - Gap Through Hole",
            neighborhood: "850 N Broadway",
            coordinate: CLLocationCoordinate2D(latitude: 34.06346, longitude: -118.2373),
            difficulty: .advanced,
            terrainTags: ["Gap", "Bank"],
            popularity: 55,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bank of America - Handicap Rail",
            neighborhood: "858 N Broadway",
            coordinate: CLLocationCoordinate2D(latitude: 34.06387, longitude: -118.23729),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bank of America - Parking Lot Out Rail",
            neighborhood: "2412 Silver Lake Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.100616, longitude: -118.25861),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 54,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bank of America - Pyramid Ledge",
            neighborhood: "12221 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.1434, longitude: -118.399155),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Banked Manny Pad to Drop Off",
            neighborhood: "3303 Hamilton Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.08662, longitude: -118.274445),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 34,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Barclay St - Over Fence To Bank",
            neighborhood: "2107 Barclay St",
            coordinate: CLLocationCoordinate2D(latitude: 34.0854, longitude: -118.22873),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 46,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Barrier",
            neighborhood: "4975 Valley Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06914, longitude: -118.176315),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 31,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baxter St - Curb Cut Driveway Gap",
            neighborhood: "2140 Baxter St",
            coordinate: CLLocationCoordinate2D(latitude: 34.092045, longitude: -118.256355),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 11,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baxter St Curve Ledge",
            neighborhood: "1420-1482 Baxter St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08844, longitude: -118.24748),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 72,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Belle Porte Ave - Bump Over Wall",
            neighborhood: "25341 Belle Porte Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.794064, longitude: -118.30133),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bellevue Ave - Pop Out Ledge",
            neighborhood: "1415 Bellevue Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.06849, longitude: -118.25623),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bellevue Park - Flat To Down Hubba",
            neighborhood: "3787 Marathon St",
            coordinate: CLLocationCoordinate2D(latitude: 34.084084, longitude: -118.2832),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 50,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bellevue Primary Center - Ledges",
            neighborhood: "610 Micheltorena St",
            coordinate: CLLocationCoordinate2D(latitude: 34.079006, longitude: -118.280426),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 93,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Belmont 9 Stair",
            neighborhood: "135 Loma Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.062084, longitude: -118.26334),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 70,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Berendo Middle School - 12 Stair Rail",
            neighborhood: "1111 S Berendo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.050117, longitude: -118.29433),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 72,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Berendo Middle School - 18 Stair Rail / Gap To Hubba",
            neighborhood: "1111 S Berendo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05011, longitude: -118.29468),
            difficulty: .pro,
            terrainTags: ["18 Stair", "Rail", "Hubba"],
            popularity: 64,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bertha St. - Curved Curb",
            neighborhood: "350 S Ave 63",
            coordinate: CLLocationCoordinate2D(latitude: 34.11144, longitude: -118.18519),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 35,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Best Buy Bump To Rail",
            neighborhood: "4500 Van Nuys Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.153126, longitude: -118.44783),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 54,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bethune Middle School Ledges",
            neighborhood: "124 W 67th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.978283, longitude: -118.275),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 82,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Beverly Blvd - Out Ledge / Gap",
            neighborhood: "2615 Beverly Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.070023, longitude: -118.27715),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 23,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Beverly Blvd - Wallrides",
            neighborhood: "2201 Beverly Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.067307, longitude: -118.27143),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Beverly Boulevard 8 Stair Green Rail",
            neighborhood: "3802 Beverly Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.07622, longitude: -118.29201),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 78,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Beverly Glen - Double Bank Ditch",
            neighborhood: "2799 N Beverly Glen Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.123276, longitude: -118.446014),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 41,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Blessed Sacrament Catholic Church - 9 Stair Gap Over Rail",
            neighborhood: "Sunset / Cherokee",
            coordinate: CLLocationCoordinate2D(latitude: 34.09817, longitude: -118.33521),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail", "Gap"],
            popularity: 70,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bloomingdale's - 9 Stair / Steep Hubba",
            neighborhood: "Hazeltine Ave & Riverside Dr Northbound",
            coordinate: CLLocationCoordinate2D(latitude: 34.157253, longitude: -118.43983),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Hubba"],
            popularity: 24,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Blue Wall To Stairs",
            neighborhood: "1309 N Wilton Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.095825, longitude: -118.313774),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bon Vivant - Bank To Manny Pad",
            neighborhood: "3155 Glendale Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.117447, longitude: -118.26226),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bonnie Brae St - Bank to Ledge",
            neighborhood: "328 N Bonnie Brae St",
            coordinate: CLLocationCoordinate2D(latitude: 34.069023, longitude: -118.265686),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Boyle Heights Continuation High School - Low To High Ledge",
            neighborhood: "543 S Mathews St",
            coordinate: CLLocationCoordinate2D(latitude: 34.03758, longitude: -118.21222),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 59,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Boyle Heights Park - 14 Stair Rail",
            neighborhood: "924 S Mott St",
            coordinate: CLLocationCoordinate2D(latitude: 34.032658, longitude: -118.213486),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 44,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Breed St - Bump To Rail",
            neighborhood: "213-251 S Breed St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04254, longitude: -118.21223),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 38,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Brick Banks",
            neighborhood: "225 N Los Angeles St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05364, longitude: -118.24173),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 84,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Buchanan - Sidewalk Bump To Ledge",
            neighborhood: "5839 Buchanan St",
            coordinate: CLLocationCoordinate2D(latitude: 34.117416, longitude: -118.19115),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 49,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Buena Vista Hill - 15 Stair Rail",
            neighborhood: "Buena Vista Hill Elysian Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.072388, longitude: -118.228714),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 12,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bump over hydrant to curb",
            neighborhood: "17500-17540 Rhoda St",
            coordinate: CLLocationCoordinate2D(latitude: 34.175667, longitude: -118.51575),
            difficulty: .intermediate,
            terrainTags: ["Curb"],
            popularity: 60,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bump Over Tires",
            neighborhood: "4477 Beverly Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.07639, longitude: -118.30636),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 68,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bump To Rail",
            neighborhood: "1037 N Cahuenga Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.090054, longitude: -118.32897),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 49,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bump To Rail",
            neighborhood: "605 Imogen Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.08109, longitude: -118.2844),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 72,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Burbank 16 Stair Rail / Gap",
            neighborhood: "6460-6480 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11974, longitude: -118.183525),
            difficulty: .pro,
            terrainTags: ["16 Stair", "Rail", "Gap"],
            popularity: 71,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Burger King - Bump To Bar To Curb",
            neighborhood: "Fletcher / San Fernando",
            coordinate: CLLocationCoordinate2D(latitude: 34.11516, longitude: -118.24569),
            difficulty: .intermediate,
            terrainTags: ["Curb"],
            popularity: 26,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bushnell Way Elementary School - Bump To Ledge",
            neighborhood: "5507 Bushnell Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.102654, longitude: -118.18895),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 72,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Buthane Park - Flat Rail",
            neighborhood: "6200 Hooper Ave.",
            coordinate: CLLocationCoordinate2D(latitude: 33.983448, longitude: -118.25224),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 27,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "C Manny Pad",
            neighborhood: "700-734 W 6th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04956, longitude: -118.25684),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 97,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cabrillo Marina 11 Stair Rail",
            neighborhood: "30 Via Cabrillo Marina",
            coordinate: CLLocationCoordinate2D(latitude: 33.719357, longitude: -118.28272),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 60,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cahuenga Branch Library - 12 Stair Rails",
            neighborhood: "4591 Santa Monica Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.091015, longitude: -118.28891),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 46,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cal State LA - 16 Stair Rail",
            neighborhood: "5151 State University Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.066128, longitude: -118.16972),
            difficulty: .pro,
            terrainTags: ["16 Stair", "Rail"],
            popularity: 20,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cal State LA - Circle Bank Ledge",
            neighborhood: "5155 State University Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.06768, longitude: -118.16851),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 26,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cal State LA Ledge/Manny pad",
            neighborhood: "2100 Scudder Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.068405, longitude: -118.168625),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Manual Pad"],
            popularity: 69,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "California Science Center - Manny Pad",
            neighborhood: "700 State Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.01556, longitude: -118.286095),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 34,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Caltrans Building - 9 Stair",
            neighborhood: "32 Main St",
            coordinate: CLLocationCoordinate2D(latitude: 34.051853, longitude: -118.24309),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 62,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Caltrans Building - Pole Jam / Bench Ledges",
            neighborhood: "114 Main St",
            coordinate: CLLocationCoordinate2D(latitude: 34.051647, longitude: -118.24341),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bench"],
            popularity: 62,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cannabis Co - Ledge To Bank",
            neighborhood: "1145 Santee St",
            coordinate: CLLocationCoordinate2D(latitude: 34.03712, longitude: -118.25745),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Canoga Park High School - 8 Stair",
            neighborhood: "6808 Topanga Canyon Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.194073, longitude: -118.6055),
            difficulty: .intermediate,
            terrainTags: ["8 Stair"],
            popularity: 55,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Car Wash Launch Gap",
            neighborhood: "905 S Sycamore Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.058784, longitude: -118.344795),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 97,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "CARCEN - Bank Ledge",
            neighborhood: "Sherman Way / Hayvenhurst",
            coordinate: CLLocationCoordinate2D(latitude: 34.201374, longitude: -118.49282),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Carlos Ave - Bump To Gap",
            neighborhood: "22 Carlos Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.102955, longitude: -118.31903),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 44,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Casanova St - Gap To Street",
            neighborhood: "427 Casanova St",
            coordinate: CLLocationCoordinate2D(latitude: 34.072147, longitude: -118.22941),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 34,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Castelar Elementary School Curve Ledge",
            neighborhood: "536 W College St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06475, longitude: -118.239876),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 74,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Catholic Center - Ledge",
            neighborhood: "698 S Mariposa Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.061066, longitude: -118.298645),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Catholic Church - 14 Stair Rail",
            neighborhood: "7344 Apperson St",
            coordinate: CLLocationCoordinate2D(latitude: 34.25648, longitude: -118.292404),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 60,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CBS Seafood Ledge",
            neighborhood: "700 N Spring St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05995, longitude: -118.23739),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 95,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Center For The Arts Pop Out Ledges",
            neighborhood: "2225 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.13953, longitude: -118.21509),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Century Blvd - Bank / Manny Pad",
            neighborhood: "2106 W Century Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.945343, longitude: -118.316284),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 30,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chase Handicap Rail",
            neighborhood: "1600 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.100063, longitude: -118.2916),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 86,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chase St - Ride On Ledge",
            neighborhood: "14355 Chase St",
            coordinate: CLLocationCoordinate2D(latitude: 34.224636, longitude: -118.44669),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chatsworth Courthouse - Ledges",
            neighborhood: "9425 Penfield Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.24182, longitude: -118.569984),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 52,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cheltenham Dr - Bank To Drop",
            neighborhood: "13348 Cheltenham Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.139732, longitude: -118.42425),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 55,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Children's Hospital - Downhill Curve Ledge",
            neighborhood: "1408 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.097233, longitude: -118.291565),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 41,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chinatown Bank To Ledge",
            neighborhood: "1012 Richmond St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05982, longitude: -118.21654),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chinatown Library - 9 Stair",
            neighborhood: "655 N Hill St",
            coordinate: CLLocationCoordinate2D(latitude: 34.060726, longitude: -118.24076),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 42,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chinatown Library - Launch Over Wall",
            neighborhood: "516 Ord St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06089, longitude: -118.24124),
            difficulty: .advanced,
            terrainTags: ["Wall"],
            popularity: 71,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Chinatown Station - 6 Stair Out Ledge",
            neighborhood: "Chinatown Station",
            coordinate: CLLocationCoordinate2D(latitude: 34.063988, longitude: -118.236084),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Ledge"],
            popularity: 60,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Choi Plaza - Manny Pad",
            neighborhood: "1451 San Pablo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.0621, longitude: -118.203476),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad", "Plaza"],
            popularity: 70,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "City National - 14 Stair",
            neighborhood: "340 S Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.051804, longitude: -118.25205),
            difficulty: .pro,
            terrainTags: ["14 Stair"],
            popularity: 40,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "City National Bank - 4 Stair Out Ledge",
            neighborhood: "4605 Lankershim Blvd Unit 311B",
            coordinate: CLLocationCoordinate2D(latitude: 34.1538, longitude: -118.368706),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Ledge", "Bank"],
            popularity: 76,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "City National Bank - Stairs",
            neighborhood: "Figueroa St & 6th St (Northbound)",
            coordinate: CLLocationCoordinate2D(latitude: 34.051136, longitude: -118.258064),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 34,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "City Terrace Park 24 Stair Rail",
            neighborhood: "1095 N Hazard Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.04977, longitude: -118.17837),
            difficulty: .pro,
            terrainTags: ["24 Stair", "Rail"],
            popularity: 19,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Clayton Ave W - 15 Stair Rail",
            neighborhood: "3915 Clayton Ave W",
            coordinate: CLLocationCoordinate2D(latitude: 34.099804, longitude: -118.27735),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cleaners - Handicap Rail",
            neighborhood: "1761 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.139675, longitude: -118.20563),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 85,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cleland Park - Bump To Bar",
            neighborhood: "4841 Cleland Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.114025, longitude: -118.21202),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Clifford Street Elementary School - Downhill Ledge / Street Gap",
            neighborhood: "2150 Duane St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08954, longitude: -118.25843),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CNA Building - Bump To Wallride",
            neighborhood: "2914 W 6th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06363, longitude: -118.28484),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 13,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "CNA Building - Double Rail Gap",
            neighborhood: "6th / Commonwealth",
            coordinate: CLLocationCoordinate2D(latitude: 34.063587, longitude: -118.285355),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 53,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Coldwater Canyon Ave - Bank To Ledge",
            neighborhood: "4712 Coldwater Canyon Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.156456, longitude: -118.41365),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "College View Ave - 9 Stair Rail",
            neighborhood: "5081 College View Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13992, longitude: -118.22038),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 44,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Colorado Blvd - 16 Stair Rail With Curve",
            neighborhood: "2263 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.139893, longitude: -118.21581),
            difficulty: .pro,
            terrainTags: ["16 Stair", "Rail"],
            popularity: 89,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Colorado Blvd - Ride On Curb",
            neighborhood: "1216 Linda Rosa Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13859, longitude: -118.19341),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 19,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Colorado Blvd - Step Up Ledge",
            neighborhood: "2460 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.140785, longitude: -118.2206),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Computer Repair - Manny Pad",
            neighborhood: "4875 Santa Monica Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.091, longitude: -118.296),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 94,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Confluence Plaza - 5 Stair Kink Rail",
            neighborhood: "500 N San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.081764, longitude: -118.22571),
            difficulty: .intermediate,
            terrainTags: ["5 Stair", "Rail", "Plaza"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Coranado Ledge",
            neighborhood: "2440 W Historic Rte 66",
            coordinate: CLLocationCoordinate2D(latitude: 34.079147, longitude: -118.26858),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 18,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Corner Ledge",
            neighborhood: "1197 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06806, longitude: -118.25012),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 94,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cory Ave - Berle Rail",
            neighborhood: "915 Cory Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09084, longitude: -118.39153),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 91,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cory's Basketball Courts Out Rail",
            neighborhood: "3602 N Broadway",
            coordinate: CLLocationCoordinate2D(latitude: 34.074142, longitude: -118.20205),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Courtesy Dock - 3 Block",
            neighborhood: "504 S Harbor Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.74003, longitude: -118.27924),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 17,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Crazy Girls - Gap To Ledge",
            neighborhood: "1433 N La Brea Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09707, longitude: -118.344284),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Crestmont Ave - Ledge to Hill Bomb",
            neighborhood: "3526 Crestmont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09279, longitude: -118.27495),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 30,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cromwell Ave - Skinny Bump To Pillar",
            neighborhood: "Los Feliz Heights Steps",
            coordinate: CLLocationCoordinate2D(latitude: 34.11235, longitude: -118.29466),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 57,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Crystal St - Downhill Curb Ledges",
            neighborhood: "2450 Crystal St",
            coordinate: CLLocationCoordinate2D(latitude: 34.10786, longitude: -118.25599),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Curb"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Crystal St - LA River Bank To Ledge",
            neighborhood: "2485 Fletcher Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.107933, longitude: -118.255165),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 37,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSU - 23 Stair Rail",
            neighborhood: "5151 State University Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.0687, longitude: -118.16776),
            difficulty: .pro,
            terrainTags: ["23 Stair", "Rail"],
            popularity: 73,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSU - 9 Stair Rail",
            neighborhood: "5151 State University Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.065845, longitude: -118.16851),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 28,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSU - Bank To Rail",
            neighborhood: "5151 State University Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.06696, longitude: -118.16829),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 49,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - 10 Stair Rail",
            neighborhood: "18111 Nordhoff St",
            coordinate: CLLocationCoordinate2D(latitude: 34.23975, longitude: -118.528755),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 21,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - 10 Stair Rails",
            neighborhood: "Manzanita Hall",
            coordinate: CLLocationCoordinate2D(latitude: 34.23798, longitude: -118.530205),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 92,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - 13 Stair Rail",
            neighborhood: "Unnamed Road",
            coordinate: CLLocationCoordinate2D(latitude: 34.241158, longitude: -118.52532),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 48,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - 8 Stair Rail",
            neighborhood: "Sierra Walk",
            coordinate: CLLocationCoordinate2D(latitude: 34.237988, longitude: -118.53079),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 98,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - Curb Ledge",
            neighborhood: "CSUN Transit Center",
            coordinate: CLLocationCoordinate2D(latitude: 34.24088, longitude: -118.53306),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Curb"],
            popularity: 39,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "CSUN - Handicap Out Rail",
            neighborhood: "9215-9205 Darby Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.237404, longitude: -118.53331),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 97,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Curry King - Curved Curb",
            neighborhood: "Fletcher / La Clede",
            coordinate: CLLocationCoordinate2D(latitude: 34.112453, longitude: -118.24911),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 11,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Curved Ledge",
            neighborhood: "15760 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.155346, longitude: -118.477196),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 80,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cypress Ave - Gap To Curb",
            neighborhood: "1203 Cypress Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.095383, longitude: -118.22797),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 43,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cypress Ave - Red Stair Ledge",
            neighborhood: "721 Cypress Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0914, longitude: -118.223625),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cypress Ave - Sidewalk Gap",
            neighborhood: "1717 N San Fernando Rd Unit P",
            coordinate: CLLocationCoordinate2D(latitude: 34.099033, longitude: -118.2334),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 43,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dahlia Dr - Curb Cut Flat Gap",
            neighborhood: "5110 Dahlia Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.14004, longitude: -118.19968),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 42,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dana Middle School - 10 Stair Rail",
            neighborhood: "1501 S Cabrillo Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.73031, longitude: -118.29536),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dana Middle School - 15 Stair Rail",
            neighborhood: "1501 S Cabrillo Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.730705, longitude: -118.29584),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 78,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dana Middle School - 16 Stair Rail",
            neighborhood: "1501 S Cabrillo Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.73139, longitude: -118.29582),
            difficulty: .pro,
            terrainTags: ["16 Stair", "Rail"],
            popularity: 91,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dana Middle School - 17 Stair Rail / Hubba",
            neighborhood: "1501 S Cabrillo Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.7298, longitude: -118.295784),
            difficulty: .pro,
            terrainTags: ["17 Stair", "Rail", "Hubba"],
            popularity: 82,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dana Middle School Over Rail Into Bank",
            neighborhood: "1337 S Parker St",
            coordinate: CLLocationCoordinate2D(latitude: 33.73139, longitude: -118.296135),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 56,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Davita Dialysis - Bank Grind Drop Off",
            neighborhood: "17813 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.16324, longitude: -118.52078),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 54,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "De Soto Ave - Manny Pad",
            neighborhood: "9243 De Soto Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.239597, longitude: -118.58897),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 93,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Del Rio - Bump To 5 Stair",
            neighborhood: "3432 S Sepulveda Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.02038, longitude: -118.42287),
            difficulty: .intermediate,
            terrainTags: ["5 Stair"],
            popularity: 34,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Delevan Drive - 14 Stair Out Ledge",
            neighborhood: "4147 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.125114, longitude: -118.22762),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Ledge"],
            popularity: 46,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Deloz Ave - Driveway Gap",
            neighborhood: "1840 Deloz Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10278, longitude: -118.277504),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 41,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Diego Rivera Learning Complex - Ledges",
            neighborhood: "1131 E 62nd St",
            coordinate: CLLocationCoordinate2D(latitude: 33.983753, longitude: -118.25542),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 75,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Do-it Center Bank",
            neighborhood: "1221 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.068893, longitude: -118.249985),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 37,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dockweiler Beach - Wallrides",
            neighborhood: "12701 Vista Del Mar",
            coordinate: CLLocationCoordinate2D(latitude: 33.9177, longitude: -118.429665),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 42,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dorsey High School - 10 Stair",
            neighborhood: "3566 Farmdale Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.021866, longitude: -118.34633),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 85,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Double Set Over Rail Into Bank",
            neighborhood: "4951 Elmwood Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.078587, longitude: -118.31517),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 93,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Douglas and Toluca - Sidewalk Manny Pad",
            neighborhood: "114 Douglas St",
            coordinate: CLLocationCoordinate2D(latitude: 34.061886, longitude: -118.2585),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 30,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Douglas St - 13 Stair Kink Hubba",
            neighborhood: "1119 Douglas St",
            coordinate: CLLocationCoordinate2D(latitude: 34.073044, longitude: -118.25303),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Hubba", "Kink Rail"],
            popularity: 36,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Downey Swimming Pool S Ledge",
            neighborhood: "1771 N Spring St",
            coordinate: CLLocationCoordinate2D(latitude: 34.071507, longitude: -118.22398),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 95,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Downtown Harbor - Ride On Ledge",
            neighborhood: "504 S Harbor Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.739166, longitude: -118.27897),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 22,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Downtown Harbor - Wood Ledges",
            neighborhood: "750 Sampson Way",
            coordinate: CLLocationCoordinate2D(latitude: 33.737675, longitude: -118.27861),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 42,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dr. Greenthumb Ledge",
            neighborhood: "2029 Pasadena Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07471, longitude: -118.220314),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 75,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dream Center Foundation - 15 Stair Rail / Hubba",
            neighborhood: "2301 Bellevue Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.074352, longitude: -118.26976),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail", "Hubba"],
            popularity: 82,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Driveway Bump Over Fence",
            neighborhood: "Hoover / Bellevue",
            coordinate: CLLocationCoordinate2D(latitude: 34.080765, longitude: -118.28433),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 52,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Dundee Rd - Bump Over Hydrant",
            neighborhood: "4526 Dundee Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.11557, longitude: -118.28785),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 22,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "E 31st St - Bump Gap",
            neighborhood: "936 E 31st St",
            coordinate: CLLocationCoordinate2D(latitude: 34.015617, longitude: -118.25876),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 11,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "E Cesar Chavez - 17 Stair Hubba",
            neighborhood: "447 E Cesar E Chavez Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.057053, longitude: -118.2331),
            difficulty: .pro,
            terrainTags: ["17 Stair", "Hubba"],
            popularity: 22,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock - 4 Flat 3 Double Set Hubbas",
            neighborhood: "Colorado & N. Maywood Ave. (Westbound)",
            coordinate: CLLocationCoordinate2D(latitude: 34.139374, longitude: -118.21126),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 87,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Auto Shop - Stair Ledge",
            neighborhood: "2442 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.140396, longitude: -118.22029),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Blvd - Bank To Gap Over Rail",
            neighborhood: "4363 N Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.123905, longitude: -118.22159),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap", "Bank"],
            popularity: 24,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Blvd - Bump Over Bush",
            neighborhood: "4689 N Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.13015, longitude: -118.216934),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Blvd - Bump To Bank Ledge",
            neighborhood: "3011 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.105743, longitude: -118.238144),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Blvd - Bump To Bike Rack",
            neighborhood: "4857 Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.13406, longitude: -118.21573),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 30,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Blvd - Channel Gap",
            neighborhood: "3139 Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.108997, longitude: -118.237495),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 15,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Elementary School - Curve Ledge",
            neighborhood: "2102 Chickasaw Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13674, longitude: -118.213394),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 91,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock High School - Ledges",
            neighborhood: "1750 Yosemite Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.13164, longitude: -118.20572),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock High School - Ride On Ledge",
            neighborhood: "1750 Yosemite Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.132484, longitude: -118.20691),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Plaza - 11 Flat",
            neighborhood: "2856 Rock Glen Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.1404, longitude: -118.22724),
            difficulty: .beginner,
            terrainTags: ["Plaza"],
            popularity: 18,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Plaza - 11 Stair",
            neighborhood: "2750 Rock Glen Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.14041, longitude: -118.22573),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Plaza"],
            popularity: 44,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eagle Rock Plaza - Bank / Slappy Curbs",
            neighborhood: "2828 El Verano Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.141098, longitude: -118.22654),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Curb", "Plaza"],
            popularity: 28,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Echo Park - 14 Stair",
            neighborhood: "751 Echo Park Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07328, longitude: -118.25984),
            difficulty: .pro,
            terrainTags: ["14 Stair"],
            popularity: 40,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Echo Park - Triple Set Ride On Hubba",
            neighborhood: "Glendale / Santa Ynez",
            coordinate: CLLocationCoordinate2D(latitude: 34.074306, longitude: -118.26187),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 51,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Echo Park Recreation Center - 14 Stair Hubba",
            neighborhood: "751 Echo Park Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.069664, longitude: -118.25989),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Hubba"],
            popularity: 95,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Echo Park United Methodist Church - Bump Over Wall",
            neighborhood: "1234 CA-2",
            coordinate: CLLocationCoordinate2D(latitude: 34.078835, longitude: -118.2624),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 21,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Echo Park United Methodist Church - Fence Gap",
            neighborhood: "1226 N Alvarado St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07875, longitude: -118.262344),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 36,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Edenhurst Ave - 8 Stair Rail",
            neighborhood: "3617 Edenhurst Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.118492, longitude: -118.26142),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 56,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Edgecliffe Dr - Down Ledge",
            neighborhood: "1600 Griffith Park Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.091194, longitude: -118.277435),
            difficulty: .advanced,
            terrainTags: ["Ledge"],
            popularity: 51,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Edgeware and Kellam - Bump Over Hydrant",
            neighborhood: "831 E Edgeware Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06976, longitude: -118.252914),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 31,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Effie St - Guardrail",
            neighborhood: "1684 Lucile Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.093147, longitude: -118.27703),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Egret Park - DIY Bank Ledge",
            neighborhood: "Los Angeles River Greenway Trail",
            coordinate: CLLocationCoordinate2D(latitude: 34.08356, longitude: -118.22812),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Bank"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Camino Real Charter High School - Kink Ledge",
            neighborhood: "5440 Valley Circle Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.17047, longitude: -118.642006),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Kink Rail"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Camino Real High School - 11 Stair Hubba",
            neighborhood: "5440 Valley Circle Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.170135, longitude: -118.64248),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Hubba"],
            popularity: 78,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Camino Real High School - Butter Bench",
            neighborhood: "5440 Valley Circle Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.17009, longitude: -118.64168),
            difficulty: .beginner,
            terrainTags: ["Bench"],
            popularity: 100,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Camino Real High School Out Ledges",
            neighborhood: "5440 Valley Cir Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.1698, longitude: -118.642525),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 90,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Paso Dr - Bump To Curb Cut Gap",
            neighborhood: "1253 El Paso Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.118046, longitude: -118.218925),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 10,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Paso Dr - Skinny Bank To Drop",
            neighborhood: "1011 El Paso Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.116203, longitude: -118.213554),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 58,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Sereno Park - 12 Stair Rail",
            neighborhood: "4721 Klamath St",
            coordinate: CLLocationCoordinate2D(latitude: 34.076206, longitude: -118.18198),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 78,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "El Verano Ave - Curb Cut Grass Gap",
            neighborhood: "5212 1/2 N El Verano Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.14326, longitude: -118.22589),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 41,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Eldred St - Hill Bomb",
            neighborhood: "4841 Eldred St",
            coordinate: CLLocationCoordinate2D(latitude: 34.108112, longitude: -118.20897),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 31,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Elysian Heights Elementary School - 18 Stair Rail",
            neighborhood: "1562 Baxter St",
            coordinate: CLLocationCoordinate2D(latitude: 34.088745, longitude: -118.24944),
            difficulty: .pro,
            terrainTags: ["18 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Elysian Park - 13 Stair Rail",
            neighborhood: "929 Academy Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.08066, longitude: -118.23769),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 77,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Elysian Park - 5 Flat 5 Double Set Gap To Rail",
            neighborhood: "929 Academy Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.080666, longitude: -118.23797),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 23,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Elysian Valley Park - Bank",
            neighborhood: "Elysian Valley Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.07585, longitude: -118.22729),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 33,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Encino Courtyard - 4 Flat 4 Double Set",
            neighborhood: "17401 Ventura Blvd a25",
            coordinate: CLLocationCoordinate2D(latitude: 34.16177, longitude: -118.51193),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Everett Place - Over Rail To Hubba",
            neighborhood: "1042 Everett Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.070408, longitude: -118.24814),
            difficulty: .advanced,
            terrainTags: ["Rail", "Hubba"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Evergreen Recreation Center - 11 Stair",
            neighborhood: "2844 E 2nd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.038998, longitude: -118.20461),
            difficulty: .advanced,
            terrainTags: ["11 Stair"],
            popularity: 46,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - 2 Flat 2 Rail",
            neighborhood: "546 State Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.016315, longitude: -118.283646),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 90,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Art Manny Pad",
            neighborhood: "654 Exposition Park Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.013542, longitude: -118.28527),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 52,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Bench",
            neighborhood: "701 State Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.017666, longitude: -118.28568),
            difficulty: .beginner,
            terrainTags: ["Bench"],
            popularity: 23,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Blue Curve Ledge",
            neighborhood: "612 S Hoover St",
            coordinate: CLLocationCoordinate2D(latitude: 34.01193, longitude: -118.28733),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 88,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Curved Ledge",
            neighborhood: "Lockheed A-12 \"Trainer\"",
            coordinate: CLLocationCoordinate2D(latitude: 34.015465, longitude: -118.28434),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 91,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Fountain Ledge",
            neighborhood: "700 Exposition Park Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.017006, longitude: -118.2861),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 32,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Ledges",
            neighborhood: "Expo Park / USC",
            coordinate: CLLocationCoordinate2D(latitude: 34.01794, longitude: -118.2861),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Exposition Park - Up Ledge",
            neighborhood: "699 W Exposition Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.01788, longitude: -118.28466),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Farwell Ave - Bump To Electrical Box",
            neighborhood: "Glendale / Farwell",
            coordinate: CLLocationCoordinate2D(latitude: 34.105396, longitude: -118.25974),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 13,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fierro St - Pipe",
            neighborhood: "1837 Fierro St",
            coordinate: CLLocationCoordinate2D(latitude: 34.120644, longitude: -118.2504),
            difficulty: .advanced,
            terrainTags: ["Street"],
            popularity: 96,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa St - Bus Stop Ledge",
            neighborhood: "Figueroa / Sycamore Grove Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.09972, longitude: -118.20407),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa St - Double Bank",
            neighborhood: "7155 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.132454, longitude: -118.189644),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 42,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa St - Gap Over Railing",
            neighborhood: "4513 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.096653, longitude: -118.206955),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 26,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa St - Ledge To Rail",
            neighborhood: "6512 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.120487, longitude: -118.183754),
            difficulty: .advanced,
            terrainTags: ["Rail", "Ledge"],
            popularity: 31,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa Terrace - 4 Stair Out Rail",
            neighborhood: "1059 1/2 Figueroa Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.06942, longitude: -118.24663),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Rail"],
            popularity: 55,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Figueroa Terrace - Bump To Rail",
            neighborhood: "1948 Alpine St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06502, longitude: -118.24583),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Flat To Red 6 Stair",
            neighborhood: "760 N Hoover St",
            coordinate: CLLocationCoordinate2D(latitude: 34.084938, longitude: -118.2844),
            difficulty: .intermediate,
            terrainTags: ["6 Stair"],
            popularity: 43,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fletcher Bowron Square - 13 Stair Curve Rail",
            neighborhood: "300 N Main St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05444, longitude: -118.24073),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 24,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fletcher Bowron Square 7 Stair Out Ledges",
            neighborhood: "Fletcher Bowron Square",
            coordinate: CLLocationCoordinate2D(latitude: 34.054108, longitude: -118.24139),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Ledge"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fletcher Dr - Gap",
            neighborhood: "3090 Roderick Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.118904, longitude: -118.23628),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 17,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fletcher Dr - Ledge Over Chain",
            neighborhood: "2860 Fletcher Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.112953, longitude: -118.24808),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 86,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Florence Nightingale High School - Bank Ledge",
            neighborhood: "Figueroa / Cypress",
            coordinate: CLLocationCoordinate2D(latitude: 34.08683, longitude: -118.218765),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Florence Nightingale Middle School - 12 Stair",
            neighborhood: "3242 Huron St",
            coordinate: CLLocationCoordinate2D(latitude: 34.086994, longitude: -118.21968),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 100,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Flower St 2 Stair Ledge",
            neighborhood: "540 Flower St",
            coordinate: CLLocationCoordinate2D(latitude: 34.050568, longitude: -118.25683),
            difficulty: .intermediate,
            terrainTags: ["2 Stair", "Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Food4Less - Wallride / Banks",
            neighborhood: "2800 1st St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04129, longitude: -118.20463),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Wall"],
            popularity: 13,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Foothill Blvd - 8 Stair Out Ledge",
            neighborhood: "6545 Foothill Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.24591, longitude: -118.27469),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Ledge"],
            popularity: 44,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Foothill Dr - Bump To Trash Can",
            neighborhood: "5830 Foothill Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.108253, longitude: -118.31643),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 33,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Founders MMC - 13 Stair Hubba",
            neighborhood: "4607 Prospect Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.101933, longitude: -118.28981),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Hubba"],
            popularity: 57,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "FourFortyFour South Flower - Planter Ledge To Gap",
            neighborhood: "444 Flower St SUITE 700",
            coordinate: CLLocationCoordinate2D(latitude: 34.051643, longitude: -118.25476),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 54,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin Ave - ARCO Ledges",
            neighborhood: "6120 Franklin Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10513, longitude: -118.323135),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 39,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin Ave - Blue Ledge",
            neighborhood: "1857 Taft Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10519, longitude: -118.31496),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 16,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin Ave - Bump To Rail / Gap To Ledge",
            neighborhood: "1900 Highland Ave #6",
            coordinate: CLLocationCoordinate2D(latitude: 34.105286, longitude: -118.3369),
            difficulty: .advanced,
            terrainTags: ["Rail", "Ledge", "Gap"],
            popularity: 49,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin Ave - Curb Cut Grass Gap",
            neighborhood: "4745 Franklin Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10548, longitude: -118.29348),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 46,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School - Banks",
            neighborhood: "823 N Ave 53",
            coordinate: CLLocationCoordinate2D(latitude: 34.11645, longitude: -118.201355),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 70,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School - Gap",
            neighborhood: "820 N Ave 53",
            coordinate: CLLocationCoordinate2D(latitude: 34.115845, longitude: -118.20092),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 85,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School 12 Stair Rail",
            neighborhood: "820 N Ave 54",
            coordinate: CLLocationCoordinate2D(latitude: 34.115257, longitude: -118.19898),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 98,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School 18 Stair Rail",
            neighborhood: "820 N Ave 54",
            coordinate: CLLocationCoordinate2D(latitude: 34.115562, longitude: -118.19838),
            difficulty: .pro,
            terrainTags: ["18 Stair", "Rail"],
            popularity: 67,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School 4 Stair Ledge",
            neighborhood: "820 N Ave 54",
            coordinate: CLLocationCoordinate2D(latitude: 34.1157, longitude: -118.19835),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Ledge"],
            popularity: 98,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School 9 Stair Rail",
            neighborhood: "820 N Ave 54",
            coordinate: CLLocationCoordinate2D(latitude: 34.115513, longitude: -118.19841),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin High School Bank To Bank",
            neighborhood: "923 N Ave 53",
            coordinate: CLLocationCoordinate2D(latitude: 34.116196, longitude: -118.20117),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 86,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Frontenac Ave - Guardrail to Bank",
            neighborhood: "516 W Ave 46",
            coordinate: CLLocationCoordinate2D(latitude: 34.10224, longitude: -118.21098),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 32,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Frost Middle School - 9 Flat 9 Over Rail Into Bank",
            neighborhood: "12314 Bradford Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.294968, longitude: -118.51081),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 85,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gap to ledge",
            neighborhood: "4140 S Hoover St",
            coordinate: CLLocationCoordinate2D(latitude: 34.008434, longitude: -118.287094),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 39,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gardner Street School - Roof Wallride",
            neighborhood: "7450 Hawthorn Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.099743, longitude: -118.351906),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 42,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Garvanza Elementary School - Ledge",
            neighborhood: "222 N Ave 62",
            coordinate: CLLocationCoordinate2D(latitude: 34.117, longitude: -118.183),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Garvanza Elementary School 10 Stair",
            neighborhood: "317 N Ave 62",
            coordinate: CLLocationCoordinate2D(latitude: 34.118023, longitude: -118.18198),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 87,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Garvanza Park Benches",
            neighborhood: "6273 Meridian St",
            coordinate: CLLocationCoordinate2D(latitude: 34.119865, longitude: -118.17966),
            difficulty: .beginner,
            terrainTags: ["Bench"],
            popularity: 31,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gateway Plaza",
            neighborhood: "Union Station Bay 2",
            coordinate: CLLocationCoordinate2D(latitude: 34.05515, longitude: -118.233215),
            difficulty: .beginner,
            terrainTags: ["Plaza"],
            popularity: 23,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Georgia St - Bump To Manny Pad",
            neighborhood: "1822 Georgia St",
            coordinate: CLLocationCoordinate2D(latitude: 34.03586, longitude: -118.27368),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 21,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gertrude St - 6 Stair Out Ledge",
            neighborhood: "337 1/2 Gertrude St",
            coordinate: CLLocationCoordinate2D(latitude: 34.043682, longitude: -118.21747),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Ledge"],
            popularity: 17,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Glassel Swimming Pool - Ledges",
            neighborhood: "3650 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.11634, longitude: -118.23332),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 11,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Glassell Park Recreation Center - Gap To Curve Ledge",
            neighborhood: "3522 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.11532, longitude: -118.234276),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 37,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Glendale Blvd - Bank To Drop Off",
            neighborhood: "2251 Glendale Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.095615, longitude: -118.25941),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 41,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Glendale Blvd - Brio Ledges",
            neighborhood: "525 Glendale Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06892, longitude: -118.26119),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 18,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Global Bakeries - 3 Flat 3 Double Set Rail",
            neighborhood: "13338 Paxton St",
            coordinate: CLLocationCoordinate2D(latitude: 34.275406, longitude: -118.423584),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Grace Ave - Pop Out Rail",
            neighborhood: "1969 Grace Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.107018, longitude: -118.3327),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 54,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gracita Place - 4 Up Gap Over Rail",
            neighborhood: "5304 Gracita Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.107647, longitude: -118.1983),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Granada Village - Drop",
            neighborhood: "10800-10898 Lindley Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.2672, longitude: -118.52633),
            difficulty: .advanced,
            terrainTags: ["Street"],
            popularity: 40,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Grand Park - 10 Then 13 Stair",
            neighborhood: "Downtown Los Angeles Grand Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.056774, longitude: -118.24756),
            difficulty: .advanced,
            terrainTags: ["13 Stair"],
            popularity: 54,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Grand Plaza Senior - 6 Stair Hubbas",
            neighborhood: "601a N Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.061443, longitude: -118.24345),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Hubba", "Plaza"],
            popularity: 79,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffin Ave - Bump To Rail",
            neighborhood: "1801 Griffin Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.064285, longitude: -118.211655),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 30,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffith Ave - Bump To Guardrail",
            neighborhood: "1847 Griffin Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.065407, longitude: -118.2117),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffith Park Bank Ledge",
            neighborhood: "Mineral Wells Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.146297, longitude: -118.295525),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffith Park Bank To Ledge",
            neighborhood: "Mineral Wells Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.146557, longitude: -118.29581),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffith Park DIY Barrier",
            neighborhood: "Mineral Wells Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.146843, longitude: -118.29699),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 42,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Griffith Park Golf Shop - 4 Flat 4 Double Set Out Rail",
            neighborhood: "4730 Crystal Springs Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.132744, longitude: -118.27989),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 39,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hale Charter Academy - 12 Stair Rail",
            neighborhood: "23830 Califa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.17663, longitude: -118.645935),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 82,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hall of Records - 5 Stair Rail",
            neighborhood: "225n N Hill St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05604, longitude: -118.24482),
            difficulty: .intermediate,
            terrainTags: ["5 Stair", "Rail"],
            popularity: 58,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hall of Records - Out Ledge",
            neighborhood: "320 W Temple St",
            coordinate: CLLocationCoordinate2D(latitude: 34.055927, longitude: -118.244064),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 38,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hallett Ave - 13 Stair Rail",
            neighborhood: "2914 Hallett Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.108585, longitude: -118.24106),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 57,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Happy's - Manny Pad",
            neighborhood: "807 N Avenue 50",
            coordinate: CLLocationCoordinate2D(latitude: 34.1136, longitude: -118.20829),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 10,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Happy's - Over Pole to Ledge",
            neighborhood: "813 N Avenue 50",
            coordinate: CLLocationCoordinate2D(latitude: 34.113693, longitude: -118.208015),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Haskell Ave - Flat Gap",
            neighborhood: "7457 Haskell Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.206436, longitude: -118.474815),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 44,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Heath Hydrant",
            neighborhood: "222 4th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.050785, longitude: -118.251434),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 24,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hebrew Union College - 4 Stair Gap To Bench",
            neighborhood: "Hebrew Union College-Jewish Institute of Religion",
            coordinate: CLLocationCoordinate2D(latitude: 34.025585, longitude: -118.28326),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Gap", "Bench"],
            popularity: 24,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hebrew Union College 7 Stair Rail",
            neighborhood: "845 W 32nd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.025517, longitude: -118.28319),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 86,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Henry Clay Middle School - 11 Stair Rail",
            neighborhood: "12236 S Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.920918, longitude: -118.3087),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 28,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hermon Park Bank Ledge",
            neighborhood: "5921 Monterey Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.10514, longitude: -118.1858),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 20,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Highland Park Recreation Center Long 4 Stair Rail",
            neighborhood: "6150 Piedmont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.113464, longitude: -118.187935),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Rail"],
            popularity: 96,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Highland Park Station - Ledges",
            neighborhood: "151 N Ave 57",
            coordinate: CLLocationCoordinate2D(latitude: 34.11108, longitude: -118.19265),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 32,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hilgard Ave - 7 Stair Hubba",
            neighborhood: "862 Hilgard Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.065067, longitude: -118.44052),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Hubba"],
            popularity: 47,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hill St - Handicap Rail",
            neighborhood: "3856 S Hill St",
            coordinate: CLLocationCoordinate2D(latitude: 34.013206, longitude: -118.2789),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hillandale Dr - Drop In Rail Hill Bomb",
            neighborhood: "6000 Hillandale Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.12547, longitude: -118.18938),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 48,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hillandale Dr - Gap To Drop Down Rail",
            neighborhood: "6000 Hillandale Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.12547, longitude: -118.18938),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 10,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hillhurst Ave - Bump Over Wall",
            neighborhood: "2131 Hillhurst Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.111183, longitude: -118.28761),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 51,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hillhurst Ave - Sidewalk Bump To Bench",
            neighborhood: "1971 Hillhurst Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10743, longitude: -118.28752),
            difficulty: .intermediate,
            terrainTags: ["Bench"],
            popularity: 30,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hillside Elementary School - 5 Flat 6 Double Set Out Ledge",
            neighborhood: "120 E Ave 35",
            coordinate: CLLocationCoordinate2D(latitude: 34.08537, longitude: -118.21224),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 82,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hip / Over Guardrail To Bank",
            neighborhood: "10 S Ave 66",
            coordinate: CLLocationCoordinate2D(latitude: 34.113842, longitude: -118.17899),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 12,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hobart Boulevard 8 Stair Hubba",
            neighborhood: "955 S Harvard Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.05315, longitude: -118.30486),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Hubba"],
            popularity: 37,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hollenbeck RC 7 Stair Rail",
            neighborhood: "Hollenbeck Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.040104, longitude: -118.21748),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hollywood Blvd - Flat Gap / Gap To Curb",
            neighborhood: "5625 Hollywood Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.10168, longitude: -118.31215),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 20,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hollywood High",
            neighborhood: "1601-1611 N Highland Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10003, longitude: -118.33889),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 100,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hollywood/Western Station - 8 Stair Gap Over Rail",
            neighborhood: "1672 N Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.101494, longitude: -118.30905),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail", "Gap"],
            popularity: 72,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Home Depot Curbs / DIY",
            neighborhood: "2011 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.082043, longitude: -118.2255),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 29,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hoover St - Fence Ledge",
            neighborhood: "643 N Hoover St",
            coordinate: CLLocationCoordinate2D(latitude: 34.083, longitude: -118.28456),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 41,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Horace Mann Middle School 8 Stair Out Ledges",
            neighborhood: "7001 S St Andrews Pl",
            coordinate: CLLocationCoordinate2D(latitude: 33.976162, longitude: -118.311264),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "HPMC - Ledges",
            neighborhood: "1304 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09579, longitude: -118.29161),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hubert Howe Bancroft Middle School - Bump To Bleachers",
            neighborhood: "6748 Romaine St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08844, longitude: -118.33722),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 68,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Humboldt St - Bump Over Pole",
            neighborhood: "224 N Ave 21",
            coordinate: CLLocationCoordinate2D(latitude: 34.077465, longitude: -118.22165),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 43,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntington Drive Elementary - 13 Stair",
            neighborhood: "4435 Huntington Dr N",
            coordinate: CLLocationCoordinate2D(latitude: 34.08267, longitude: -118.19183),
            difficulty: .advanced,
            terrainTags: ["13 Stair"],
            popularity: 55,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntington Drive Elementary - DIY Bank Ledge",
            neighborhood: "4435 Huntington Dr N",
            coordinate: CLLocationCoordinate2D(latitude: 34.08233, longitude: -118.19253),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 56,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntington Drive Elementary - Roof Gap",
            neighborhood: "4435 Huntington Dr N",
            coordinate: CLLocationCoordinate2D(latitude: 34.08209, longitude: -118.19229),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 78,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntington Drive Elementary School - Gap Over Rail",
            neighborhood: "4435 Huntington Dr N",
            coordinate: CLLocationCoordinate2D(latitude: 34.082382, longitude: -118.19212),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 89,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntley Dr - Small Hubbas",
            neighborhood: "1207 Miramar St",
            coordinate: CLLocationCoordinate2D(latitude: 34.057182, longitude: -118.25736),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 44,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huxley St - Ledge",
            neighborhood: "3420 N Huxley St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11616, longitude: -118.27372),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 45,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hyperion Ave - 8 Stair Out Rail",
            neighborhood: "2829 Hyperion Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.108868, longitude: -118.27166),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 87,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hyperion Ave - Driveway Bump Gap",
            neighborhood: "824 Hyperion Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.086372, longitude: -118.28322),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 32,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "IceLink - Bump To Bar",
            neighborhood: "664 N Kilkea Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.083344, longitude: -118.36671),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 100,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "IHOP - Wallie Over Gap",
            neighborhood: "15635 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.15559, longitude: -118.474785),
            difficulty: .advanced,
            terrainTags: ["Gap", "Wall"],
            popularity: 24,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Industry Rag - Ledge Drop Ledge",
            neighborhood: "2936 E 11th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.02115, longitude: -118.21516),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Italy Fabrics - Flat Rail",
            neighborhood: "903 Wall St # 5",
            coordinate: CLLocationCoordinate2D(latitude: 34.038456, longitude: -118.252365),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ivanhoe Elementary School - 4 Stair Kink Rail",
            neighborhood: "2825 1/2 Herkimer St",
            coordinate: CLLocationCoordinate2D(latitude: 34.108932, longitude: -118.267334),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Rail", "Kink Rail"],
            popularity: 96,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "James M Wood Blvd - Gap Over Hubba",
            neighborhood: "3348 James M Wood Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.055775, longitude: -118.30483),
            difficulty: .advanced,
            terrainTags: ["Hubba", "Gap"],
            popularity: 58,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Japanese American National Museum - 9 Stair Rail",
            neighborhood: "2QX6+QH",
            coordinate: CLLocationCoordinate2D(latitude: 34.04939, longitude: -118.23895),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 37,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Japanese Garden Brick 4 Block",
            neighborhood: "240 San Pedro St",
            coordinate: CLLocationCoordinate2D(latitude: 34.048027, longitude: -118.24149),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 33,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Jewish Community Center - Curve Ledge",
            neighborhood: "1110 Bates Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.09499, longitude: -118.28227),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Jim Gilliam Park - Ledges",
            neighborhood: "4761 Don Ricardo Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.012478, longitude: -118.3552),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 37,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "JKwon",
            neighborhood: "3700 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.060955, longitude: -118.307236),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 37,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "John Marshall High School - Curved Sidewalk Ledges",
            neighborhood: "3918 Tracy St",
            coordinate: CLLocationCoordinate2D(latitude: 34.107544, longitude: -118.27732),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kaiser Pop Out Ledge",
            neighborhood: "College & Figueroa Terr.",
            coordinate: CLLocationCoordinate2D(latitude: 34.066376, longitude: -118.24403),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 32,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kashira Flat Gap Manny Pad",
            neighborhood: "640 S Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.062027, longitude: -118.30885),
            difficulty: .advanced,
            terrainTags: ["Gap", "Manual Pad"],
            popularity: 39,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Keller St - Loading Dock Out Ledge",
            neighborhood: "753 Keller St",
            coordinate: CLLocationCoordinate2D(latitude: 34.054516, longitude: -118.22905),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 51,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Keller Williams - 3 Up 3 Down",
            neighborhood: "11812 San Vicente Blvd # 505",
            coordinate: CLLocationCoordinate2D(latitude: 34.052876, longitude: -118.468475),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 78,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kester Avenue Banks",
            neighborhood: "7775 Kester Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.211952, longitude: -118.45774),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 82,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kitchen Mouse - Ledge",
            neighborhood: "111 S Ave 59",
            coordinate: CLLocationCoordinate2D(latitude: 34.110126, longitude: -118.19066),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 23,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Knapp Park Ditch",
            neighborhood: "25000 Kittridge St",
            coordinate: CLLocationCoordinate2D(latitude: 34.188694, longitude: -118.66355),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Korean Friendship Bell",
            neighborhood: "3601 S Gaffey St",
            coordinate: CLLocationCoordinate2D(latitude: 33.70969, longitude: -118.2938),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 72,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA BOS - Double Set Wall Rail",
            neighborhood: "500 W Temple St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05762, longitude: -118.24614),
            difficulty: .advanced,
            terrainTags: ["Rail", "Wall"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA County Jail - Bank To Lege",
            neighborhood: "441 Bauchet St",
            coordinate: CLLocationCoordinate2D(latitude: 34.059586, longitude: -118.23188),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 43,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA Courthouse Ledges",
            neighborhood: "110 N Grand Ave suite 525",
            coordinate: CLLocationCoordinate2D(latitude: 34.056267, longitude: -118.24806),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA Criminal Courts Curve Ledge",
            neighborhood: "Broadway & Temple",
            coordinate: CLLocationCoordinate2D(latitude: 34.055946, longitude: -118.24359),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 35,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA High School - Brick Banks",
            neighborhood: "4650 W Olympic Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.056408, longitude: -118.332634),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 71,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA High School - Planter Ledges",
            neighborhood: "1139 West Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.05469, longitude: -118.33212),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA River & Orange Line Busway - DIY Bank To Ledge",
            neighborhood: "17301 W Oxnard St",
            coordinate: CLLocationCoordinate2D(latitude: 34.18301, longitude: -118.51073),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LA River Bike Path - DIY / Barrier Ledge",
            neighborhood: "2760 Riverside Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.110184, longitude: -118.26204),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 30,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "La Roda Ave - Roof To Square",
            neighborhood: "5036 La Roda Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.137917, longitude: -118.204666),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 55,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "LACC - 12 Stair",
            neighborhood: "755 N New Hampshire Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.085632, longitude: -118.29384),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 21,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "LACC - 3 Flat 3 Double Set Rail",
            neighborhood: "840 Heliotrope Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.086853, longitude: -118.29486),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LACC - Bank To Ledge",
            neighborhood: "855 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.089123, longitude: -118.29199),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LACC - Out Rail",
            neighborhood: "855 Heliotrope Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.087605, longitude: -118.29431),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 47,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lacy St - 2 Stair Ledge",
            neighborhood: "2622 Lacy St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08249, longitude: -118.219475),
            difficulty: .intermediate,
            terrainTags: ["2 Stair", "Ledge"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laguna Ave - Street Gap",
            neighborhood: "1136 Laguna Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.075703, longitude: -118.25656),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 21,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lake Hollywood Dr - Bench To Gap",
            neighborhood: "3356 Barham Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.132107, longitude: -118.34393),
            difficulty: .advanced,
            terrainTags: ["Gap", "Bench"],
            popularity: 89,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lake St - 7 Flat 3 Double Set Hubba",
            neighborhood: "230 N Lake St",
            coordinate: CLLocationCoordinate2D(latitude: 34.068966, longitude: -118.27001),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 27,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lake Street Primary - 3 Flat 3",
            neighborhood: "123 N Lake St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06832, longitude: -118.2712),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 88,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lanai Road Elementary School - 7 Flat 8 Double Set Gap To Rail",
            neighborhood: "4241 Lanai Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.148415, longitude: -118.49293),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 70,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lanai Road Elementary School - Bump Over Wall",
            neighborhood: "4241 Lanai Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.14848, longitude: -118.49339),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 63,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Landfair Ave - 10 Stair Rail / Hubba",
            neighborhood: "525 1/2 Landfair Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.06788, longitude: -118.450516),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail", "Hubba"],
            popularity: 52,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Landfair Drop Down Ledge",
            neighborhood: "676 Landfair Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.065884, longitude: -118.448074),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Landmark Theatres - 11 Stair",
            neighborhood: "8000 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.097816, longitude: -118.36546),
            difficulty: .advanced,
            terrainTags: ["11 Stair"],
            popularity: 43,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Larissa Dr - 9 Stair Rail",
            neighborhood: "3204 Larissa Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.085155, longitude: -118.27572),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 19,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Larissa Dr - Banked Ledge",
            neighborhood: "3222 Descanso Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.084774, longitude: -118.27556),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 39,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Larissa Dr - Gap To Ledge",
            neighborhood: "3464 Larissa Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.088207, longitude: -118.277626),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LASHP - Wood Circle Manny Pads",
            neighborhood: "1315 N Spring St",
            coordinate: CLLocationCoordinate2D(latitude: 34.066875, longitude: -118.233185),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 46,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laurel Canyon Blvd - Parking Lot Rail",
            neighborhood: "1511 Laurel Canyon Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.098396, longitude: -118.36504),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LAVC - 10 Stair Rails",
            neighborhood: "5800 Fulton Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.1762, longitude: -118.42101),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LAVC - Administration Center Ledge",
            neighborhood: "600 College Rd S",
            coordinate: CLLocationCoordinate2D(latitude: 34.175423, longitude: -118.42189),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 97,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LAVC - Planter Ledge",
            neighborhood: "College Rd S",
            coordinate: CLLocationCoordinate2D(latitude: 34.17407, longitude: -118.42136),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 95,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laveta Terrace - 12 Stair",
            neighborhood: "1351 Laveta Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.076893, longitude: -118.25532),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 45,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laveta Terrace - Sidewalk Bump To Wallride",
            neighborhood: "1321 Laveta Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.076797, longitude: -118.25575),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 22,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ledge + Bump Over Hydrant",
            neighborhood: "3665 S Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.017353, longitude: -118.27806),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lenawee Ave - Gap Over Rail Into Bank",
            neighborhood: "3691 Lenawee Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.019268, longitude: -118.375984),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap", "Bank"],
            popularity: 74,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lexington Ave - 9 Flat Gap Over Gate",
            neighborhood: "4727 Lexington Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.093548, longitude: -118.29263),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 51,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lincoln Heights Jail - 9 Stair Out Ledge",
            neighborhood: "425 N Ave 19",
            coordinate: CLLocationCoordinate2D(latitude: 34.077793, longitude: -118.22499),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Ledge"],
            popularity: 12,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lincoln Heights Library - Ledge",
            neighborhood: "2514 1/2 Workman St",
            coordinate: CLLocationCoordinate2D(latitude: 34.076004, longitude: -118.214294),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Linda Rosa Ave - Sidewalk Bump",
            neighborhood: "1843 Linda Rosa Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.135437, longitude: -118.20756),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 18,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Little Tokyo - 11 Stair",
            neighborhood: "335 E 2nd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04946, longitude: -118.24095),
            difficulty: .advanced,
            terrainTags: ["11 Stair"],
            popularity: 50,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Little Tokyo - Bump to Bar",
            neighborhood: "306 E 2nd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04927, longitude: -118.241516),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 26,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Little Tokyo Mall - 13 Stair Hubba",
            neighborhood: "319 E 2nd St #205",
            coordinate: CLLocationCoordinate2D(latitude: 34.049553, longitude: -118.24092),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Hubba"],
            popularity: 38,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "LMU - Regents Terrace Manny Pad",
            neighborhood: "St. Robert's Hall",
            coordinate: CLLocationCoordinate2D(latitude: 33.971058, longitude: -118.416626),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 27,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Logan Academy - Bump To Rail",
            neighborhood: "1707 Montana St",
            coordinate: CLLocationCoordinate2D(latitude: 34.078587, longitude: -118.25792),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 99,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Loleta Ave - Yellow Rail",
            neighborhood: "5118 Loleta Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13983, longitude: -118.198044),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 42,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "London St - Sidewalk Bump Over Gate",
            neighborhood: "3506 London St",
            coordinate: CLLocationCoordinate2D(latitude: 34.078964, longitude: -118.283066),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 55,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Long Curved Downhill Barrier",
            neighborhood: "221-225 S Vista Del Mar Ln",
            coordinate: CLLocationCoordinate2D(latitude: 33.95819, longitude: -118.44829),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 49,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Long ledge",
            neighborhood: "3901-4161 Alcove Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.14449, longitude: -118.41269),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 11,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lorena Street Elementary School",
            neighborhood: "1015 S Lorena St",
            coordinate: CLLocationCoordinate2D(latitude: 34.02521, longitude: -118.20324),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 98,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Loretto High School Ride On Ledge",
            neighborhood: "Lake Street Community Center",
            coordinate: CLLocationCoordinate2D(latitude: 34.069057, longitude: -118.27055),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Angeles City Hall - Metal Bank",
            neighborhood: "146 N Main St",
            coordinate: CLLocationCoordinate2D(latitude: 34.053013, longitude: -118.243004),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 42,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Angeles Library Gap",
            neighborhood: "524s S Flower St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05107, longitude: -118.25615),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 88,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Angeles Mission College - Loading Dock Bank Ledge",
            neighborhood: "13356 Eldridge Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.31545, longitude: -118.418465),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 93,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Angeles Plaza Park - 8 Stair Rail / Gap Over Chain",
            neighborhood: "Los Angeles Plaza Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.056618, longitude: -118.23877),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail", "Gap"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Feliz 4 Flat 5 Double Set",
            neighborhood: "2925 Revere Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.126373, longitude: -118.26349),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 100,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Los Palos St - Metal Ledge",
            neighborhood: "1229 Los Palos St",
            coordinate: CLLocationCoordinate2D(latitude: 34.01782, longitude: -118.19528),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 13,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lube Masters - Gap Over Rail",
            neighborhood: "2801 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.142914, longitude: -118.22619),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 76,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lucile Ave - Sidewalk Bump",
            neighborhood: "969 Lucile Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.086964, longitude: -118.28175),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 42,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lutheran Church - Curve Ledge",
            neighborhood: "1986 Chickasaw Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13749, longitude: -118.211266),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 16,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lyman Place - Ledge",
            neighborhood: "1266 Lyman Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.0951, longitude: -118.28865),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 47,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "MacArthur Park - 17 Stair Rail",
            neighborhood: "MacArthur Park Underpass Tunnel Murals",
            coordinate: CLLocationCoordinate2D(latitude: 34.059772, longitude: -118.27856),
            difficulty: .pro,
            terrainTags: ["17 Stair", "Rail"],
            popularity: 30,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Maltman Ave - Bank Over Rail",
            neighborhood: "1525 Maltman Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0903, longitude: -118.27666),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 15,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Maltman Ave - Downhill Ledge",
            neighborhood: "1347 Maltman Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.08744, longitude: -118.27831),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 33,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Manzanita Street - Curb Cut To Guardrail",
            neighborhood: "860 Manzanita St",
            coordinate: CLLocationCoordinate2D(latitude: 34.088318, longitude: -118.28427),
            difficulty: .advanced,
            terrainTags: ["Rail", "Curb"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Marathon St - Bank Over Bush",
            neighborhood: "3507 Marathon St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08296, longitude: -118.28055),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 31,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Marathon St - Sidewalk Bump To Street Gap",
            neighborhood: "2810 Marathon St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07971, longitude: -118.27344),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 36,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mariachi Plaza - 4 Up 4 Down",
            neighborhood: "1819 East Mariachi Plaza De",
            coordinate: CLLocationCoordinate2D(latitude: 34.047478, longitude: -118.219),
            difficulty: .beginner,
            terrainTags: ["Plaza"],
            popularity: 18,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Marmion Way - Bump To Rail",
            neighborhood: "144 N Ave 51",
            coordinate: CLLocationCoordinate2D(latitude: 34.10661, longitude: -118.20175),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 40,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Martha St - Bank To Ledge",
            neighborhood: "5645 Oakdale Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.173405, longitude: -118.56574),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 18,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mary M. Bethune Park - 3 Stair Out Rail",
            neighborhood: "1244 E 61st St",
            coordinate: CLLocationCoordinate2D(latitude: 33.983677, longitude: -118.25247),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Rail"],
            popularity: 10,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "McCollum St - Over Chain To Bank",
            neighborhood: "1536 McCollum St",
            coordinate: CLLocationCoordinate2D(latitude: 34.085526, longitude: -118.26583),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 20,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Melrose Bump To Bar",
            neighborhood: "5959 Melrose Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.083553, longitude: -118.33039),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Melrose Car Wash - Pole Wallride",
            neighborhood: "5935 Melrose Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.08359, longitude: -118.32952),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 31,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mercury Ave - Out To Down Rail",
            neighborhood: "4531 Mercury Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.086037, longitude: -118.18957),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 72,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Meridian Bump To Street",
            neighborhood: "5939 Meridian St",
            coordinate: CLLocationCoordinate2D(latitude: 34.120266, longitude: -118.18883),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 76,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Miguel Contreras - Step Up Ledge",
            neighborhood: "3rd / Bixel",
            coordinate: CLLocationCoordinate2D(latitude: 34.057762, longitude: -118.259895),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 79,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Miguel Contreras - Wallride",
            neighborhood: "1239 Miramar St",
            coordinate: CLLocationCoordinate2D(latitude: 34.057907, longitude: -118.25848),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 84,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Millennium Biltmore Hotel - Curb Cut Bump Gap",
            neighborhood: "520 W 5th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04991, longitude: -118.25365),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 49,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Milo Terrace - 8 Stair Gap Over Rail",
            neighborhood: "631 Milo Terrace",
            coordinate: CLLocationCoordinate2D(latitude: 34.11303, longitude: -118.20707),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail", "Gap"],
            popularity: 47,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Miner St Double Kink Rail",
            neighborhood: "1540 S Harbor Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.729877, longitude: -118.2798),
            difficulty: .advanced,
            terrainTags: ["Rail", "Kink Rail"],
            popularity: 22,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mission Hills - 3 Flat 3 Double Set",
            neighborhood: "15451 San Fernando Mission Blvd #100",
            coordinate: CLLocationCoordinate2D(latitude: 34.272156, longitude: -118.4685),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 95,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "MOCA - 12 Stair",
            neighborhood: "250 Grand Lower",
            coordinate: CLLocationCoordinate2D(latitude: 34.053337, longitude: -118.250725),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 33,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mohawk St - Ledge",
            neighborhood: "1113 Mohawk St",
            coordinate: CLLocationCoordinate2D(latitude: 34.0779, longitude: -118.265366),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 73,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Montana St - Manny Pad / Ledge",
            neighborhood: "1617 Montana St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07825, longitude: -118.25729),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Manual Pad"],
            popularity: 19,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Monte Vista St - Bump Over Fence",
            neighborhood: "5622 1/2 Monte Vista St",
            coordinate: CLLocationCoordinate2D(latitude: 34.111477, longitude: -118.194916),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 27,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Monte Vista St - Gap To Curb",
            neighborhood: "5535 Monte Vista St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11115, longitude: -118.1959),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 39,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Monterey Rd - Skinny Drop In",
            neighborhood: "6524 Monterey Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.10942, longitude: -118.17783),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Motor Ave - Bump To Bar",
            neighborhood: "3501 Motor Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.02617, longitude: -118.40853),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 18,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mount Gleason Middle School - 10 Stair Rail",
            neighborhood: "10965 Mt Gleason Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.268433, longitude: -118.30391),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 52,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mountain View Elementary - 4 Stair Out Ledge",
            neighborhood: "6410 Olcott St",
            coordinate: CLLocationCoordinate2D(latitude: 34.24893, longitude: -118.272194),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Ledge"],
            popularity: 72,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mt Washington Elementary School - Ride On Ledge",
            neighborhood: "3995 San Rafael Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.10506, longitude: -118.21516),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 98,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Museum of Contemporary Art 20 Stair Rail",
            neighborhood: "300 S Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.05271, longitude: -118.251175),
            difficulty: .pro,
            terrainTags: ["20 Stair", "Rail"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Alvarado St - Mayas Ledge",
            neighborhood: "1666 N Alvarado St",
            coordinate: CLLocationCoordinate2D(latitude: 34.083637, longitude: -118.259674),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 19 - DIY Barrier",
            neighborhood: "440 W Ave 19",
            coordinate: CLLocationCoordinate2D(latitude: 34.078487, longitude: -118.22515),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 50 - Gap Over Pole",
            neighborhood: "795 N Avenue 50",
            coordinate: CLLocationCoordinate2D(latitude: 34.112354, longitude: -118.207664),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 47,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 50 - Skinny 14 Stair",
            neighborhood: "945 N Avenue 50",
            coordinate: CLLocationCoordinate2D(latitude: 34.116707, longitude: -118.20713),
            difficulty: .pro,
            terrainTags: ["14 Stair"],
            popularity: 31,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 51 - Street Gap",
            neighborhood: "1076 N Ave 51",
            coordinate: CLLocationCoordinate2D(latitude: 34.11811, longitude: -118.20555),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 19,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 54 - Gap Ledge Gap",
            neighborhood: "5329 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12016, longitude: -118.19933),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 55 - Step Up Ledge",
            neighborhood: "109 N Ave 55",
            coordinate: CLLocationCoordinate2D(latitude: 34.108807, longitude: -118.19579),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 56 - Bump Over Wall",
            neighborhood: "1112 N Ave 56",
            coordinate: CLLocationCoordinate2D(latitude: 34.119614, longitude: -118.1966),
            difficulty: .intermediate,
            terrainTags: ["Wall"],
            popularity: 28,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 56 - Ledges",
            neighborhood: "111 N Ave 56",
            coordinate: CLLocationCoordinate2D(latitude: 34.10937, longitude: -118.19442),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Ave 59 - Long Ledge",
            neighborhood: "304 N Ave 59",
            coordinate: CLLocationCoordinate2D(latitude: 34.11291, longitude: -118.19258),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 45,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Boylston St Gap Over Rail",
            neighborhood: "Temple / Boylston",
            coordinate: CLLocationCoordinate2D(latitude: 34.06457, longitude: -118.25273),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 32,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Edgemont St - Down Hill Ledge",
            neighborhood: "4842 Hollywood Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.10114, longitude: -118.295586),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Gage Ave - DIY Bank To Hill Bomb",
            neighborhood: "913 N Gage Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.046658, longitude: -118.18469),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 13,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Heliotrope Dr Bank To Barrier",
            neighborhood: "620 N Heliotrope Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.08169, longitude: -118.295525),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 23,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Hill St - Skinny Bank",
            neighborhood: "717 N Hill St",
            coordinate: CLLocationCoordinate2D(latitude: 34.057808, longitude: -118.24261),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Madison Ave - Driveway Ledge",
            neighborhood: "712 N Madison Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.084126, longitude: -118.289154),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 14,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Marianna Ave - Kink Ledge",
            neighborhood: "1972 N Marianna Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.065594, longitude: -118.17807),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Kink Rail"],
            popularity: 17,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Mission Rd - Bump",
            neighborhood: "3935 N Mission Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.07323, longitude: -118.19716),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Mission Rd - Ledge to Dirt Hill Bomb",
            neighborhood: "1804 Hancock St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06437, longitude: -118.20884),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N New Hampshire Ave - Handicap Rail",
            neighborhood: "1007 1/2 N New Hampshire Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0896, longitude: -118.29296),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Poinsettia Pl - Curb Cut Grass Gap",
            neighborhood: "1334 N Poinsettia Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.09546, longitude: -118.34829),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 18,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Record Dr - Bank Ledge Hill Bomb",
            neighborhood: "3911 Floral Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.044437, longitude: -118.181755),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 45,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N San Fernando Rd - Overpass Bump To Rail",
            neighborhood: "471 N San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.080288, longitude: -118.224884),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 10,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Savannah St - Street Gap",
            neighborhood: "348 1/2 N Savannah St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04365, longitude: -118.20184),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 48,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Soto St - Banked Manny Pad",
            neighborhood: "2538 1/2 N Soto St",
            coordinate: CLLocationCoordinate2D(latitude: 34.076656, longitude: -118.193695),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 44,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Soto St - Bump To Rail",
            neighborhood: "2331 E Cesar E Chavez Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.047073, longitude: -118.207756),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 26,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Vendome St - Bank To Ledge",
            neighborhood: "715 N Vendome St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07985, longitude: -118.27709),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 46,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Vermont Ave - Ledge With Ride On Grind",
            neighborhood: "401 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.078106, longitude: -118.291916),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 45,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Vermont Ave ATM - Bump To Out Rail",
            neighborhood: "1601 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.100372, longitude: -118.29195),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "N Virgil Ave - Long 6 Stair Rail",
            neighborhood: "445 N Virgil Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.078896, longitude: -118.286964),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Rail"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Newell St - Bump To Street",
            neighborhood: "2652 Newell St",
            coordinate: CLLocationCoordinate2D(latitude: 34.09929, longitude: -118.24699),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 50,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Normandie Recreation Center - 7 Stair Rail",
            neighborhood: "1550 Normandie Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.045044, longitude: -118.30015),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 18,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "North Ave - Curved Ride On Ledge",
            neighborhood: "360 N Ave 59",
            coordinate: CLLocationCoordinate2D(latitude: 34.114296, longitude: -118.193375),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "North Beacon St - 6 Stair Gap to Hubba",
            neighborhood: "108 W Santa Cruz St",
            coordinate: CLLocationCoordinate2D(latitude: 33.744316, longitude: -118.28054),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Hubba", "Gap"],
            popularity: 22,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "North Hill St - Ledge To Bench",
            neighborhood: "Hill St & 1st St (Northbound)",
            coordinate: CLLocationCoordinate2D(latitude: 34.054794, longitude: -118.24605),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bench"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "North Hollywood - Mural Bank",
            neighborhood: "12544 Saticoy St S",
            coordinate: CLLocationCoordinate2D(latitude: 34.203693, longitude: -118.405655),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 28,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oak Tree Dr - Bump To Ledge",
            neighborhood: "1824 Oak Tree Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.137077, longitude: -118.20659),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 42,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakwood Ave - Double Set Gap Over Rail",
            neighborhood: "7955 Oakwood Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0783, longitude: -118.36304),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 40,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakwood Ave - Gap To Curb",
            neighborhood: "4098 Oakwood Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07758, longitude: -118.29575),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 10,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oasis - 3 Stair Out Rail",
            neighborhood: "4906 W Melrose Hl",
            coordinate: CLLocationCoordinate2D(latitude: 34.08345, longitude: -118.30729),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Rail"],
            popularity: 92,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Occidental - 23 Stair Rail",
            neighborhood: "4QHR+8C Los Angeles",
            coordinate: CLLocationCoordinate2D(latitude: 34.128265, longitude: -118.20891),
            difficulty: .pro,
            terrainTags: ["23 Stair", "Rail"],
            popularity: 52,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Occidental College - 10 Stair Rail",
            neighborhood: "1600 Campus Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12604, longitude: -118.21204),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 70,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Occidental College - 12 Stair Rail Then 6 Stair",
            neighborhood: "1600 Campus Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12611, longitude: -118.21184),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 88,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Occidental College - Parking Lot Tree Gap",
            neighborhood: "4QGR+58",
            coordinate: CLLocationCoordinate2D(latitude: 34.12527, longitude: -118.20935),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 25,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Occidental College Double Set Rail",
            neighborhood: "Gilman Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.128857, longitude: -118.21109),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Olympic Blvd 26 Stair Rail",
            neighborhood: "10575 W Olympic Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.04874, longitude: -118.42384),
            difficulty: .pro,
            terrainTags: ["26 Stair", "Rail"],
            popularity: 21,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "One California Plaza - Triple Set",
            neighborhood: "300 S Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.052147, longitude: -118.25172),
            difficulty: .beginner,
            terrainTags: ["Plaza"],
            popularity: 100,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oppenheimer Tower - 16 Stair",
            neighborhood: "10880 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.05868, longitude: -118.44347),
            difficulty: .pro,
            terrainTags: ["16 Stair"],
            popularity: 50,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Orange Line Manny Pad / Ledge",
            neighborhood: "16741 Victory Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.186287, longitude: -118.49877),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Manual Pad"],
            popularity: 98,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Our Mother of Good Counsel School - Gap Over Gate",
            neighborhood: "Vermont / Ambrose",
            coordinate: CLLocationCoordinate2D(latitude: 34.10977, longitude: -118.29163),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 26,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Out Ledge Drop Ledge",
            neighborhood: "101 S Hill St",
            coordinate: CLLocationCoordinate2D(latitude: 34.054115, longitude: -118.24712),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 98,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Out Rail",
            neighborhood: "225 N Van Ness Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.075855, longitude: -118.31607),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Overland Ave - 14 Stair Rail",
            neighborhood: "3261 Overland Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.027943, longitude: -118.41422),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 32,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pacific Ave - Manny To Bank",
            neighborhood: "503 W 23rd St",
            coordinate: CLLocationCoordinate2D(latitude: 33.72327, longitude: -118.28815),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 35,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pacoima Wash - Bank To Pole",
            neighborhood: "7736 Kester Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.21129, longitude: -118.45717),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 50,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Palisades Elementary School - 6 Stair Banks",
            neighborhood: "800 Vía De La Paz",
            coordinate: CLLocationCoordinate2D(latitude: 34.044785, longitude: -118.52716),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Bank"],
            popularity: 54,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Palms Elementary School - 9 Stair Hubba",
            neighborhood: "3520 Motor Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.025703, longitude: -118.4072),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Hubba"],
            popularity: 62,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pan Pacific Park - Ledge",
            neighborhood: "189 The Grove Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.07188, longitude: -118.3559),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 23,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Parking Deck - Ledges",
            neighborhood: "777 S Alameda St #280",
            coordinate: CLLocationCoordinate2D(latitude: 34.03353, longitude: -118.24051),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 52,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Parking Deck 15 Stair Rail",
            neighborhood: "20335 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.169403, longitude: -118.5767),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 97,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pasadena Ave - 2 Block Manny / Rail",
            neighborhood: "3413 Pasadena Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.084366, longitude: -118.21347),
            difficulty: .advanced,
            terrainTags: ["Rail", "Manual Pad"],
            popularity: 50,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Paul Revere Charter Middle School Over Rail Into Bank",
            neighborhood: "13316 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.05599, longitude: -118.49541),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 68,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "PCH - 12 Stair",
            neighborhood: "17373 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.03877, longitude: -118.55609),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 55,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Peck Park 4 Block",
            neighborhood: "560 S Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.749382, longitude: -118.30592),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 44,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Peck Park Long 7 Stair Rail",
            neighborhood: "560 S Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.749615, longitude: -118.3066),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 80,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Penmar Park - Brick 3 Stair Out Ledge",
            neighborhood: "1341 Lake St",
            coordinate: CLLocationCoordinate2D(latitude: 34.00662, longitude: -118.45532),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pico Gardens - Curve Ledge",
            neighborhood: "1524 East 4th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04272, longitude: -118.222885),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 11,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pink Motel Pool",
            neighborhood: "9457 San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.24132, longitude: -118.396324),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 26,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pista De Hielo Triple Set Hubba",
            neighborhood: "Hill / 5th",
            coordinate: CLLocationCoordinate2D(latitude: 34.048668, longitude: -118.252174),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 21,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Plasencia 8 Stair Rail",
            neighborhood: "1321 Cortez St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06642, longitude: -118.255646),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Plaza de California - Manny Pad",
            neighborhood: "161 Main St",
            coordinate: CLLocationCoordinate2D(latitude: 34.0515, longitude: -118.24464),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad", "Plaza"],
            popularity: 30,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Poinsettia Recreation Center - 2 Stair Manny Pad",
            neighborhood: "7341 Willoughby Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.087677, longitude: -118.349815),
            difficulty: .intermediate,
            terrainTags: ["2 Stair", "Manual Pad"],
            popularity: 22,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Polka Dot Plaza - 5 Then 7 Stair",
            neighborhood: "1523 Griffith Park Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.090702, longitude: -118.27723),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Plaza"],
            popularity: 43,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Post Office - 5 Stair Rail",
            neighborhood: "17719 Hatteras St",
            coordinate: CLLocationCoordinate2D(latitude: 34.176594, longitude: -118.51908),
            difficulty: .intermediate,
            terrainTags: ["5 Stair", "Rail"],
            popularity: 21,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Prairie St - Skinny Bank To Flat Rail",
            neighborhood: "19756 Prairie St",
            coordinate: CLLocationCoordinate2D(latitude: 34.239056, longitude: -118.564476),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 76,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Public Storage - Bent Handicap Rail",
            neighborhood: "1756 Blake Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.096016, longitude: -118.24247),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 18,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Public Storage Ledge",
            neighborhood: "12510 Raymer St",
            coordinate: CLLocationCoordinate2D(latitude: 34.20246, longitude: -118.405426),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pueblo De Los Angeles High School - Banks",
            neighborhood: "2155 N Soto St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06896, longitude: -118.1964),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 56,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pyrites St - Quarter Pipe",
            neighborhood: "3015 Pyrites St",
            coordinate: CLLocationCoordinate2D(latitude: 34.080822, longitude: -118.19423),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 27,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ralphs - Bump To Street",
            neighborhood: "5446 Quakertown Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.169582, longitude: -118.56974),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 27,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ramon C. Cortines Ledges",
            neighborhood: "450 N Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.058956, longitude: -118.243904),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 74,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ramona Blvd - Andrew Allen Bank",
            neighborhood: "1589 Helen Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.059788, longitude: -118.17227),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 33,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Red Car River Park - Ledge To Dirt Hill Bomb",
            neighborhood: "Red Car River Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.11398, longitude: -118.264694),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 13,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Regent St - 14 Stair Rail",
            neighborhood: "9811 Regent St",
            coordinate: CLLocationCoordinate2D(latitude: 34.02599, longitude: -118.399925),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 36,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Remick Ave - Up Rail",
            neighborhood: "13215 Osborne St",
            coordinate: CLLocationCoordinate2D(latitude: 34.246292, longitude: -118.42131),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Reseda Blvd - Bump To Street",
            neighborhood: "9163 Reseda Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.23712, longitude: -118.53627),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 18,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Reservoir St - Ledge Then 4 Stair",
            neighborhood: "2155 Reservoir St",
            coordinate: CLLocationCoordinate2D(latitude: 34.079826, longitude: -118.2641),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Ledge"],
            popularity: 26,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Reservoir St - Wallie Ledge",
            neighborhood: "2112 Reservoir St",
            coordinate: CLLocationCoordinate2D(latitude: 34.079082, longitude: -118.26297),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Wall"],
            popularity: 46,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Reservoir St Parking Lot - Pole Jam / Banks",
            neighborhood: "1931 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.078377, longitude: -118.26206),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 25,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rick's - Bump To Ledge",
            neighborhood: "2451 Riverside Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.105938, longitude: -118.25586),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 49,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rick's Bump",
            neighborhood: "2400 Fletcher Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.106037, longitude: -118.256004),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 36,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rio de Los Angeles State Park - Gap Over Rail",
            neighborhood: "1900 N San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.099, longitude: -118.2364),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rite Aid - 3 Stair Out Rail",
            neighborhood: "18444 Plummer St",
            coordinate: CLLocationCoordinate2D(latitude: 34.242622, longitude: -118.53533),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Rail"],
            popularity: 55,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rite Aid Ledge",
            neighborhood: "6305 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.115105, longitude: -118.1818),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 77,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Riverpark - Rainbow Ledge",
            neighborhood: "28 2700 Chaucer St",
            coordinate: CLLocationCoordinate2D(latitude: 34.095993, longitude: -118.23467),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 54,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Robert F. Kennedy Elementary School - Ledge To Manny",
            neighborhood: "4010 Ramboz Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.0534, longitude: -118.177635),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Manual Pad"],
            popularity: 57,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Robert F. Kennedy Inspiration Park - Ledges Then 8 Stair",
            neighborhood: "3380 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.061638, longitude: -118.29654),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Ledge"],
            popularity: 41,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ronald Reagan Building - Banks",
            neighborhood: "318 S Spring St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04972, longitude: -118.24722),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 48,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Roosevelt Golf Course - 11 Stair Rail",
            neighborhood: "Vermont Ave. & Commonwealth Canyon Dr.",
            coordinate: CLLocationCoordinate2D(latitude: 34.11887, longitude: -118.29449),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 60,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ross 7 Stair Rail",
            neighborhood: "13720 Riverside Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.15708, longitude: -118.43289),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 39,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rowena Ave - 6 Stair Out Ledge",
            neighborhood: "2900 Hyperion Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.109146, longitude: -118.27082),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Ledge"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rowena Ave - Wood Step Up Ledge",
            neighborhood: "2870 Rowena Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.107838, longitude: -118.26678),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 85,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Royale Liquor - Pole Jam Over Rail",
            neighborhood: "1512 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.075867, longitude: -118.255684),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 10,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Alvarado St - Gap Over Rail",
            neighborhood: "922 S Alvarado St",
            coordinate: CLLocationCoordinate2D(latitude: 34.052483, longitude: -118.27922),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 25,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Anderson St - Street Gap",
            neighborhood: "689 S Anderson St",
            coordinate: CLLocationCoordinate2D(latitude: 34.03498, longitude: -118.22333),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 17,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Avenue 64 - Roof To Wood Rail",
            neighborhood: "126 S Avenue 64",
            coordinate: CLLocationCoordinate2D(latitude: 34.11368, longitude: -118.18174),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 59,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Flower Street - Escalator Ledge",
            neighborhood: "800 W 5th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.051556, longitude: -118.256424),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 26,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Genesee Avenue - Over Rail Into Bank",
            neighborhood: "737 S Genesee Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.061874, longitude: -118.35875),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 48,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Hill St - Bump To Bench",
            neighborhood: "Hill / 3rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.052025, longitude: -118.24895),
            difficulty: .intermediate,
            terrainTags: ["Bench"],
            popularity: 34,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Hope St - Gap Over Rail",
            neighborhood: "407 S Grand Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0515, longitude: -118.252914),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 42,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Hope St - Parking Deck 10 Stair",
            neighborhood: "3426 S Hope St",
            coordinate: CLLocationCoordinate2D(latitude: 34.019833, longitude: -118.27778),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 31,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Hope St - Wallride Ledge",
            neighborhood: "3500 S Hope St",
            coordinate: CLLocationCoordinate2D(latitude: 34.018974, longitude: -118.278755),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Wall"],
            popularity: 78,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Mariposa Ave - Driveway Out To Down Ledge",
            neighborhood: "3805 4th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06745, longitude: -118.299416),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 44,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Meyers St - Bump To Ledge",
            neighborhood: "1137 1st St",
            coordinate: CLLocationCoordinate2D(latitude: 34.048023, longitude: -118.22875),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Normandie Ave - Manny To Ride On Ledge",
            neighborhood: "836 S Normandie Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.056534, longitude: -118.299706),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Manual Pad"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Pecan St - Low To High Ledge",
            neighborhood: "411 S Pecan St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04267, longitude: -118.22179),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 73,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Rampart Blvd - Over Rail To Driveway Bank",
            neighborhood: "411 S Rampart Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.064674, longitude: -118.28028),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Rimpau Blvd - 8 Stair",
            neighborhood: "3rd / Rimpau",
            coordinate: CLLocationCoordinate2D(latitude: 34.068806, longitude: -118.33021),
            difficulty: .intermediate,
            terrainTags: ["8 Stair"],
            popularity: 20,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Santa Fe Ave - Ledges",
            neighborhood: "111 S Santa Fe Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.048027, longitude: -118.23278),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 36,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Sepulveda Blvd - Ledges",
            neighborhood: "2936 S Sepulveda Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.02794, longitude: -118.428856),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 18,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Virgil Ave - 17 Stair Rail",
            neighborhood: "176 S Virgil Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07131, longitude: -118.28661),
            difficulty: .pro,
            terrainTags: ["17 Stair", "Rail"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Western Ave - 5 Stair Gap Over Rock",
            neighborhood: "619 S Western Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.06283, longitude: -118.309296),
            difficulty: .intermediate,
            terrainTags: ["5 Stair", "Gap"],
            popularity: 31,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "S Westgate Ave - 6 Stair Out Rail",
            neighborhood: "1319 S Westgate Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.044937, longitude: -118.46156),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Rail"],
            popularity: 64,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Saint Francis School - 9 Stair Rail",
            neighborhood: "1538 Maltman Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.090458, longitude: -118.276344),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 37,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Saint George St - Bump",
            neighborhood: "3021 St George St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11122, longitude: -118.27306),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 36,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Saint Teresa of Avila - 10 Stair Rail",
            neighborhood: "2023 Glendale Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.092716, longitude: -118.25906),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail"],
            popularity: 80,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Samoa Ave - Wallie To Wood Rail",
            neighborhood: "10121 W Amber Ct",
            coordinate: CLLocationCoordinate2D(latitude: 34.250988, longitude: -118.2873),
            difficulty: .advanced,
            terrainTags: ["Rail", "Wall"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "San Pedro High School - Courtyard Ledge",
            neighborhood: "988 W 17th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.729836, longitude: -118.29875),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 69,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "San Pedro High School 4 Stair Out Ledge",
            neighborhood: "1531 S Leland St",
            coordinate: CLLocationCoordinate2D(latitude: 33.729958, longitude: -118.30085),
            difficulty: .intermediate,
            terrainTags: ["4 Stair", "Ledge"],
            popularity: 74,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "San Pedro St - Flat Rails",
            neighborhood: "3301 San Pedro St",
            coordinate: CLLocationCoordinate2D(latitude: 34.015965, longitude: -118.26479),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 11,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sanborn Ave - 10 Stair Fence Gap",
            neighborhood: "1051 Sanborn Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.091602, longitude: -118.281075),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Gap"],
            popularity: 37,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Saticoy St. - Bank To Ledge",
            neighborhood: "14656 Saticoy St",
            coordinate: CLLocationCoordinate2D(latitude: 34.20833, longitude: -118.45329),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 46,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Scott Ave - 18 Stair Rail",
            neighborhood: "1463 Portia St",
            coordinate: CLLocationCoordinate2D(latitude: 34.078823, longitude: -118.252594),
            difficulty: .pro,
            terrainTags: ["18 Stair", "Rail"],
            popularity: 45,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Scott Ave - Gap Over Rail",
            neighborhood: "1931 Scott Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.08173, longitude: -118.259476),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 37,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sea Dragon - 2 Flat 2 Double Set",
            neighborhood: "101 Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.072613, longitude: -118.292145),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 46,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sears - 9 Stair / Rail",
            neighborhood: "Olympic / Boyle",
            coordinate: CLLocationCoordinate2D(latitude: 34.024815, longitude: -118.22114),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 13,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Seneca Ave - Curb Cut Sidewalk Gap",
            neighborhood: "3907 Seneca Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.124794, longitude: -118.26141),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 50,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Señor De Esquipulas - 3 Stair Ledge To Ledge",
            neighborhood: "11853 Hart St",
            coordinate: CLLocationCoordinate2D(latitude: 34.19766, longitude: -118.391914),
            difficulty: .intermediate,
            terrainTags: ["3 Stair", "Ledge"],
            popularity: 44,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Señor De Esquipulas - Bump To Bar",
            neighborhood: "7000 Radford Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.197765, longitude: -118.39208),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 22,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sepulveda Basin Sports Complex - Ledge",
            neighborhood: "5FMW+CV Los Angeles",
            coordinate: CLLocationCoordinate2D(latitude: 34.183575, longitude: -118.50279),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 89,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sepulveda Blvd - Overpass Banks",
            neighborhood: "1257 Sepulveda Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.147865, longitude: -118.47027),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 29,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sepulveda Blvd Wallride",
            neighborhood: "11430 Thurston Cir",
            coordinate: CLLocationCoordinate2D(latitude: 34.075153, longitude: -118.467766),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 58,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sepulveda Dam",
            neighborhood: "US-101",
            coordinate: CLLocationCoordinate2D(latitude: 34.16716, longitude: -118.47296),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 55,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Shatto Park Recreation Center - Low 9 Stair Rail",
            neighborhood: "Shatto Park Recreation Center & Outdoor Basketball Courts",
            coordinate: CLLocationCoordinate2D(latitude: 34.067814, longitude: -118.289406),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 41,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Shatto Pl - Ride On Ledge",
            neighborhood: "401 Shatto Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.066666, longitude: -118.29015),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sherman Way - Up Rail To Bank",
            neighborhood: "16250 Sherman Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.20135, longitude: -118.48707),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 19,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sherman Way - Vert Wallride",
            neighborhood: "16649 Sherman Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.20128, longitude: -118.4966),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 29,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake - Circle Manny Pad",
            neighborhood: "600-638 N Dillon St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07876, longitude: -118.27888),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 28,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake - Sidewalk Curb",
            neighborhood: "1903 W Silver Lake Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.093075, longitude: -118.26748),
            difficulty: .beginner,
            terrainTags: ["Curb"],
            popularity: 22,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake Blvd - 14 Stair Rail",
            neighborhood: "908 Silver Lake Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.08166, longitude: -118.2735),
            difficulty: .pro,
            terrainTags: ["14 Stair", "Rail"],
            popularity: 47,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake Blvd - Driveway Bump To Gap",
            neighborhood: "2954 Marathon St",
            coordinate: CLLocationCoordinate2D(latitude: 34.080505, longitude: -118.27537),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 23,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake Blvd - Ride On Rail",
            neighborhood: "834 Silver Lake Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.08126, longitude: -118.27417),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 51,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Silver Lake Blvd - Step Up Ledge",
            neighborhood: "2114 Rockford Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.095135, longitude: -118.26217),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 42,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "SIPA Ledge To Rail",
            neighborhood: "3231 W Temple St",
            coordinate: CLLocationCoordinate2D(latitude: 34.075817, longitude: -118.281906),
            difficulty: .advanced,
            terrainTags: ["Rail", "Ledge"],
            popularity: 97,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Solano Ave - Flat Gap Drop Off",
            neighborhood: "492 Solano Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07342, longitude: -118.231285),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 24,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "South Central Avenue - Pop Out Rail",
            neighborhood: "8504 S Central Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.96095, longitude: -118.256256),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 79,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "South Coronado St - Roman Rail To Drop",
            neighborhood: "206 S Coronado St",
            coordinate: CLLocationCoordinate2D(latitude: 34.067757, longitude: -118.27661),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 30,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "South Normandie Ave - Gap Over Rail",
            neighborhood: "531 S Normandie Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.064346, longitude: -118.30052),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 33,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "South Park Empty pool",
            neighborhood: "345 E 51st St",
            coordinate: CLLocationCoordinate2D(latitude: 33.997524, longitude: -118.26738),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 55,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Spaces - Long 12 Stair Rail",
            neighborhood: "1804 Vine St",
            coordinate: CLLocationCoordinate2D(latitude: 34.103924, longitude: -118.32655),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 44,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sparkletts- Curb Cut To Sidewalk Ledge",
            neighborhood: "1448 N Ave 46",
            coordinate: CLLocationCoordinate2D(latitude: 34.122314, longitude: -118.216324),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Curb"],
            popularity: 14,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "St Albans St - Ledge",
            neighborhood: "6720 N Figueroa St",
            coordinate: CLLocationCoordinate2D(latitude: 34.124218, longitude: -118.18544),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "St. Basil's Catholic Church - 11 Stair Rail",
            neighborhood: "3621 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06192, longitude: -118.30301),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 47,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "St. Basil's Catholic Church - 12 Stair",
            neighborhood: "3617 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06188, longitude: -118.30341),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 82,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Stadium Way - 12 Stair Rail",
            neighborhood: "2000 Stadium Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.07592, longitude: -118.24876),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 35,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Stadium Way - Ride On Drop Down Hubba",
            neighborhood: "2000 Stadium Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.075695, longitude: -118.24878),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 46,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Staples Center Hubba/18 Stair",
            neighborhood: "900-986 Chick Hearn Ct",
            coordinate: CLLocationCoordinate2D(latitude: 34.04442, longitude: -118.26909),
            difficulty: .pro,
            terrainTags: ["18 Stair", "Hubba"],
            popularity: 37,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Steve Soboroff Court Park - Ledges",
            neighborhood: "5575 Margaret Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.98282, longitude: -118.40036),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 44,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Stoner Ave - Gap Over Rail",
            neighborhood: "1274 Stoner Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.046925, longitude: -118.46012),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Stratford Rd - Drop In Rail",
            neighborhood: "4870 Stratford Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.123577, longitude: -118.208855),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 34,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Strathmore Dr - 12 Stair Ride On Hubba",
            neighborhood: "11037 Strathmore Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.064606, longitude: -118.45096),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Hubba"],
            popularity: 33,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Strathmore Dr - 15 Stair Hubba",
            neighborhood: "11013 1/2 Strathmore Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.065144, longitude: -118.4509),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Hubba"],
            popularity: 25,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Strathmore Rail",
            neighborhood: "11069 Strathmore Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.0644, longitude: -118.45212),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 58,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunhill Shopping Center - Bump Over Wall Into Bank",
            neighborhood: "8945 Fenwick St",
            coordinate: CLLocationCoordinate2D(latitude: 34.260487, longitude: -118.32772),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Wall"],
            popularity: 12,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunland Blvd - Bump Over Rail",
            neighborhood: "9026 Sunland Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.23298, longitude: -118.36681),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 44,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunland Blvd - Bump To Bike Rack",
            neighborhood: "8431 Sunland Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.223557, longitude: -118.36574),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 29,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunland Blvd - Chain",
            neighborhood: "8356 Sunland Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.223118, longitude: -118.36561),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 11,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunland Recreation Center - 13 Stair Rail To Dirt",
            neighborhood: "Sunland Recreation Center",
            coordinate: CLLocationCoordinate2D(latitude: 34.260357, longitude: -118.32178),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Rail"],
            popularity: 23,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunrise Elementary School - 6 Then 9 Stair",
            neighborhood: "2821 E 7th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.029434, longitude: -118.21023),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 72,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Blvd - 20 Stair Rail",
            neighborhood: "1300 W Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.071316, longitude: -118.250824),
            difficulty: .pro,
            terrainTags: ["20 Stair", "Rail"],
            popularity: 19,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Blvd - 8 Stair",
            neighborhood: "Sunset / Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.07773, longitude: -118.26197),
            difficulty: .intermediate,
            terrainTags: ["8 Stair"],
            popularity: 63,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Blvd - DIY Barrier",
            neighborhood: "2702 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.08116, longitude: -118.27112),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 16,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Blvd - Rail Over Fence",
            neighborhood: "3700 W Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.09042, longitude: -118.27795),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 23,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Blvd - Square Gap",
            neighborhood: "8201 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.09799, longitude: -118.36825),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 36,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Ct - Bump",
            neighborhood: "49 Sunset Ct",
            coordinate: CLLocationCoordinate2D(latitude: 33.993176, longitude: -118.47693),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 50,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Dr - Bump Over Fence",
            neighborhood: "4426 Sunset Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.09806, longitude: -118.286),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 49,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunset Plaza Dr - Quarter Pipe",
            neighborhood: "1674 Sunset Plaza Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.10155, longitude: -118.380104),
            difficulty: .beginner,
            terrainTags: ["Plaza"],
            popularity: 34,
            featuredTrick: "Kickflip Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Super 8 - 7 Stair Out Ledge",
            neighborhood: "1291 Vin Scully Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.07264, longitude: -118.250824),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Ledge"],
            popularity: 41,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Super King Flat Bar",
            neighborhood: "775 S Mission Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.0322, longitude: -118.225426),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 71,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sycamore Grove Park - Sidewalk Gap",
            neighborhood: "115 1/2 S Ave 49",
            coordinate: CLLocationCoordinate2D(latitude: 34.10236, longitude: -118.2028),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 35,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sylmar High School - 9 Stair Rail",
            neighborhood: "13050 Borden Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.307625, longitude: -118.44154),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 77,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tampa Ave - Curb Down Bank",
            neighborhood: "9382 Tampa Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.240818, longitude: -118.55378),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Curb"],
            popularity: 16,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Target - Parking Lot Ledge to Gap",
            neighborhood: "4211 Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.122208, longitude: -118.22511),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tarzana Recreation Center - 6 Stair Gap To Ledge",
            neighborhood: "5655 Vanalden Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.174335, longitude: -118.550835),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Ledge", "Gap"],
            popularity: 72,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tattoo Love - Bump To Bike Rack",
            neighborhood: "4871 N Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.134594, longitude: -118.21558),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 23,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Temple Heights Church - 20 Stair Rail",
            neighborhood: "888 W Hamilton Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.72075, longitude: -118.29654),
            difficulty: .pro,
            terrainTags: ["20 Stair", "Rail"],
            popularity: 19,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Thai Coconut - Ledge To Wallride",
            neighborhood: "1801 Colorado Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.13965, longitude: -118.206184),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Wall"],
            popularity: 28,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Bluffs - 10 Stair",
            neighborhood: "12181 Bluff Creek Dr Unit A",
            coordinate: CLLocationCoordinate2D(latitude: 33.979443, longitude: -118.40515),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 57,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Equitable Building - 8 Stair Gap Over Rail",
            neighborhood: "641 S Alexandria Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.061962, longitude: -118.29812),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail", "Gap"],
            popularity: 39,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Equitable Building - 9 Stair Rail",
            neighborhood: "3437 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.061886, longitude: -118.2986),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Greek Theater Long 12 Stair Rail",
            neighborhood: "2700 N Vermont Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.120426, longitude: -118.29644),
            difficulty: .advanced,
            terrainTags: ["12 Stair", "Rail"],
            popularity: 62,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Home Depot - Bump To Gap",
            neighborhood: "905 N San Fernando Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.084225, longitude: -118.225845),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 36,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Trails - Wood Rail",
            neighborhood: "2333 Fern Dell Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.113976, longitude: -118.30759),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 86,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Thomas Starr King Middle School - 10 Stair Rail / Out Ledge",
            neighborhood: "4218 Bates Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.095924, longitude: -118.28141),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail", "Ledge"],
            popularity: 88,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Thomas Starr King Middle School - Ledge To Ledge",
            neighborhood: "4049 1/2 Sunset Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.098072, longitude: -118.28038),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 76,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tipton Way - Fence To Hill Bomb",
            neighborhood: "5800 Tipton Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.12952, longitude: -118.19216),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 21,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tokyo Banks",
            neighborhood: "204 E 1st St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05112, longitude: -118.24234),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Toland Way Elementary - Over Rail Into Bank",
            neighborhood: "4545 Toland Way",
            coordinate: CLLocationCoordinate2D(latitude: 34.121494, longitude: -118.21737),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Topanga Canyon Blvd - Flat Rail",
            neighborhood: "5807 CA-27",
            coordinate: CLLocationCoordinate2D(latitude: 34.175484, longitude: -118.6059),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Troost Ave - Bank To Ledge",
            neighborhood: "6514 Troost Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.189003, longitude: -118.38656),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tujunga Methodist Church - Bump To Curve Rail",
            neighborhood: "9901 Tujunga Canyon Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.247913, longitude: -118.27721),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 50,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tularosa Dr - Gap Over Rail Into Bank",
            neighborhood: "941 Tularosa Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.085175, longitude: -118.27903),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap", "Bank"],
            popularity: 57,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tuxford St - Bank / Gap To Street",
            neighborhood: "8698 S San Fernando Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.227848, longitude: -118.380745),
            difficulty: .advanced,
            terrainTags: ["Gap", "Bank"],
            popularity: 48,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Tuxford St - Curb Cut Bump Over Hydrant",
            neighborhood: "11066 Tuxford St",
            coordinate: CLLocationCoordinate2D(latitude: 34.233658, longitude: -118.37235),
            difficulty: .intermediate,
            terrainTags: ["Curb"],
            popularity: 19,
            featuredTrick: "Smith Grind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ubatuba - Bump To Bar",
            neighborhood: "18705 Ventura Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.17064, longitude: -118.539665),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 100,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - 15 Stair Rail",
            neighborhood: "555 Westwood Plaza level b",
            coordinate: CLLocationCoordinate2D(latitude: 34.06797, longitude: -118.44523),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - 2 Block",
            neighborhood: "221 Westwood Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 34.07114, longitude: -118.44462),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 48,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - 2 Flat 6 Double Set Rail",
            neighborhood: "445 Charles E Young Dr E",
            coordinate: CLLocationCoordinate2D(latitude: 34.070477, longitude: -118.4405),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 26,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - 4 Then 5 Stair",
            neighborhood: "Knudsen Hall",
            coordinate: CLLocationCoordinate2D(latitude: 34.070133, longitude: -118.441),
            difficulty: .intermediate,
            terrainTags: ["5 Stair"],
            popularity: 49,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Bench Manny Pads",
            neighborhood: "6 Bruin Walk",
            coordinate: CLLocationCoordinate2D(latitude: 34.070866, longitude: -118.4449),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad", "Bench"],
            popularity: 25,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Brick 6 Stair Hubbas",
            neighborhood: "3HF5+3W Los Angeles",
            coordinate: CLLocationCoordinate2D(latitude: 34.07267, longitude: -118.44022),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Hubba"],
            popularity: 60,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Long 7 Stair Rail",
            neighborhood: "2191 franz hall",
            coordinate: CLLocationCoordinate2D(latitude: 34.069427, longitude: -118.44192),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Rail"],
            popularity: 55,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Low Flat Rails",
            neighborhood: "445 Charles E Young Dr E",
            coordinate: CLLocationCoordinate2D(latitude: 34.07009, longitude: -118.44006),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 50,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Low To High Ledge",
            neighborhood: "1317 Portola Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 34.073494, longitude: -118.44067),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Murphy Hall 5 Stair Out Ledge",
            neighborhood: "2211 Murphy Hall",
            coordinate: CLLocationCoordinate2D(latitude: 34.07188, longitude: -118.43853),
            difficulty: .intermediate,
            terrainTags: ["5 Stair", "Ledge"],
            popularity: 43,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Murphy Hall Manny Pad",
            neighborhood: "410 Charles E Young Dr E",
            coordinate: CLLocationCoordinate2D(latitude: 34.071922, longitude: -118.43841),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 38,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Neuroscience Ledge",
            neighborhood: "Wasserman Building",
            coordinate: CLLocationCoordinate2D(latitude: 34.065464, longitude: -118.44433),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Portola Plaza 21 Stair Kink Rail",
            neighborhood: "415 Portola Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 34.07152, longitude: -118.44097),
            difficulty: .pro,
            terrainTags: ["21 Stair", "Rail", "Plaza"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA - Skinny Gap",
            neighborhood: "3HC5+WW Los Angeles",
            coordinate: CLLocationCoordinate2D(latitude: 34.072304, longitude: -118.44022),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 38,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "UCLA Academic Counseling Building - Ledge",
            neighborhood: "410 Charles E Young Dr E",
            coordinate: CLLocationCoordinate2D(latitude: 34.07141, longitude: -118.43826),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 54,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Union Pacific Ave - Up Rail",
            neighborhood: "3541 Union Pacific Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.016712, longitude: -118.20154),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 46,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "University High School 15 Stair Rail",
            neighborhood: "11800 Texas Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.04589, longitude: -118.46023),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 87,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "University High School 8 Stair Rail",
            neighborhood: "11800 Texas Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.046005, longitude: -118.46044),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 71,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Up Rail",
            neighborhood: "5867 W 3rd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06974, longitude: -118.34808),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 82,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - 15 Stair Wood Rail",
            neighborhood: "1333 San Pablo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.060593, longitude: -118.20479),
            difficulty: .pro,
            terrainTags: ["15 Stair", "Rail"],
            popularity: 20,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - Bing Theatre 9 Stair Rail",
            neighborhood: "Queens Courtyard",
            coordinate: CLLocationCoordinate2D(latitude: 34.022324, longitude: -118.28576),
            difficulty: .intermediate,
            terrainTags: ["9 Stair", "Rail"],
            popularity: 12,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - Gap To Wallride",
            neighborhood: "850 Bloom Walk",
            coordinate: CLLocationCoordinate2D(latitude: 34.01933, longitude: -118.28777),
            difficulty: .advanced,
            terrainTags: ["Gap", "Wall"],
            popularity: 93,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - Pappas Quad Ledges",
            neighborhood: "2003 Zonal Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.060703, longitude: -118.205),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 23,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - Pappas Quad Out Ledge",
            neighborhood: "1969 Zonal Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.060616, longitude: -118.20532),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 57,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - Planter Ledge",
            neighborhood: "Jefferson / Hoover",
            coordinate: CLLocationCoordinate2D(latitude: 34.02315, longitude: -118.28325),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 26,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - The Music Complex 6 Flat 6 Double Set",
            neighborhood: "John Williams Scoring Stage",
            coordinate: CLLocationCoordinate2D(latitude: 34.022934, longitude: -118.28598),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 100,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC - University Ave Ledges",
            neighborhood: "3390 S Hoover St",
            coordinate: CLLocationCoordinate2D(latitude: 34.02389, longitude: -118.28367),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 43,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USC 6 Stair Rail",
            neighborhood: "1539 Alcazar St",
            coordinate: CLLocationCoordinate2D(latitude: 34.063244, longitude: -118.20442),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Rail"],
            popularity: 46,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USPS - 3 Flat 7 Double Set Rail",
            neighborhood: "6900 S Central Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.977478, longitude: -118.2567),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 81,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USPS - Loading Dock Rail",
            neighborhood: "7251 Gloria Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.202145, longitude: -118.478485),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 76,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Valley Vista - Flat Rail",
            neighborhood: "2580 N Soto St",
            coordinate: CLLocationCoordinate2D(latitude: 34.077686, longitude: -118.19333),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 59,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Valleyheart Dr - Manny To Bank",
            neighborhood: "13144 Valleyheart Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.147938, longitude: -118.41972),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Manual Pad"],
            popularity: 14,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Valleyheart Dr - Out Ledge",
            neighborhood: "12153 Valleyheart Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.1452, longitude: -118.3972),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Valleyheart Drive - 10 stair Hubba",
            neighborhood: "12123 Valleyheart Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.145714, longitude: -118.39674),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Hubba"],
            popularity: 56,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys Courthouse - Ledges",
            neighborhood: "6262 Van Nuys Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.184006, longitude: -118.44743),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 34,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys Courthouse - Over Can",
            neighborhood: "6230 Sylmar Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.18361, longitude: -118.44668),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 18,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys High School - Curve Ledge",
            neighborhood: "14656 Haynes St",
            coordinate: CLLocationCoordinate2D(latitude: 34.189613, longitude: -118.45322),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 82,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys High School - Manny Pad",
            neighborhood: "6539 Cedros Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.18979, longitude: -118.45442),
            difficulty: .intermediate,
            terrainTags: ["Manual Pad"],
            popularity: 56,
            featuredTrick: "Nollie Heelflip Manual"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys Library - Bump To Bench",
            neighborhood: "6250 Sylmar Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.183743, longitude: -118.446434),
            difficulty: .intermediate,
            terrainTags: ["Bench"],
            popularity: 100,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Van Nuys Recreation Center - Ledges",
            neighborhood: "6813 Tyrone Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.19435, longitude: -118.44464),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 43,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Vanowen Bump To Street Gap",
            neighborhood: "12755 Vanowen St",
            coordinate: CLLocationCoordinate2D(latitude: 34.19405, longitude: -118.411606),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 24,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Vanowen St - 6 Stair / Wallie",
            neighborhood: "21519 Vanowen St",
            coordinate: CLLocationCoordinate2D(latitude: 34.19391, longitude: -118.59962),
            difficulty: .intermediate,
            terrainTags: ["6 Stair", "Wall"],
            popularity: 100,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Variel Ave - 7 Stair Drop Down Out Ledge",
            neighborhood: "6333 Variel Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.18499, longitude: -118.59263),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Ledge"],
            popularity: 53,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Venice High School - Step Up Ledge",
            neighborhood: "13000 Venice Blvd.",
            coordinate: CLLocationCoordinate2D(latitude: 33.996983, longitude: -118.44455),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 100,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Verdugo Church - Pop Out Curve Ledge",
            neighborhood: "4300 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12947, longitude: -118.23248),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 91,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Verdugo Hills High School - Over Rail To Bank",
            neighborhood: "10625 Plainview Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.260975, longitude: -118.29909),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 70,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Verdugo Rd - 3 Flat 2 Then 3 Flat 4 Double Set",
            neighborhood: "4157 1/2 Verdugo Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.1266, longitude: -118.232376),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 58,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Vermont/Santa Monica Metro - Wallride To Drop",
            neighborhood: "Vermont / Santa Monica",
            coordinate: CLLocationCoordinate2D(latitude: 34.090496, longitude: -118.292076),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 60,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Victory Blvd - Dentist Handicap Rail",
            neighborhood: "11749 Victory Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.186813, longitude: -118.38966),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 46,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Victory Blvd - LA River Bank To Wallride",
            neighborhood: "18206 Victory Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.186802, longitude: -118.52969),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Wall"],
            popularity: 27,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Victory Blvd - Short 11 Stair Hubba",
            neighborhood: "22357 Victory Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.186623, longitude: -118.61377),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Hubba"],
            popularity: 41,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Vignes St - Bank To Ledge",
            neighborhood: "1017 N Vignes St",
            coordinate: CLLocationCoordinate2D(latitude: 34.059055, longitude: -118.23278),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 50,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Virgil Ave - Wallride / Ledge",
            neighborhood: "857 Virgil Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.087025, longitude: -118.28712),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Wall"],
            popularity: 31,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "W 25th St - Gap To Street",
            neighborhood: "841 W 25th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.72147, longitude: -118.295555),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 25,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "W 3rd Street - Tree Wallie",
            neighborhood: "2511 W 3rd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.065205, longitude: -118.276955),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 16,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "W 8th St - Bump To Electrical Box",
            neighborhood: "5467 W 8th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06056, longitude: -118.348404),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 13,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "W 9th St - Bank Over Rail",
            neighborhood: "2836 James M Wood Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.055824, longitude: -118.290184),
            difficulty: .advanced,
            terrainTags: ["Rail", "Bank"],
            popularity: 43,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "W Elmyra St - Bump To Ledge",
            neighborhood: "114 W Elmyra St",
            coordinate: CLLocationCoordinate2D(latitude: 34.064842, longitude: -118.23253),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 29,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "W Manchester Ave - Bump To Rail",
            neighborhood: "1261 W Manchester Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.960163, longitude: -118.29791),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 93,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "W Temple St - 7 Stair Gap To Out Ledge",
            neighborhood: "Temple / Beaudry",
            coordinate: CLLocationCoordinate2D(latitude: 34.06269, longitude: -118.25114),
            difficulty: .intermediate,
            terrainTags: ["7 Stair", "Ledge", "Gap"],
            popularity: 22,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wabash 8 Stair Rails",
            neighborhood: "2765 Wabash Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.05076, longitude: -118.19829),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Rail"],
            popularity: 18,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wall Ride",
            neighborhood: "6462-6580 W Manchester Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.95972, longitude: -118.40361),
            difficulty: .beginner,
            terrainTags: ["Wall"],
            popularity: 19,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Warner Center Banks",
            neighborhood: "21011 Warner Center Ln",
            coordinate: CLLocationCoordinate2D(latitude: 34.175613, longitude: -118.590416),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 80,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Washington Irvine Middle School 13 Stair Hubba",
            neighborhood: "3303 Marguerite St",
            coordinate: CLLocationCoordinate2D(latitude: 34.11657, longitude: -118.24047),
            difficulty: .advanced,
            terrainTags: ["13 Stair", "Hubba"],
            popularity: 75,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Washington Irving Middle School - Handicap Rail",
            neighborhood: "3010 Estara Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.116577, longitude: -118.240814),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 81,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Washington Irving Middle School - Mini Hubbas",
            neighborhood: "3330 Marguerite St",
            coordinate: CLLocationCoordinate2D(latitude: 34.116653, longitude: -118.24),
            difficulty: .intermediate,
            terrainTags: ["Hubba"],
            popularity: 100,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Washington Preparatory High School Blue Banks",
            neighborhood: "108th St & Denker Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.937935, longitude: -118.30441),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 65,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Water And Power - 10 Stair Ride On Out Ledge",
            neighborhood: "225 N Ave 61",
            coordinate: CLLocationCoordinate2D(latitude: 34.11391, longitude: -118.18969),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Ledge"],
            popularity: 42,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Water and Power - Low To High Ledge",
            neighborhood: "225 N Ave 61",
            coordinate: CLLocationCoordinate2D(latitude: 34.114017, longitude: -118.18973),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Waterloo St - Bump To Ledge",
            neighborhood: "1205 Waterloo St",
            coordinate: CLLocationCoordinate2D(latitude: 34.07964, longitude: -118.266396),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 41,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Waterloo St - Sidewalk Gap",
            neighborhood: "2229 Montana St",
            coordinate: CLLocationCoordinate2D(latitude: 34.08201, longitude: -118.26479),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 42,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "West 11th St - Metal Ledge",
            neighborhood: "419 W 11th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04218, longitude: -118.26226),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 10,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "West 35th St - Bump Over Pole",
            neighborhood: "3400 S Hope St",
            coordinate: CLLocationCoordinate2D(latitude: 34.01909, longitude: -118.277916),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 40,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "West 3rd St - 10 Stair With Gate",
            neighborhood: "2354 W 3rd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.064594, longitude: -118.27611),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 29,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "West 5th St - Bank",
            neighborhood: "1620 W 5th St",
            coordinate: CLLocationCoordinate2D(latitude: 34.05839, longitude: -118.268654),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 27,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "West LA Courthouse",
            neighborhood: "4261010908",
            coordinate: CLLocationCoordinate2D(latitude: 34.045338, longitude: -118.44987),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 62,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westchester High School 11 Stair Rail",
            neighborhood: "7602 W Manchester Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.958073, longitude: -118.43021),
            difficulty: .advanced,
            terrainTags: ["11 Stair", "Rail"],
            popularity: 100,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westchester Pool - Kinked Ledge",
            neighborhood: "9100 Lincoln Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.957603, longitude: -118.41681),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Kink Rail"],
            popularity: 50,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westchester Pool - Ledge",
            neighborhood: "9100 Lincoln Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 33.957848, longitude: -118.41628),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 38,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Western & 1st - Ledge Over Cylinder",
            neighborhood: "125 N Western Ave #104",
            coordinate: CLLocationCoordinate2D(latitude: 34.074017, longitude: -118.30925),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 24,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westfield - 10 Stair",
            neighborhood: "1855 Ave of the Stars",
            coordinate: CLLocationCoordinate2D(latitude: 34.060085, longitude: -118.41791),
            difficulty: .advanced,
            terrainTags: ["10 Stair"],
            popularity: 34,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westlake / MacAurthur Park - 9 Stair",
            neighborhood: "Westlake / MacArthur Park",
            coordinate: CLLocationCoordinate2D(latitude: 34.056973, longitude: -118.27581),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 47,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Westwood United Methodist Church - 9 Stair",
            neighborhood: "10497 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.064865, longitude: -118.43194),
            difficulty: .intermediate,
            terrainTags: ["9 Stair"],
            popularity: 50,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "White Oak Ave - Bank To Ledge",
            neighborhood: "5530 White Oak Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.171494, longitude: -118.518684),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 35,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Whiteside St - Bank To Wallride",
            neighborhood: "3222 Whiteside St",
            coordinate: CLLocationCoordinate2D(latitude: 34.056366, longitude: -118.1919),
            difficulty: .intermediate,
            terrainTags: ["Bank", "Wall"],
            popularity: 30,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Will & Ariel Durant Branch Library - Hip",
            neighborhood: "7136 Sunset Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.0978, longitude: -118.34535),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 23,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Willow Brook Ave - Bump over hydrant",
            neighborhood: "4348 Willow Brook Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.08968, longitude: -118.28601),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 50,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wilmington Waterfront Promenade - 4 Block",
            neighborhood: "Wilmington Waterfront Promenade",
            coordinate: CLLocationCoordinate2D(latitude: 33.76644, longitude: -118.261765),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 37,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wilshire Blvd - 12 Stair Over Gate",
            neighborhood: "10535 Wilshire Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.06376, longitude: -118.432686),
            difficulty: .advanced,
            terrainTags: ["12 Stair"],
            popularity: 46,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wilshire Blvd - Bump To Ledge",
            neighborhood: "Wilshire / Bundy",
            coordinate: CLLocationCoordinate2D(latitude: 34.04407, longitude: -118.46777),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Winchell's - Pop Over Ledge",
            neighborhood: "Pacific Coast Hwy + Neptune Av",
            coordinate: CLLocationCoordinate2D(latitude: 33.790703, longitude: -118.26941),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Winter St - Gap To Street",
            neighborhood: "3040 Winter St",
            coordinate: CLLocationCoordinate2D(latitude: 34.04674, longitude: -118.19658),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 98,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wonderland Avenue Elementary School 10 Stair Gap Over Rail",
            neighborhood: "8510 Wonderland Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.11416, longitude: -118.37971),
            difficulty: .advanced,
            terrainTags: ["10 Stair", "Rail", "Gap"],
            popularity: 79,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wright Middle School - Corner Ledge",
            neighborhood: "8001 Cowan Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.969074, longitude: -118.403046),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 50,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wright Middle School - Curved Flat Rail",
            neighborhood: "7925 Beland Ave",
            coordinate: CLLocationCoordinate2D(latitude: 33.969223, longitude: -118.40418),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 77,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wright Middle School - Roof Gap Over Railing / Gap To Dumpster",
            neighborhood: "6550 W 80th St",
            coordinate: CLLocationCoordinate2D(latitude: 33.96799, longitude: -118.40306),
            difficulty: .advanced,
            terrainTags: ["Rail", "Gap"],
            popularity: 52,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Writers Guild - Bump To Bar",
            neighborhood: "7910 W 3rd St",
            coordinate: CLLocationCoordinate2D(latitude: 34.071247, longitude: -118.361916),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 42,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "WTC Parking Deck - Street Gap",
            neighborhood: "360 Flower St",
            coordinate: CLLocationCoordinate2D(latitude: 34.053024, longitude: -118.254425),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 33,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yale Street Ledge",
            neighborhood: "716 Yale St",
            coordinate: CLLocationCoordinate2D(latitude: 34.06167, longitude: -118.24145),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 40,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "York Blvd - 8 Stair Fence Gap",
            neighborhood: "5633 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.11935, longitude: -118.1955),
            difficulty: .intermediate,
            terrainTags: ["8 Stair", "Gap"],
            popularity: 25,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "York Blvd - Bank",
            neighborhood: "4371 N Eagle Rock Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.12428, longitude: -118.2213),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 55,
            featuredTrick: "Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "York Blvd - Drop Down Ledge",
            neighborhood: "4701 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.122902, longitude: -118.21354),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 45,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "York Blvd - Gap To Curb",
            neighborhood: "6095 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.117565, longitude: -118.18613),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 40,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "York Blvd - Sidewalk Ledge Gap To Tree",
            neighborhood: "4919 1/2 York Blvd",
            coordinate: CLLocationCoordinate2D(latitude: 34.121796, longitude: -118.2082),
            difficulty: .advanced,
            terrainTags: ["Ledge", "Gap"],
            popularity: 47,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yosemite Dr - Bump To Ledge",
            neighborhood: "2156 Yosemite Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.13494, longitude: -118.21485),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 31,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yosemite Dr - Gap To Curb",
            neighborhood: "4753 Townsend Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.13287, longitude: -118.20196),
            difficulty: .advanced,
            terrainTags: ["Gap", "Curb"],
            popularity: 24,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yosemite Recreation Center - Down Rail",
            neighborhood: "1840 Yosemite Dr",
            coordinate: CLLocationCoordinate2D(latitude: 34.13327, longitude: -118.207726),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 72,
            featuredTrick: "Frontside Boardslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Young Oak Kim Academy - Bump Over Chain",
            neighborhood: "615 Shatto Pl",
            coordinate: CLLocationCoordinate2D(latitude: 34.06357, longitude: -118.29032),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 31,
            featuredTrick: "Tre Flip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Zapata Statue - Ledges",
            neighborhood: "2018 N Mission Rd",
            coordinate: CLLocationCoordinate2D(latitude: 34.065304, longitude: -118.20724),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 18,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Zelzah - Bank Ledge",
            neighborhood: "17839 Romar St",
            coordinate: CLLocationCoordinate2D(latitude: 34.25514, longitude: -118.52355),
            difficulty: .intermediate,
            terrainTags: ["Ledge", "Bank"],
            popularity: 48,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Zonal Ave - Corner Ledge",
            neighborhood: "210 Zonal Ave",
            coordinate: CLLocationCoordinate2D(latitude: 34.0594, longitude: -118.20481),
            difficulty: .intermediate,
            terrainTags: ["Ledge"],
            popularity: 22,
            featuredTrick: "Noseslide"
        ),
    ]
}