//
//  GeoModels+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit

extension Coordinate2D {
	
	public var clLocation: CLLocation {
		CLLocation(latitude: latitude.degrees, longitude: longitude.degrees)
	}
	
	public var clLocationCoordinate2D: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude.degrees, longitude: longitude.degrees)
	}
	
	public var mkMapPoint: MKMapPoint {
		MKMapPoint(clLocationCoordinate2D)
	}
	
	public init(_ coordinate: CLLocationCoordinate2D) {
		self.init(latitude: Latitude(coordinate.latitude), longitude: Longitude(coordinate.longitude))
	}
	
}

extension BoundingBox2D {
	
	public var mkCoordinateSpan: MKCoordinateSpan {
		MKCoordinateSpan(latitudeDelta: height.degrees, longitudeDelta: width.degrees)
	}
	public var mkCoordinateRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: center.clLocationCoordinate2D, span: mkCoordinateSpan)
	}
	
	public var mkMapWidth: Double {
		mkMapWidthAtLatitude(center.latitude)
	}
	public var mkMapHeight: Double {
		mkMapHeightAtLongitude(center.longitude)
	}
	
	public var mkMapRect: MKMapRect {
		// Avoid center recalculation
		let center = self.center
		
		return MKMapRect(
			origin: northWest.mkMapPoint,
			size: MKMapSize(
				width: mkMapWidthAtLatitude(center.latitude),
				height: mkMapHeightAtLongitude(center.longitude)
			)
		)
	}
	
	public func mkMapWidthAtLatitude(_ latitude: Latitude) -> Double {
		let east = eastAtLatitude(latitude).mkMapPoint
		let west = westAtLatitude(latitude).mkMapPoint
		
		// `east.x > west.x`
		return east.x - west.x
	}
	public func mkMapHeightAtLongitude(_ longitude: Longitude) -> Double {
		let south = southAtLongitude(longitude).mkMapPoint
		let north = northAtLongitude(longitude).mkMapPoint
		
		// `south.y > north.y`
		return south.y - north.y
	}
	
}
#endif
