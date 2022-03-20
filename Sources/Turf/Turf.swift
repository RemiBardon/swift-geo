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

// MARK: Points

public func bbox(forPoint point: Point2D) -> BoundingBox2D {
	return BoundingBox2D(southWest: point, width: .zero, height: .zero)
}

public func bbox(forPoint point: Point3D) -> BoundingBox3D {
	return BoundingBox3D(southWestLow: point, width: .zero, height: .zero, zHeight: .zero)
}

// MARK: MultiPoints

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
/// enclosing a cluster of 2D points.
/// - Warning: This does not take into account the curvature of the Earth.
/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
public func naiveBBox<Points: Collection>(forCollection points: Points) -> BoundingBox2D?
where Points.Element == Point2D
{
	guard let (south, north) = points.map(\.latitude).minAndMax(),
		  let (west, east) = points.map(\.longitude).minAndMax()
	else { return nil }
	
	return BoundingBox2D(
		southWest: Point2D(latitude: south, longitude: west),
		northEast: Point2D(latitude: north, longitude: east)
	)
}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
/// enclosing a cluster of 3D points.
/// - Warning: This does not take into account the curvature of the Earth.
/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
public func naiveBBox<Points: Collection>(forCollection points: Points) -> BoundingBox3D?
where Points.Element == Point3D
{
	guard let (south, north) = points.map(\.latitude).minAndMax(),
		  let (west, east) = points.map(\.longitude).minAndMax(),
		  let (low, high) = points.map(\.altitude).minAndMax()
	else { return nil }
	
	return BoundingBox3D(
		southWestLow: Point3D(latitude: south, longitude: west, altitude: low),
		northEastHigh: Point3D(latitude: north, longitude: east, altitude: high)
	)
}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
/// enclosing a cluster of 2D points.
/// - Warning: This does not take into account the curvature of the Earth.
/// - Note: This implementation takes into account the angular coordinate system
///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
public func bbox<Points: Collection>(forCollection points: Points) -> BoundingBox2D?
where Points.Element == Point2D
{
	guard let bbox = Turf.naiveBBox(forCollection: points) else { return nil }
	
	if bbox.width > Longitude.halfRotation {
		let offsetCoords = points.map(\.withPositiveLongitude)
		
		return Turf.bbox(forCollection: offsetCoords)
	} else {
		return bbox
	}
}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
/// enclosing a cluster of 3D points.
/// - Warning: This does not take into account the curvature of the Earth.
/// - Note: This implementation takes into account the angular coordinate system
///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
public func bbox<Points: Collection>(forCollection points: Points) -> BoundingBox3D?
where Points.Element == Point3D
{
	guard let bbox = Turf.naiveBBox(forCollection: points) else { return nil }
	
	if bbox.twoDimensions.width > Longitude.halfRotation {
		let offsetCoords = points.map(\.withPositiveLongitude)
		
		return Turf.bbox(forCollection: offsetCoords)
	} else {
		return bbox
	}
}

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

// MARK: - Center

/// Returns the linear center of a cluster of 2D points.
/// - Warning: This does not take into account the curvature of the Earth.
/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
///   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
public func naiveCenter<Points: Collection>(forCollection points: Points) -> Point2D?
where Points.Element == Point2D
{
	return Turf.naiveBBox(forCollection: points)
		.flatMap(Turf.center(forBBox:))
}

public func center(forBBox bbox: BoundingBox2D) -> Point2D {
	return Point2D(
		x: bbox.origin.x + bbox.width / 2,
		y: bbox.origin.y + bbox.height / 2
	)
}

// MARK: - Center of mass

/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
/// Used formula: [Centroid of Polygon](https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon)
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
public func centerOfMass<Points: Collection>(forCollection points: Points) -> Point2D?
where Points.Element == Point2D
{
	// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
	// We take any point to translate all the points around 0
	guard let centre: Point2D = Turf.centroid(forCollection: points) else { return nil }
	let translation: Point2D = centre
	var sx: Point2D.X = 0
	var sy: Point2D.Y = 0
	var sArea: Double = 0
	
	let neutralizedPoints: [Point2D] = points.map { Point2D(x: $0.x - translation.x, y: $0.y - translation.y) }
	
	for i in 0..<points.count - 1 {
		// pi is the current point
		let pi: Point2D = neutralizedPoints[i]
		let xi: Point2D.X = pi.x
		let yi: Point2D.Y = pi.y
		
		// pj is the next point (pi+1)
		let pj: Point2D = neutralizedPoints[i + 1]
		let xj: Point2D.X = pj.x
		let yj: Point2D.Y = pj.y
		
		// a is the common factor to compute the signed area and the final coordinates
		let a: Double = xi.decimalDegrees * yj.decimalDegrees - xj.decimalDegrees * yi.decimalDegrees
		
		// sArea is the sum used to compute the signed area
		sArea += a
		
		// sx and sy are the sums used to compute the final coordinates
		sx += (xi + xj) * Point2D.X(a)
		sy += (yi + yj) * Point2D.Y(a)
	}
	
	// Shape has no area: fallback on turf.centroid
	if (sArea == 0) {
		return centre
	} else {
		// Compute the signed area, and factorize 1/6A
		let area: Double = sArea * 0.5
		let areaFactor: Double = 1 / (6 * area)
		
		// Compute the final coordinates, adding back the values that have been neutralized
		return Point2D(
			x: translation.x + (Point2D.X(areaFactor) * sx),
			y: translation.y + (Point2D.Y(areaFactor) * sy)
		)
	}
}

// MARK: - Centroid

/// Calculates the centroid of a polygon using the mean of all vertices.
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-centroid/index.ts#L21-L40>
public func centroid<Points: Collection>(forCollection points: Points) -> Point2D?
where Points.Element == Point2D
{
	guard !points.isEmpty else { return nil }
	
	var sumX: Point2D.X = .zero
	var sumY: Point2D.Y = .zero
	
	for point in points {
		sumX += point.x
		sumY += point.y
	}
	
	return Point2D(
		x: sumX / Point2D.X(points.count),
		y: sumY / Point2D.Y(points.count)
	)
}

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
