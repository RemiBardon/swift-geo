//
//  WGS84+CoreLocation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation) && canImport(Turf)
import CoreLocation

extension Coordinate2D {
	
	public var clLocation: CLLocation {
		CLLocation(latitude: latitude.decimalDegrees, longitude: longitude.decimalDegrees)
	}
	
	public var clLocationCoordinate2D: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude.decimalDegrees, longitude: longitude.decimalDegrees)
	}
	
	public init(_ location: CLLocation) {
		self.init(location.coordinate)
	}
	
	public init(_ coordinate: CLLocationCoordinate2D) {
		self.init(
			latitude: .init(decimalDegrees: coordinate.latitude),
			longitude: .init(decimalDegrees: coordinate.longitude)
		)
	}
	
}

extension Point2D {

	public var clLocation: CLLocation {
		self.coordinates.clLocation
	}

	public var clLocationCoordinate2D: CLLocationCoordinate2D {
		self.coordinates.clLocationCoordinate2D
	}

	public init(_ location: CLLocation) {
		self.init(coordinates: .init(location))
	}

	public init(_ coordinate: CLLocationCoordinate2D) {
		self.init(coordinates: .init(coordinate))
	}

}
#endif
