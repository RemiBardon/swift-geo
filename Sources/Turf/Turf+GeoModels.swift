//
//  Turf+GeoModels.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import GeodeticGeometry
import NonEmpty

// FIXME: Fix formulae so they handle crossing the anti meridian

// MARK: - Bounding box

// MARK: MultiPoints

//public func naiveBBox<MultiPoint: GeoModels.MultiPoint>(
//	forMultiPoint multiPoint: MultiPoint
//) -> MultiPoint.Point.GeometricSystem.BoundingBox {
//	return naiveBBox(forNonEmptyCollection: multiPoint.points)
//}

//extension GeoModels.MultiPoint where Point == Point2D {
//	public var naiveBBox: BoundingBox2D { Turf.naiveBBox(forMultiPoint: self) }
//}
//
//public func naiveBBox<Cluster: GeoModels.MultiPoint>(forMultiPoint cluster: Cluster) -> BoundingBox3D
//where Cluster.Point == Point3D
//{
//	return naiveBBox(forNonEmptyCollection: cluster.points)
//}
//
//extension GeoModels.MultiPoint where Point == Point3D {
//	public var naiveBBox: BoundingBox3D { Turf.naiveBBox(forMultiPoint: self) }
//}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
///// enclosing a cluster of 2D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Note: This implementation takes into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
//public func bbox<Points: Collection>(forCollection points: Points) -> BoundingBox2D?
//where Points.Element == Point2D
//{
//	guard let bbox = Turf.naiveBBox(forCollection: points) else { return nil }
//	
//	if bbox.width > Longitude.halfRotation {
//		let offsetCoords = points.map(\.withPositiveLongitude)
//		
//		return Turf.bbox(forCollection: offsetCoords)
//	} else {
//		return bbox
//	}
//}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
///// enclosing a cluster of 3D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Note: This implementation takes into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
//public func bbox<Points: Collection>(forCollection points: Points) -> BoundingBox3D?
//where Points.Element == Point3D
//{
//	guard let bbox = Turf.naiveBBox(forCollection: points) else { return nil }
//	
//	if bbox.twoDimensions.width > Longitude.halfRotation {
//		let offsetCoords = points.map(\.withPositiveLongitude)
//		
//		return Turf.bbox(forCollection: offsetCoords)
//	} else {
//		return bbox
//	}
//}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
///// enclosing a cluster of 2D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Note: This implementation takes into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
//public func bbox<Cluster: GeoModels.MultiPoint>(forMultiPoint cluster: Cluster) -> BoundingBox2D
//where Cluster.Point == Point2D
//{
//	let bbox = Turf.naiveBBox(forMultiPoint: cluster)
//	
//	if bbox.width > Longitude.halfRotation {
//		let offsetCoords = cluster.points.map(\.withPositiveLongitude)
//		
//		return Turf.naiveBBox(forCollection: offsetCoords) ?? Turf.bbox(forPoint: cluster.points.first)
//	} else {
//		return bbox
//	}
//}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
///// enclosing a cluster of 3D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Note: This implementation takes into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
//public func bbox<Cluster: GeoModels.MultiPoint>(forMultiPoint cluster: Cluster) -> BoundingBox3D
//where Cluster.Point == Point3D
//{
//	let bbox = Turf.naiveBBox(forMultiPoint: cluster)
//	
//	if bbox.twoDimensions.width > Longitude.halfRotation {
//		let offsetCoords = cluster.points.map(\.withPositiveLongitude)
//		
//		return Turf.naiveBBox(forCollection: offsetCoords) ?? Turf.bbox(forPoint: cluster.points.first)
//	} else {
//		return bbox
//	}
//}
//
//// MARK: Lines (fix > .halfRotation)
//
//extension GeoModels.Line2D {
//	public var naiveBBox: BoundingBox2D { Turf.naiveBBox(forNonEmptyCollection: self.points) }
//	//	public var bbox: BoundingBox2D { Turf.bbox(forNonEmptyCollection: self.points) }
//}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) of a polygon.
/////
///// - Warning: As stated in [section 3.1.6 of FRC 7946](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6),
/////   polygon ring MUST follow the right-hand rule for orientation (counterclockwise).
////public func bbox(forPolygon coords: [Coordinate2D]) -> BoundingBox2D? {
////	if coords.adjacentPairs().contains(where: { Line2D(start: $0, end: $1).crosses180thMeridian }) {
////		let offsetCoords = coords.map(\.withPositiveLongitude)
////
////		return Turf.bbox(for: offsetCoords)
////	} else {
////		return Turf.bbox(for: coords)
////	}
////}
//
///// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) enclosing all elements.
////public func bbox<T: Boundable, C: Collection>(for boundables: C) -> T.BoundingBox? where C.Element == T {
////	guard !boundables.isEmpty else { return nil }
////
////	return boundables.reduce(.zero, { $0.union($1.bbox) })
////}
//
//// MARK: - Center
//
///// Returns the linear center of a cluster of 2D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Warning: This is a naive implementation, not taking into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
//public func naiveCenter<Points: Collection>(for points: Points) -> Point2D?
//where Points.Element == Point2D
//{
//	guard let (south, north) = points.map(\.latitude).minAndMax(),
//		  let (west, east) = points.map(\.longitude).minAndMax()
//	else { return nil }
//	
//	return Point2D(latitude: (north - south) / 2, longitude: (east - west) / 2)
//}
//
///// Returns the linear center of a cluster of 2D points.
///// - Warning: This does not take into account the curvature of the Earth.
///// - Warning: This is a naive implementation, not taking into account the angular coordinate system
/////   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
//public func naiveCenter<Cluster: GeoModels.MultiPoint>(for cluster: Cluster) -> Point2D
//where Cluster.Point == Point2D
//{
//	return naiveCenter(for: cluster.points) ?? cluster.points.first
//}
//
//extension GeoModels.MultiPoint where Point == Point2D {
//	public var naiveCenter: Point { Turf.naiveCenter(for: self) }
//}
//
///// Returns the absolute center of a polygon.
/////
///// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center/index.ts#L36-L44>
//public func center(for coords: [Coordinate2D]) -> Coordinate2D? {
//	return bbox(forCollection: coords)?.center
//}
//
///// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
///// Used formula: [Centroid of Polygon](https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon)
/////
///// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
//public func centerOfMass(for coords: [Coordinate2D]) -> Coordinate2D {
//	// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
//	// We take any point to translate all the points around 0
//	let centre: Coordinate2D = centroid(for: coords)
//	let translation: Coordinate2D = centre
//	var sx: Double = 0
//	var sy: Double = 0
//	var sArea: Double = 0
//	
//	let neutralizedPoints: [Coordinate2D] = coords.map { $0 - translation }
//	
//	for i in 0..<coords.count - 1 {
//		// pi is the current point
//		let pi: Coordinate2D = neutralizedPoints[i]
//		let xi: Double = pi.longitude.decimalDegrees
//		let yi: Double = pi.latitude.decimalDegrees
//		
//		// pj is the next point (pi+1)
//		let pj: Coordinate2D = neutralizedPoints[i + 1]
//		let xj: Double = pj.longitude.decimalDegrees
//		let yj: Double = pj.latitude.decimalDegrees
//		
//		// a is the common factor to compute the signed area and the final coordinates
//		let a: Double = xi * yj - xj * yi
//		
//		// sArea is the sum used to compute the signed area
//		sArea += a
//		
//		// sx and sy are the sums used to compute the final coordinates
//		sx += (xi + xj) * a
//		sy += (yi + yj) * a
//	}
//	
//	// Shape has no area: fallback on turf.centroid
//	if (sArea == 0) {
//		return centre
//	} else {
//		// Compute the signed area, and factorize 1/6A
//		let area: Double = sArea * 0.5
//		let areaFactor: Double = 1 / (6 * area)
//		
//		// Compute the final coordinates, adding back the values that have been neutralized
//		return Coordinate2D(
//			latitude: translation.latitude + Latitude(areaFactor * sy),
//			longitude: translation.longitude + Longitude(areaFactor * sx)
//		)
//	}
//}
//
///// Calculates the centroid of a polygon using the mean of all vertices.
/////
///// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-centroid/index.ts#L21-L40>
//public func centroid(for coordinates: [Coordinate2D]) -> Coordinate2D {
//	var sumLongitude: Longitude = .zero
//	var sumLatitude: Latitude = .zero
//	
//	for coordinate in coordinates {
//		sumLongitude += coordinate.longitude
//		sumLatitude += coordinate.latitude
//	}
//	
//	return Coordinate2D(
//		latitude: sumLatitude / Latitude(coordinates.count),
//		longitude: sumLongitude / Longitude(coordinates.count)
//	)
//}
//
///// Calculates the signed area of a planar non-self-intersecting polygon
///// (not taking into account the curvature of the Earth).
/////
///// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
//public func plannarArea(for coordinates: [Coordinate2D]) -> Double {
//	guard let first = coordinates.first else { return 0 }
//	
//	var ring = coordinates
//	// Close the ring
//	if ring.last != first {
//		ring.append(first)
//	}
//	
//	var area: Double = 0
//	for (c1, c2) in ring.adjacentPairs() {
//		area += c1.x.decimalDegrees * c2.y.decimalDegrees - c2.x.decimalDegrees * c1.y.decimalDegrees
//	}
//	
//	return area / 2.0
//}
//
///// Calculates if a given polygon is clockwise or counter-clockwise.
/////
///// ```swift
///// var clockwiseRing = turf.lineString([[0,0],[1,1],[1,0],[0,0]]);
///// var counterClockwiseRing = turf.lineString([[0,0],[1,0],[1,1],[0,0]]);
/////
///// turf.booleanClockwise(clockwiseRing) // true
///// turf.booleanClockwise(counterClockwiseRing) // false
///// ```
/////
///// Ported from [Turf](https://github.com/Turfjs/turf/blob/d72985ce1a577b42340fed5fc70efe8e4bc8b062/packages/turf-boolean-clockwise/index.ts#L19-L35).
//public func isClockwise(_ coordinates: [Coordinate2D]) -> Bool {
//	return plannarArea(for: coordinates) > 0
//}
//
