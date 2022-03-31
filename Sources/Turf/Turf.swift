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

// MARK: - Bounding box

// MARK: Lines (fix > .halfRotation)

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) of a polygon.
///
/// - Warning: As stated in [section 3.1.6 of FRC 7946](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6),
///   polygon ring MUST follow the right-hand rule for orientation (counterclockwise).
//public func bbox(forPolygon coords: [Point2D]) -> BoundingBox2D? {
//	if coords.adjacentPairs().contains(where: { Line2D(start: $0, end: $1).crosses180thMeridian }) {
//		let offsetCoords = coords.map(\.withPositiveLongitude)
//
//		return Turf.bbox(for: offsetCoords)
//	} else {
//		return Turf.bbox(for: coords)
//	}
//}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) enclosing all elements.
//public func bbox<T: Boundable, C: Collection>(for boundables: C) -> T.BoundingBox? where C.Element == T {
//	guard !boundables.isEmpty else { return nil }
//	
//	return boundables.reduce(.zero, { $0.union($1.bbox) })
//}

// MARK: - Plannar area

/// Calculates the signed area of a planar non-self-intersecting polygon
/// (not taking into account the curvature of the Earth).
///
/// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
public func plannarArea<Points: Collection>(forCollection points: Points) -> Double
where Points.Element == Point2D
{
	guard let first = points.first else { return 0 }
	
	var ring = Array(points)
	// Close the ring
	if ring.last != first {
		ring.append(first)
	}
	
	var area: Double = 0
	for (c1, c2) in ring.adjacentPairs() {
		area += c1.x.decimalDegrees * c2.y.decimalDegrees - c2.x.decimalDegrees * c1.y.decimalDegrees
	}
	
	return area / 2.0
}

// MARK: - Clockwise

/// Calculates if a given polygon is clockwise or counter-clockwise.
///
/// ```swift
/// let clockwiseRing = LineString2D(Point2D(0, 0), Point2D(1, 1), Point2D(1, 0), Point2D(0, 0))
/// let counterClockwiseRing = LineString2D(Point2D(0, 0), Point2D(1, 0), Point2D(1, 1), Point2D(0, 0))
///
/// Turf.isClockwise(clockwiseRing) // true
/// Turf.isClockwise(counterClockwiseRing) // false
/// ```
///
/// Ported from [Turf](https://github.com/Turfjs/turf/blob/d72985ce1a577b42340fed5fc70efe8e4bc8b062/packages/turf-boolean-clockwise/index.ts#L19-L35).
public func isClockwise<Points: Collection>(_ points: Points) -> Bool
where Points.Element == Point2D
{
	return plannarArea(forCollection: points) > 0
}
