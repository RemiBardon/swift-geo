//
//  Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/04/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import Algorithms
import GeoModels

// FIXME: Fix formulae so they handle crossing the anti meridian

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) of a polygon.
///
/// - Warning: As stated in [section 3.1.6 of FRC 7946](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6),
///   polygon ring MUST follow the right-hand rule for orientation (counterclockwise).
//public func bbox(forPolygon coords: [Coordinate2D]) -> BoundingBox2D? {
//	if coords.adjacentPairs().contains(where: { Line2D(start: $0, end: $1).crosses180thMeridian }) {
//		let offsetCoords = coords.map(\.withPositiveLongitude)
//
//		return Turf.bbox(for: offsetCoords)
//	} else {
//		return Turf.bbox(for: coords)
//	}
//}

/// Returns the minimum straight [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
/// enclosing the points.
public func minimumBBox(for coords: [Coordinate2D]) -> BoundingBox2D? {
	guard let bbox = Turf.bbox(for: coords) else { return nil }
	
	if bbox.width > .halfRotation {
		let offsetCoords = coords.map(\.withPositiveLongitude)
		
		return Turf.bbox(for: offsetCoords)
	} else {
		return bbox
	}
}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) enclosing the points.
public func bbox(for coords: [Coordinate2D]) -> BoundingBox2D? {
	guard let (south, north) = coords.map(\.latitude).minAndMax(),
		  let (west, east) = coords.map(\.longitude).minAndMax()
	else { return nil }
	
	return BoundingBox2D(
		southWest: Coordinate2D(latitude: south, longitude: west),
		northEast: Coordinate2D(latitude: north, longitude: east)
	)
}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) enclosing all elements.
public func bbox<T: Boundable, C: Collection>(for boundables: C) -> T.BoundingBox? where C.Element == T {
	guard !boundables.isEmpty else { return nil }
	
	return boundables.reduce(.zero, { $0.union($1.bbox) })
}

/// Returns the absolute center of a polygon.
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center/index.ts#L36-L44>
public func center(for coords: [Coordinate2D]) -> Coordinate2D? {
	return bbox(for: coords)?.center
}

/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
/// Used formula: [Centroid of Polygon](https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon)
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
public func centerOfMass(for coords: [Coordinate2D]) -> Coordinate2D {
	// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
	// We take any point to translate all the points around 0
	let centre: Coordinate2D = centroid(for: coords)
	let translation: Coordinate2D = centre
	var sx: Double = 0
	var sy: Double = 0
	var sArea: Double = 0
	
	let neutralizedPoints: [Coordinate2D] = coords.map { $0 - translation }
	
	for i in 0..<coords.count - 1 {
		// pi is the current point
		let pi: Coordinate2D = neutralizedPoints[i]
		let xi: Double = pi.longitude.decimalDegrees
		let yi: Double = pi.latitude.decimalDegrees
		
		// pj is the next point (pi+1)
		let pj: Coordinate2D = neutralizedPoints[i + 1]
		let xj: Double = pj.longitude.decimalDegrees
		let yj: Double = pj.latitude.decimalDegrees
		
		// a is the common factor to compute the signed area and the final coordinates
		let a: Double = xi * yj - xj * yi
		
		// sArea is the sum used to compute the signed area
		sArea += a
		
		// sx and sy are the sums used to compute the final coordinates
		sx += (xi + xj) * a
		sy += (yi + yj) * a
	}
	
	// Shape has no area: fallback on turf.centroid
	if (sArea == 0) {
		return centre
	} else {
		// Compute the signed area, and factorize 1/6A
		let area: Double = sArea * 0.5
		let areaFactor: Double = 1 / (6 * area)
		
		// Compute the final coordinates, adding back the values that have been neutralized
		return Coordinate2D(
			latitude: translation.latitude + Latitude(areaFactor * sy),
			longitude: translation.longitude + Longitude(areaFactor * sx)
		)
	}
}

/// Calculates the centroid of a polygon using the mean of all vertices.
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-centroid/index.ts#L21-L40>
public func centroid(for coordinates: [Coordinate2D]) -> Coordinate2D {
	var sumLongitude: Longitude = 0.0
	var sumLatitude: Latitude = 0.0
	
	for coordinate in coordinates {
		sumLongitude += coordinate.longitude
		sumLatitude += coordinate.latitude
	}
	
	return Coordinate2D(
		latitude: sumLatitude / Latitude(coordinates.count),
		longitude: sumLongitude / Longitude(coordinates.count)
	)
}
