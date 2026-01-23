import Foundation
import CoreLocation

struct Bar: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
    let amenities: [String]
    let vibe: String
    let busyPercent: Int
    let updatedAt: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum CrowdLevel: String, CaseIterable, Codable, Identifiable {
    case chill = "CHILL"
    case medium = "MEDIUM"
    case busy = "BUSY"
    case packed = "PACKED"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .chill:
            return "Chill"
        case .medium:
            return "Medium"
        case .busy:
            return "Busy"
        case .packed:
            return "Packed"
        }
    }

    var colorHex: String {
        switch self {
        case .chill:
            return "5BC67A"
        case .medium:
            return "F2B84B"
        case .busy:
            return "F59F4A"
        case .packed:
            return "E2574C"
        }
    }
}

struct CheckIn: Identifiable, Codable {
    let id: String
    let barId: String
    let crowdLevel: CrowdLevel
    let observations: [String]
    let createdAt: Date
    let bar: Bar?
}

struct TrendResponse: Codable {
    let barId: String
    let hours: Int
    let points: [TrendPoint]
}

struct TrendPoint: Codable {
    let crowdLevel: CrowdLevel
    let createdAt: Date
}

struct CheckInRequest: Codable {
    let barId: String
    let crowdLevel: CrowdLevel
    let observations: [String]
}
