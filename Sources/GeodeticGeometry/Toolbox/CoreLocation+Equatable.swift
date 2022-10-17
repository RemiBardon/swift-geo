//
//  CoreLocation+Equatable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/01/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		let loc1 = CLLocation(latitude: lhs.latitude, longitude: lhs.longitude)
		let loc2 = CLLocation(latitude: rhs.latitude, longitude: rhs.longitude)
		// Coordinates are equal if they're less than 0.5m away
		return loc2.distance(from: loc1) < 0.5
	}
	
}
#endif
