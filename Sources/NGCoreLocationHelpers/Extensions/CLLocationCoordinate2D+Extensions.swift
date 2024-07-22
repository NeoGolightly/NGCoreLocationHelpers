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
  
  public static func distance(coodinates: [CLLocationCoordinate2D]) -> CLLocationDistance {
    var distance: CLLocationDistance = 0
    for (idx, coordinate) in coodinates.enumerated() {
      if idx != coodinates.endIndex - 2 {
        distance += CLLocationCoordinate2D.distance(from: coordinate, to: coodinates[idx + 1])
      }
    }
    return distance
  }
  
  
  public func toCLLocation() -> CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }
}


extension CLLocationCoordinate2D {
  public func bearingTo(_ toLocation: CLLocationCoordinate2D) -> Double {
    let fromLatitude = self.latitude.toRadians
    let fromLongitude = self.longitude.toRadians

    let toLatitude = toLocation.latitude.toRadians
    let toLongitude = toLocation.longitude.toRadians
    
    let dLongitude = toLongitude - fromLongitude
    
    let y = sin(dLongitude) * cos(toLatitude)
    let x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(dLongitude)
    let radiansBearing = atan2(y, x).toDegrees
    
    if radiansBearing >= 0 {
      return radiansBearing
    } else {
      return radiansBearing + 360
    }

  }
}

extension CLLocationCoordinate2D {
  public func calculateAngle(p2: CLLocationCoordinate2D, p3: CLLocationCoordinate2D) -> Double {
    let p1 = self.toWebMercator()
    let p2 = p2.toWebMercator()
    let p3 = p3.toWebMercator()
    let angle1 = atan2(p1.y - p2.y, p1.x - p2.x)
    let angle2 = atan2(p3.y - p2.y, p3.x - p2.x)    
    
    var angle: Double = fabs(angle1 - angle2);
    if (angle > Double.pi) {
      angle = (Double.pi*2) - angle;
    }
    return angle.toDegrees
  }
}

extension CLLocationCoordinate2D {
  func toWebMercator() -> CGPoint {
    let earthRadius: Double = 6378137 // Earth radius in meters
    
    let d2r = Double.pi / 180; // Degrees to radians
    
    let x = earthRadius * longitude * d2r
    let y = earthRadius * log(tan((Double.pi / 4) + (latitude * d2r / 2)))
    
    return CGPoint(x: x, y: y)
  }
}

extension Double {
  public var toRadians : Double {
    return Measurement(value: self, unit: UnitAngle.degrees)
      .converted(to: .radians)
      .value
  }
  public var toDegrees : Double {
    return Measurement(value: self, unit: UnitAngle.radians).converted(to: .degrees).value
  }
}
