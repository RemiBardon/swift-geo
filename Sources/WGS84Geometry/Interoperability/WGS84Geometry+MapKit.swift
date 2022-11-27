//
//  WGS84Geometry+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit

public extension WGS842D.Point {

	var mkMapPoint: MKMapPoint {
		self.coordinates.mkMapPoint
	}

}

public extension WGS842D.BoundingBox {

	var mkCoordinateSpan: MKCoordinateSpan {
		MKCoordinateSpan(
			latitudeDelta: self.size.height.decimalDegrees,
			longitudeDelta: self.size.width.decimalDegrees
		)
	}
	var mkCoordinateRegion: MKCoordinateRegion {
		MKCoordinateRegion(center: center.clLocationCoordinate2D, span: mkCoordinateSpan)
	}

//	var mkMapWidth: Double {
//		mkMapWidthAtLatitude(center.latitude)
//	}
//	var mkMapHeight: Double {
//		mkMapHeightAtLongitude(center.longitude)
//	}
//
//	var mkMapRect: MKMapRect {
//		// Avoid center recalculation
//		let center = self.center
//
//		return MKMapRect(
//			origin: northWest.mkMapPoint,
//			size: MKMapSize(
//				width: mkMapWidthAtLatitude(center.latitude),
//				height: mkMapHeightAtLongitude(center.longitude)
//			)
//		)
//	}
//
//	func mkMapWidthAtLatitude(_ latitude: Self.Point.X) -> Double {
//		let east = eastAtLatitude(latitude).mkMapPoint
//		let west = westAtLatitude(latitude).mkMapPoint
//
//		assert(east.x > west.x)
//		return east.x - west.x
//	}
//	func mkMapHeightAtLongitude(_ longitude: Self.Point.Y) -> Double {
//		let south = southAtLongitude(longitude).mkMapPoint
//		let north = northAtLongitude(longitude).mkMapPoint
//
//		assert(south.y > north.y)
//		return south.y - north.y
//	}

}

public extension WGS842D.LineString {

	var mkPolyline: MKPolyline {
		var points: [CLLocationCoordinate2D] = self.points.map(\.clLocationCoordinate2D)
		return MKPolyline(coordinates: &points, count: points.count)
	}

}
#endif
