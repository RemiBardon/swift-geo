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

public func mkNaiveBBox(for points: [WGS842D.Point]) -> MKMapRect {
	return WGS842D.naiveBBox(forCollection: points)?.mkMapRect ?? .world
}

public func mkNaiveBBox(for coords: [CLLocationCoordinate2D]) -> MKMapRect {
	return Turf.mkNaiveBBox(for: coords.map(Point2D.init))
}

public func clNaiveCenter(for points: [WGS842D.Point]) -> CLLocationCoordinate2D? {
	return WGS842D.naiveCenter(forCollection: points)?.clLocationCoordinate2D
}

public func clNaiveCenter(for coords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
	return Turf.clNaiveCenter(for: coords.map(WGS842D.Point.init))
}
#endif
