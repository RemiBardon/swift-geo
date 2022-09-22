//
//  GeoModels+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels
import NonEmpty

// MARK: - Base protocol

public protocol CoordinateSystemAlgebra: GeoModels.CoordinateSystem {
	
	// MARK: Bounding box
	
	static func bbox(forPoint point: Self.Point) -> Self.BoundingBox
	
	/// Returns a naive [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
	static func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	
	/// Returns a naive [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
	static func naiveBBox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeoModels.MultiPoint,
				MultiPoint.Point == Self.Point
	
	/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Note: This implementation takes into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
	static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point

	/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Note: This implementation takes into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
	static func bbox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeoModels.MultiPoint,
				MultiPoint.Point == Self.Point

	// MARK: Center
	
	/// Returns the linear center of a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
	static func naiveCenter<Points: Collection>(forCollection points: Points) -> Self.Point?
	where Points.Element == Self.Point
	
	static func center(forBBox bbox: Self.BoundingBox) -> Self.Point

	// MARK: Centroid

	/// Calculates the centroid of a polygon using the mean of all vertices.
	static func naiveCentroid<Points: Collection>(forCollection points: Points) -> Self.Point?
	where Points.Element == Self.Point

	// MARK: Bézier

	static func bezier(
		forLineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString

}

// MARK: - Default implementations

public extension CoordinateSystemAlgebra {
	
	static func bbox(forPoint point: Self.Point) -> Self.BoundingBox {
		return Self.BoundingBox(origin: point, size: .zero)
	}
	
	static func naiveBBox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeoModels.MultiPoint,
				MultiPoint.Point == Self.Point
	{
		return self.naiveBBox(forCollection: multiPoint.points)
		?? self.bbox(forPoint: multiPoint.points.first)
	}
	
	static func bbox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeoModels.MultiPoint,
				MultiPoint.Point == Self.Point
	{
		return self.bbox(forCollection: multiPoint.points)
		?? self.bbox(forPoint: multiPoint.points.first)
	}
	
	static func naiveCenter<Points: Collection>(forCollection points: Points) -> Self.Point?
	where Points.Element == Self.Point
	{
		return Self.naiveBBox(forCollection: points)
			.flatMap(Self.center(forBBox:))
	}

	static func naiveCentroid<Points: Collection>(forCollection points: Points) -> Self.Point?
	where Points.Element == Self.Point
	{
		guard !points.isEmpty else { return nil }

		return points.sum() / points.count
	}

	static func pointAlong(line: Self.Line, fraction: Double) -> Self.Point {
		precondition((Double(0)...Double(1)).contains(fraction))
		return line.start + ((line.end - line.start) * fraction)
	}

	static func bezier(
		forLineString lineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString {
		let spline = CubicBezierSpline(points: lineString.points, sharpness: sharpness)
		let points: AtLeast2<[Self.Point]> = spline.curve(resolution: resolution)
		return Self.LineString(points: points)
	}
	
}

// MARK: Helper functions

public extension GeoModels.Point where CoordinateSystem: CoordinateSystemAlgebra {

	var bbox: Self.CoordinateSystem.BoundingBox {
		Self.CoordinateSystem.bbox(forPoint: self)
	}

}

public extension GeoModels.Line where CoordinateSystem: CoordinateSystemAlgebra {

	var naiveBBox: Self.CoordinateSystem.BoundingBox {
		Self.CoordinateSystem.naiveBBox(forMultiPoint: self)
	}

	var bbox: Self.CoordinateSystem.BoundingBox {
		Self.CoordinateSystem.bbox(forMultiPoint: self)
	}

	var naiveCenter: Self.Point {
		Self.CoordinateSystem.center(forBBox: self.naiveBBox)
	}

	var center: Self.Point {
		Self.CoordinateSystem.center(forBBox: self.bbox)
	}

}

public extension GeoModels.LineString where CoordinateSystem: CoordinateSystemAlgebra {

