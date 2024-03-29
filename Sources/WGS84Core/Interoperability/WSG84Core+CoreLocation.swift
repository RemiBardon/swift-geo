//
//  WSG84Core+CoreLocation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
import CoreLocation

extension Coordinate2D {

	public var clLocation: CLLocation {
		CLLocation(
			latitude: self.latitude.decimalDegrees,
			longitude: self.longitude.decimalDegrees
		)
	}

	public var clLocationCoordinate2D: CLLocationCoordinate2D {
		CLLocationCoordinate2D(
			latitude: self.latitude.decimalDegrees,
			longitude: self.longitude.decimalDegrees
		)
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
#endif
