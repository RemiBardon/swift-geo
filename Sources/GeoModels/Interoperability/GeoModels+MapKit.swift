//
//  GeoModels+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit

extension BoundingBox2D {
	
	public var mkCoordinateSpan: MKCoordinateSpan {
		MKCoordinateSpan(latitudeDelta: height.decimalDegrees, longitudeDelta: width.decimalDegrees)
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

extension LineString2D {

	public var mkPolyline: MKPolyline {
		var points: [CLLocationCoordinate2D] = self.points.map(\.clLocationCoordinate2D)
		return MKPolyline(coordinates: &points, count: points.count)
	}

}
#endif
