//
//  File.swift
//  
//
//  Created by Neo Golightly on 07.06.24.
//

import Foundation
import CoreLocation
//public func ==(lhs: CLLocation, rhs: CLLocation) -> Bool {
//  return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
//}

//public func !=(lhs: CLLocation, rhs: CLLocation) -> Bool {
//  return lhs.coordinate.latitude != rhs.coordinate.latitude || lhs.coordinate.longitude != rhs.coordinate.longitude
//}
extension CLLocation: Equatable {

  static public func ==(lhs: CLLocation, rhs: CLLocation) -> Bool {
    return lhs.coordinate == rhs.coordinate
  }
}
