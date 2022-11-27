//
//  WGS84Geometry+CoreLocation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
import CoreLocation

public extension Point2D {

	var clLocation: CLLocation {
		self.coordinates.clLocation
	}

	var clLocationCoordinate2D: CLLocationCoordinate2D {
		self.coordinates.clLocationCoordinate2D
	}

	init(_ location: CLLocation) {
		self.init(coordinates: .init(location))
	}

	init(_ coordinate: CLLocationCoordinate2D) {
		self.init(coordinates: .init(coordinate))
	}

}
#endif
