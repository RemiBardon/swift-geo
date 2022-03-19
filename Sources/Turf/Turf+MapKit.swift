//
//  Turf+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import GeoModels
import MapKit

func mkBBox(for coords: [Coordinate2D]) -> MKMapRect {
	return naiveBBox(forCollection: coords)?.mkMapRect ?? .world
}

func mkBBox(for coords: [CLLocationCoordinate2D]) -> MKMapRect {
	return mkBBox(for: coords.map(Coordinate2D.init))
}

func clCenter(for coords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
	return center(for: coords.map(Coordinate2D.init))?.clLocationCoordinate2D
}
#endif
