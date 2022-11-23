//
//  Turf+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit
import Turf
import WGS84

//public func mkBBox(for points: [WGS842D.Point]) -> MKMapRect {
//	return WGS842D.bbox(forCollection: points)?.mkMapRect ?? .world
//}
//
//public func mkBBox(for coords: [CLLocationCoordinate2D]) -> MKMapRect {
//	return mkBBox(for: coords.map(Point2D.init))
//}

public func clCenter(for points: [WGS842D.Point]) -> CLLocationCoordinate2D? {
	return WGS842D.center(forCollection: points)?.clLocationCoordinate2D
}

public func clCenter(for coords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
	return clCenter(for: coords.map(WGS842D.Point.init))
}
#endif
