import Foundation
import CoreLocation

// MARK: - Real Bay Area Skate Spots (SF + Oakland)
// Source: findskatespots.com — accurate GPS coordinates

extension SKMockData {

    static let realSpots: [SkateSpot] = [
        SkateSpot(
            id: UUID(),
            name: "Alameda County Courthouse -10 Stair / Ledges",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.79989, longitude: -122.262436),
            difficulty: .advanced,
            terrainTags: ["10-Stair", "Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Alice Street Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.794437, longitude: -122.27132),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Boating Center Benches",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80509, longitude: -122.25726),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Boden Way - 10 Stair Hubba",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.807785, longitude: -122.248375),
            difficulty: .advanced,
            terrainTags: ["10-Stair", "Hubba"],
            popularity: 55,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Broadway - 10 Stair Rail",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.82786, longitude: -122.2563),
            difficulty: .advanced,
            terrainTags: ["10-Stair", "Rail"],
            popularity: 21,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Broadway - Down Ledge",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.827824, longitude: -122.2563),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 39,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Broadway Ledge",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.808186, longitude: -122.26861),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bushrod 4 Flat 4",
            neighborhood: "North Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.845417, longitude: -122.265045),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 57,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "City Center - 4 Flat 5 Double Set",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.803787, longitude: -122.27195),
            difficulty: .intermediate,
            terrainTags: ["Double Set"],
            popularity: 15,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cleveland Elementary School - Ride on Ledge",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.804333, longitude: -122.24402),
            difficulty: .pro,
            terrainTags: ["Ledge"],
            popularity: 51,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cleveland Elementary School 10 Stair Rail",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.8036, longitude: -122.24398),
            difficulty: .advanced,
            terrainTags: ["10-Stair", "Rail"],
            popularity: 21,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cleveland Elementary School 12 Stair / Rail",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80379, longitude: -122.243866),
            difficulty: .pro,
            terrainTags: ["12-Stair", "Rail"],
            popularity: 69,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Concrete Ribbons",
            neighborhood: "Uptown",
            coordinate: CLLocationCoordinate2D(latitude: 37.816, longitude: -122.26417),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Convention Center DIY Planter Bump",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.797897, longitude: -122.260956),
            difficulty: .beginner,
            terrainTags: ["Bump", "DIY"],
            popularity: 25,
            featuredTrick: "Ollie Over"
        ),
        SkateSpot(
            id: UUID(),
            name: "Down Ledge",
            neighborhood: "Uptown",
            coordinate: CLLocationCoordinate2D(latitude: 37.816826, longitude: -122.25005),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fairyland Rail",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.809628, longitude: -122.259636),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 25,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Franklin St - Bump To Ledge / Manny",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80852, longitude: -122.26722),
            difficulty: .beginner,
            terrainTags: ["Ledge", "Manual", "Bump"],
            popularity: 21,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fremont High School - 11 Stair Rail",
            neighborhood: "East Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.774097, longitude: -122.20921),
            difficulty: .advanced,
            terrainTags: ["11-Stair", "Rail"],
            popularity: 75,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Gap Over Rail To Double Bank",
            neighborhood: "Uptown",
            coordinate: CLLocationCoordinate2D(latitude: 37.810966, longitude: -122.246124),
            difficulty: .pro,
            terrainTags: ["Rail", "Gap", "Bank"],
            popularity: 21,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Jack London Square - Flagpole Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.7944, longitude: -122.27715),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 31,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lake Merritt Bart 6 Stair Out Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.797295, longitude: -122.26488),
            difficulty: .intermediate,
            terrainTags: ["6-Stair", "Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lake Merritt Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.798218, longitude: -122.26119),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laney College - Art Center Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.796043, longitude: -122.261116),
            difficulty: .pro,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laney College - Curve Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.796043, longitude: -122.26114),
            difficulty: .advanced,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laney College - Down And Out Rail",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.795967, longitude: -122.26318),
            difficulty: .pro,
            terrainTags: ["Rail"],
            popularity: 15,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Laney College - Ride On Ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.79683, longitude: -122.26124),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Madison Park - Alligator Bank",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.797855, longitude: -122.26695),
            difficulty: .beginner,
            terrainTags: ["Bank"],
            popularity: 31,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Madison Park Ledges",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.798016, longitude: -122.26707),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Marble Benches",
            neighborhood: "Uptown",
            coordinate: CLLocationCoordinate2D(latitude: 37.81051, longitude: -122.264305),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mathematica Sculpture",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80491, longitude: -122.27285),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "McElroy Fountain Ledges",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.808044, longitude: -122.25716),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 31,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Merritt Banks",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.797935, longitude: -122.25515),
            difficulty: .beginner,
            terrainTags: ["Bank"],
            popularity: 15,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Metal ledge",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.79613, longitude: -122.27189),
            difficulty: .advanced,
            terrainTags: ["Ledge"],
            popularity: 21,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oak Street Out Ledge",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80001, longitude: -122.263725),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 25,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakland High School - Loading Dock Hubba",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.805058, longitude: -122.236275),
            difficulty: .pro,
            terrainTags: ["Hubba"],
            popularity: 15,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakland High School - Planter Bowl",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.804874, longitude: -122.235756),
            difficulty: .beginner,
            terrainTags: ["Bowl"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakland High School Blue Blocks",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80417, longitude: -122.235985),
            difficulty: .pro,
            terrainTags: ["Street"],
            popularity: 15,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakland High School Curved Ledge",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.8044, longitude: -122.235985),
            difficulty: .pro,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Oakland High School Step Up Ledge",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.80458, longitude: -122.23629),
            difficulty: .pro,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rockridge Bart - Parking Lot Small Flat Bars",
            neighborhood: "North Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.84455, longitude: -122.250916),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 25,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rockridge Bart Bank",
            neighborhood: "North Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.84466, longitude: -122.25201),
            difficulty: .beginner,
            terrainTags: ["Bank"],
            popularity: 99,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sankofa Academy Flat Rails",
            neighborhood: "North Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.846798, longitude: -122.264626),
            difficulty: .pro,
            terrainTags: ["Rail"],
            popularity: 33,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sankofa United Elementary School - Drop In Ride On Rail",
            neighborhood: "North Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.84704, longitude: -122.26489),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 15,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Santa Fe Elementary Planter Ledges",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.837902, longitude: -122.27467),
            difficulty: .pro,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Santa Fe Elementary Yellow Benches",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.837746, longitude: -122.27424),
            difficulty: .pro,
            terrainTags: ["Street"],
            popularity: 21,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Southern Cuisine - Flat Rail",
            neighborhood: "Lake Merritt",
            coordinate: CLLocationCoordinate2D(latitude: 37.801067, longitude: -122.21846),
            difficulty: .pro,
            terrainTags: ["Rail"],
            popularity: 21,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Thornhill Elementary School - Flat Rail",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.836426, longitude: -122.211334),
            difficulty: .advanced,
            terrainTags: ["Rail"],
            popularity: 15,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "USPS - 8 Stair Rail",
            neighborhood: "Rockridge",
            coordinate: CLLocationCoordinate2D(latitude: 37.83658, longitude: -122.2639),
            difficulty: .advanced,
            terrainTags: ["8-Stair", "Rail"],
            popularity: 15,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Waterfront Rail",
            neighborhood: "Downtown Oakland",
            coordinate: CLLocationCoordinate2D(latitude: 37.7944, longitude: -122.2776),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 37,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wave Ledges",
            neighborhood: "Uptown",
            coordinate: CLLocationCoordinate2D(latitude: 37.810562, longitude: -122.291954),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 15,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "3rd and Army",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.74805, longitude: -122.389755),
            difficulty: .advanced,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Clipper 12 Stair Hubba",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.7492, longitude: -122.43277),
            difficulty: .pro,
            terrainTags: ["12-Stair", "Hubba"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Pier 7 Manny Pads",
            neighborhood: "Financial District",
            coordinate: CLLocationCoordinate2D(latitude: 37.798763, longitude: -122.396774),
            difficulty: .advanced,
            terrainTags: ["Manual"],
            popularity: 99,
            featuredTrick: "Kickflip Nose Manny"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mission St - 3 Up 3 Down",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.767918, longitude: -122.42015),
            difficulty: .advanced,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Union Square Plaza",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.788002, longitude: -122.407555),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fort Miley",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.783222, longitude: -122.50877),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kezar Rail",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.766148, longitude: -122.45468),
            difficulty: .pro,
            terrainTags: ["Rail"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Powell Station Wall Rails",
            neighborhood: "Tenderloin",
            coordinate: CLLocationCoordinate2D(latitude: 37.78426, longitude: -122.408165),
            difficulty: .beginner,
            terrainTags: ["Rail", "Wallride"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Federal Banks",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.78143, longitude: -122.41844),
            difficulty: .pro,
            terrainTags: ["Bank"],
            popularity: 99,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bump To Barrier",
            neighborhood: "San Francisco",
            coordinate: CLLocationCoordinate2D(latitude: 37.72633, longitude: -122.380615),
            difficulty: .advanced,
            terrainTags: ["Bump"],
            popularity: 99,
            featuredTrick: "Ollie Over"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lincoln High School 3 Block",
            neighborhood: "West Portal",
            coordinate: CLLocationCoordinate2D(latitude: 37.74708, longitude: -122.48067),
            difficulty: .pro,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bay Blocks Ledge",
            neighborhood: "North Beach",
            coordinate: CLLocationCoordinate2D(latitude: 37.801838, longitude: -122.39967),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wallenberg 4",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.78011, longitude: -122.44668),
            difficulty: .advanced,
            terrainTags: ["Wallride"],
            popularity: 99,
            featuredTrick: "Frontside Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Low to High Ledge",
            neighborhood: "West Portal",
            coordinate: CLLocationCoordinate2D(latitude: 37.74524, longitude: -122.47919),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Monument Ledge",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.779823, longitude: -122.41502),
            difficulty: .advanced,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "North Beach Double Set",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.79916, longitude: -122.40532),
            difficulty: .beginner,
            terrainTags: ["Double Set"],
            popularity: 99,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Black Rock",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.792416, longitude: -122.40408),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cardiel Hubba",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.79237, longitude: -122.40556),
            difficulty: .beginner,
            terrainTags: ["Hubba"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cement Rails",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.77676, longitude: -122.417595),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Alabama Bump",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.744244, longitude: -122.41027),
            difficulty: .beginner,
            terrainTags: ["Bump"],
            popularity: 99,
            featuredTrick: "Ollie Over"
        ),
        SkateSpot(
            id: UUID(),
            name: "Willie L. Brown Middle School 4 Block",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.736393, longitude: -122.400024),
            difficulty: .advanced,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Grattan Elementary Big 5",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.76313, longitude: -122.450264),
            difficulty: .pro,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Balboa Rail",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.775402, longitude: -122.509155),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fort Mason",
            neighborhood: "North Beach",
            coordinate: CLLocationCoordinate2D(latitude: 37.807526, longitude: -122.42792),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Lincoln High School 14 Stair",
            neighborhood: "West Portal",
            coordinate: CLLocationCoordinate2D(latitude: 37.747215, longitude: -122.480225),
            difficulty: .pro,
            terrainTags: ["14-Stair"],
            popularity: 99,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yerba Buena Gardens 8 Stair",
            neighborhood: "Tenderloin",
            coordinate: CLLocationCoordinate2D(latitude: 37.784927, longitude: -122.401825),
            difficulty: .advanced,
            terrainTags: ["8-Stair"],
            popularity: 99,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Farmer's Market Ledges",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73601, longitude: -122.40984),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Grant Street Gap",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.788975, longitude: -122.40521),
            difficulty: .beginner,
            terrainTags: ["Gap"],
            popularity: 99,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Harry Bridges Island",
            neighborhood: "Financial District",
            coordinate: CLLocationCoordinate2D(latitude: 37.795025, longitude: -122.39412),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Brick 5 Flat 5",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.736034, longitude: -122.401),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 99,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cathedral 5 Flat 6 / Out Rail",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.784317, longitude: -122.4261),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 99,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Revere Street Ledge",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73852, longitude: -122.402405),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 99,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "SUP - 10 Stair",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.786514, longitude: -122.39273),
            difficulty: .advanced,
            terrainTags: ["10-Stair"],
            popularity: 99,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Hospital Hubba",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.75658, longitude: -122.404686),
            difficulty: .beginner,
            terrainTags: ["Hubba"],
            popularity: 93,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Jackson Park - 3 Flat 3 Double Set Hubba / Gap To Rail",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.764057, longitude: -122.39877),
            difficulty: .advanced,
            terrainTags: ["Rail", "Hubba", "Gap"],
            popularity: 93,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Stonestown Over Rail Into Bank",
            neighborhood: "Richmond District",
            coordinate: CLLocationCoordinate2D(latitude: 37.727646, longitude: -122.478775),
            difficulty: .pro,
            terrainTags: ["Rail", "Bank"],
            popularity: 93,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "The Flower Shop",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73694, longitude: -122.409454),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 93,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Graffiti Banks",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.759243, longitude: -122.4182),
            difficulty: .beginner,
            terrainTags: ["Bank"],
            popularity: 97,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Miraloma Elementary School - 4 Stair Out Rail",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73813, longitude: -122.45047),
            difficulty: .beginner,
            terrainTags: ["4-Stair", "Rail"],
            popularity: 87,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Black Rail",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.792404, longitude: -122.392494),
            difficulty: .pro,
            terrainTags: ["Rail"],
            popularity: 81,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Ferry Plaza - Triple Set / 3 Block",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.7945, longitude: -122.39266),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 91,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bart Wall Ride",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.752533, longitude: -122.41835),
            difficulty: .beginner,
            terrainTags: ["Wallride"],
            popularity: 85,
            featuredTrick: "Frontside Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cesar Chavez Gap Over Hubba",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.747234, longitude: -122.43438),
            difficulty: .beginner,
            terrainTags: ["Hubba", "Gap"],
            popularity: 69,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Cole Valley Hubba",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.766506, longitude: -122.44814),
            difficulty: .beginner,
            terrainTags: ["Hubba"],
            popularity: 79,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Golden Gate Park 13 Stair",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.769794, longitude: -122.46837),
            difficulty: .pro,
            terrainTags: ["13-Stair"],
            popularity: 79,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Polo Fields Rail",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.76691, longitude: -122.4929),
            difficulty: .beginner,
            terrainTags: ["Rail"],
            popularity: 79,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Saint Mary's Park Ledges",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73341, longitude: -122.421165),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 79,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Downhill Flatbar",
            neighborhood: "San Francisco",
            coordinate: CLLocationCoordinate2D(latitude: 37.71786, longitude: -122.45902),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 73,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Embarcadero Plaza - 3 Flat 2 Double Set Hubba",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.794704, longitude: -122.39434),
            difficulty: .beginner,
            terrainTags: ["Hubba", "Double Set"],
            popularity: 63,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Carrizal Bank",
            neighborhood: "San Francisco",
            coordinate: CLLocationCoordinate2D(latitude: 37.710224, longitude: -122.420135),
            difficulty: .beginner,
            terrainTags: ["Bank"],
            popularity: 67,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Kramer Pl Street Gap",
            neighborhood: "North Beach",
            coordinate: CLLocationCoordinate2D(latitude: 37.802414, longitude: -122.408264),
            difficulty: .advanced,
            terrainTags: ["Gap"],
            popularity: 57,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Masonic Centre Out Ledge",
            neighborhood: "Tenderloin",
            coordinate: CLLocationCoordinate2D(latitude: 37.791412, longitude: -122.4133),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 57,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Reservoir Banks",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.733334, longitude: -122.47892),
            difficulty: .advanced,
            terrainTags: ["Bank"],
            popularity: 57,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Sunnyside Elementary",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.73023, longitude: -122.448),
            difficulty: .pro,
            terrainTags: ["Street"],
            popularity: 57,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wallride",
            neighborhood: "North Beach",
            coordinate: CLLocationCoordinate2D(latitude: 37.80718, longitude: -122.44747),
            difficulty: .beginner,
            terrainTags: ["Wallride"],
            popularity: 67,
            featuredTrick: "Frontside Wallride"
        ),
        SkateSpot(
            id: UUID(),
            name: "Fire Station Ledges",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.746372, longitude: -122.38633),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 61,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Opera House 20 Stair Rail",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.77792, longitude: -122.42106),
            difficulty: .pro,
            terrainTags: ["20-Stair", "Rail"],
            popularity: 51,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Rochambeau Curved Ledge",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.784985, longitude: -122.48435),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 61,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Yerba Buena Center For The Arts - 10 Stair",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.78565, longitude: -122.402534),
            difficulty: .advanced,
            terrainTags: ["10-Stair"],
            popularity: 51,
            featuredTrick: "Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "George Washington Up Ledge",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.778595, longitude: -122.49014),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 45,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Golden Gate Park Gap",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.770603, longitude: -122.46674),
            difficulty: .beginner,
            terrainTags: ["Gap"],
            popularity: 55,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Orange Ledge",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.78258, longitude: -122.42425),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 55,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "USF 14 Stair Rail",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.776623, longitude: -122.44938),
            difficulty: .pro,
            terrainTags: ["14-Stair", "Rail"],
            popularity: 45,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Baker St - Bump To Rail",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.79542, longitude: -122.445244),
            difficulty: .beginner,
            terrainTags: ["Rail", "Bump"],
            popularity: 49,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Bernal Heights Ledge",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.74549, longitude: -122.4061),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 49,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Brick Bank",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.7862, longitude: -122.45627),
            difficulty: .intermediate,
            terrainTags: ["Bank"],
            popularity: 39,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Broderick St - Ledge To Hill Bomb",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.770176, longitude: -122.43866),
            difficulty: .beginner,
            terrainTags: ["Ledge"],
            popularity: 49,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Campton Pl - Street Gap",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.789112, longitude: -122.40539),
            difficulty: .beginner,
            terrainTags: ["Gap"],
            popularity: 39,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Esmeralda Ave - Sidewalk Bump",
            neighborhood: "Excelsior",
            coordinate: CLLocationCoordinate2D(latitude: 37.74313, longitude: -122.40809),
            difficulty: .beginner,
            terrainTags: ["Bump"],
            popularity: 49,
            featuredTrick: "Ollie Over"
        ),
        SkateSpot(
            id: UUID(),
            name: "Golden Gate Park - Fly Casting Pools",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.767773, longitude: -122.49674),
            difficulty: .beginner,
            terrainTags: ["Street"],
            popularity: 49,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Huntingdon Park 10 Stair Rail / Hubba",
            neighborhood: "Tenderloin",
            coordinate: CLLocationCoordinate2D(latitude: 37.792133, longitude: -122.412506),
            difficulty: .advanced,
            terrainTags: ["10-Stair", "Rail", "Hubba"],
            popularity: 39,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Manny Pad Off Ledge",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.77885, longitude: -122.42029),
            difficulty: .beginner,
            terrainTags: ["Ledge", "Manual"],
            popularity: 49,
            featuredTrick: "Backside Nosebluntslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Merry Go Round",
            neighborhood: "Tenderloin",
            coordinate: CLLocationCoordinate2D(latitude: 37.783318, longitude: -122.40222),
            difficulty: .intermediate,
            terrainTags: ["Street"],
            popularity: 39,
            featuredTrick: "Noseslide"
        ),
        SkateSpot(
            id: UUID(),
            name: "Mission St - Gap To Curb Cut",
            neighborhood: "SoMa",
            coordinate: CLLocationCoordinate2D(latitude: 37.79131, longitude: -122.395836),
            difficulty: .beginner,
            terrainTags: ["Gap"],
            popularity: 39,
            featuredTrick: "Switch Kickflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Phillip and Sala Burton Academic School - 16 Stair Rail Through Gate",
            neighborhood: "San Francisco",
            coordinate: CLLocationCoordinate2D(latitude: 37.721954, longitude: -122.40626),
            difficulty: .pro,
            terrainTags: ["16-Stair", "Rail"],
            popularity: 39,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Presidio - Bank Then 8 Stair",
            neighborhood: "North Beach",
            coordinate: CLLocationCoordinate2D(latitude: 37.802723, longitude: -122.475655),
            difficulty: .advanced,
            terrainTags: ["8-Stair", "Bank"],
            popularity: 39,
            featuredTrick: "Rock Fakie"
        ),
        SkateSpot(
            id: UUID(),
            name: "Safeway - 9 Stair Rail",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.76796, longitude: -122.42878),
            difficulty: .advanced,
            terrainTags: ["9-Stair", "Rail"],
            popularity: 49,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "SFSU 7 Stair Kink Rail",
            neighborhood: "Richmond District",
            coordinate: CLLocationCoordinate2D(latitude: 37.72106, longitude: -122.47705),
            difficulty: .intermediate,
            terrainTags: ["7-Stair", "Rail"],
            popularity: 39,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "St Monica Church 2 Flat 8 Double Set Rail",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.780388, longitude: -122.48278),
            difficulty: .pro,
            terrainTags: ["Rail", "Double Set"],
            popularity: 39,
            featuredTrick: "Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Waller Ledges",
            neighborhood: "Castro",
            coordinate: CLLocationCoordinate2D(latitude: 37.76823, longitude: -122.45399),
            difficulty: .beginner,
            terrainTags: ["Ledge", "Wallride"],
            popularity: 49,
            featuredTrick: "Backside Nosebluntslide"
        ),
    ]
}
