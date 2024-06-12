//
//  File.swift
//
//
//  Created by Neo Golightly on 04.06.24.
//

import Foundation
import CoreLocation
// public func ==(lhs: CLLocationDegrees, rhs: CLLocationDegrees) -> Bool {
//  return lhs == rhs
//}
//extension CLLocationDegrees: Equatable {
//  
////  static public func !=(lhs: CLLocationDegrees, rhs: CLLocationDegrees) -> Bool {
////    return lhs != rhs
////  }
//}
//public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//  return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//}

extension Double {
  static func equal(_ lhs: Double, _ rhs: Double, precise value: Int? = nil) -> Bool {
    guard let value = value else {
      return lhs == rhs
    }
        
    return lhs.precised(value) == rhs.precised(value)
  }

  func precised(_ value: Int = 1) -> Double {
    let offset = pow(10, Double(value))
    return (self * offset).rounded() / offset
  }
  
  func doubleEqual(to: Double) -> Bool {
      return fabs(self - to) < Double.ulpOfOne
  }
}



extension CLLocationCoordinate2D: Equatable {
  
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
      return lhs.latitude.isEqual(to: rhs.latitude) && lhs.longitude.isEqual(to: rhs.longitude)
    }
  
//  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//    let numbersAfterCommaAccuracy: Double = 5
//    let ratio = numbersAfterCommaAccuracy * 10
//    let isLatitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
//    let isLongitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
//    return isLatitudeEqual && isLongitudeEqual
//  }
}

extension CLLocationCoordinate2D: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.latitude)
    hasher.combine(self.longitude)
  }
}

extension CLLocationCoordinate2D: Codable {
  public enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try values.decode(Double.self, forKey: .latitude)
    let longitude = try values.decode(Double.self, forKey: .longitude)
    self.init(latitude: latitude, longitude: longitude)
  }
}

extension CLLocationCoordinate2D: Identifiable {
  public var id: Double {
    latitude+longitude
  }
}

extension CLLocationCoordinate2D {
  public func formatted() -> String {
    "\(latitude) \(longitude)"
  }
  
  public static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
    return from.distance(from: to)
  }
  
  public func toCLLocation() -> CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }
}

