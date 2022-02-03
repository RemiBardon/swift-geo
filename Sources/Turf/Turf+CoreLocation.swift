//
//  Turf+CoreLocation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
import Algorithms
import CoreLocation
import GeoModels

/// Measures the length of a polyline.
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-length/index.ts#L26-L41>
func length(polyline coords: [Coordinate2D]) -> Double {
	let locations = coords.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
	var length: Double = 0
	for (location1, location2) in locations.adjacentPairs() {
		length += location1.distance(from: location2)
	}
	return length
}
#endif