	var bbox: Self.CoordinateSystem.BoundingBox {
		Self.CoordinateSystem.bbox(forMultiPoint: self)
	}

	func bezier(sharpness: Double, resolution: Double) -> Self {
		// NOTE: For some reason, this does not compile without type casts.
		// Cannot convert return expression of type 'Self.CoordinateSystem.LineString' to return type 'Self'
		// Insert ' as! Self'
		// Cannot convert value of type 'Self' to expected argument type 'Self.CoordinateSystem.LineString'
		// Insert ' as! Self.CoordinateSystem.LineString'
		Self.CoordinateSystem.bezier(
			forLineString: self as! Self.CoordinateSystem.LineString,
			sharpness: sharpness,
			resolution: resolution
		) as! Self
	}

}

// MARK: - 2D

// MARK: Required methods

extension GeoModels.Geo2D: CoordinateSystemAlgebra {

	public static func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (south, north) = points.map(\.latitude).minAndMax(),
					let (west, east) = points.map(\.longitude).minAndMax()
		else { return nil }
		
		return Self.BoundingBox(
			southWest: Point2D(latitude: south, longitude: west),
			northEast: Point2D(latitude: north, longitude: east)
		)
	}

	public static func bbox<Points: Collection>(forCollection points: Points) ->  Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let bbox = Self.naiveBBox(forCollection: points) else { return nil }

		if bbox.width > .halfRotation {
			let offsetCoords = points.map(\.withPositiveLongitude)

			return Self.bbox(forCollection: offsetCoords)
		} else {
			return bbox
		}
	}
	
	public static func center(forBBox bbox: Self.BoundingBox) -> Self.Point {
		return Self.Point(
			x: bbox.origin.x + bbox.width / 2,
			y: bbox.origin.y + bbox.height / 2
		)
	}
	
}

// MARK: Specific methods

extension GeoModels.Geo2D {
	
	/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
	///
	/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
	public static func centerOfMass<Points: Collection>(forCollection points: Points) -> Point2D?
	where Points.Element == Point2D
	{
		// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
		// We take any point to translate all the points around 0
		guard let centre: Point2D = Self.naiveCentroid(forCollection: points) else { return nil }
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

	/// Calculates the signed area of a planar non-self-intersecting polygon
	/// (not taking into account the curvature of the Earth).
	///
	/// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
	public static func plannarArea<Points: Collection>(forCollection points: Points) -> Double
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
	public static func isClockwise<Points: Collection>(collection points: Points) -> Bool
	where Points.Element == Point2D
	{
		return Self.plannarArea(forCollection: points) > 0
	}

}

// MARK: - 3D

// MARK: Required methods

extension GeoModels.Geo3D: CoordinateSystemAlgebra {
	
	public static func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (south, north) = points.map(\.latitude).minAndMax(),
					let (west, east) = points.map(\.longitude).minAndMax(),
					let (low, high) = points.map(\.altitude).minAndMax()
		else { return nil }
		
		return Self.BoundingBox(
			southWestLow: Point3D(latitude: south, longitude: west, altitude: low),
			northEastHigh: Point3D(latitude: north, longitude: east, altitude: high)
		)
	}
	
	public static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let bbox = Self.naiveBBox(forCollection: points) else { return nil }
		
		if bbox.twoDimensions.width > .halfRotation {
			let offsetCoords = points.map(\.withPositiveLongitude)
			
			return Self.bbox(forCollection: offsetCoords)
		} else {
			return bbox
		}
	}
	
	public static func center(forBBox bbox: Self.BoundingBox) -> Self.Point {
		return Self.Point(
			x: bbox.origin.x + bbox.twoDimensions.width / 2,
			y: bbox.origin.y + bbox.twoDimensions.height / 2,
			z: bbox.origin.z + bbox.zHeight / 2
		)
	}
	
}
