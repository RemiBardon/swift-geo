//
//  GeoModels+CoreLocation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
import CoreLocation

extension Coordinate2D {
	
	public var clLocation: CLLocation {
		CLLocation(latitude: latitude.degrees, longitude: longitude.degrees)
	}
	
	public var clLocationCoordinate2D: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude.degrees, longitude: longitude.degrees)
	}
	
	public init(_ coordinate: CLLocationCoordinate2D) {
		self.init(latitude: Latitude(coordinate.latitude), longitude: Longitude(coordinate.longitude))
	}
	
}
#endif
