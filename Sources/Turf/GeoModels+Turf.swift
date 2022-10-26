//
//  GeodeticGeometry+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty

// MARK: - Base protocol

public protocol GeometricSystemAlgebra: GeodeticGeometry.GeometricSystem {
	
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
	where MultiPoint: GeodeticGeometry.MultiPoint,
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
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point

	// MARK: Center
	
	/// Returns the linear center of a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
	static func naiveCenter<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
	where Points.Element == Self.Point
	
	static func center(forBBox bbox: Self.BoundingBox) -> Self.Coordinates

	// MARK: Centroid

	/// Calculates the centroid of a polygon using the mean of all vertices.
	static func naiveCentroid<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
	where Points.Element == Self.Point

	// MARK: Bézier

	static func bezier(
		forLineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString

}

// MARK: - Default implementations

public extension GeometricSystemAlgebra {
	
	static func bbox(forPoint point: Self.Point) -> Self.BoundingBox {
		return Self.BoundingBox(origin: point, size: .zero)
	}
	
	static func naiveBBox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point
	{
		return self.naiveBBox(forCollection: multiPoint.points)
		?? self.bbox(forPoint: multiPoint.points.first)
	}
	
	static func bbox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point
	{
		return self.bbox(forCollection: multiPoint.points)
		?? self.bbox(forPoint: multiPoint.points.first)
	}
	
	static func naiveCenter<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
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

	static func pointAlong(line: Self.Line, fraction: Double) -> Self.Coordinates {
		precondition((Double(0)...Double(1)).contains(fraction))
		return line.start.coordinates + fraction * line.vector.end.coordinates
	}

	static func bezier(
		forLineString lineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString {
		let spline = CubicBezierSpline(points: lineString.points, sharpness: sharpness)
		let points = AtLeast2<[Self.Point]>(
			rawValue: spline.curve(resolution: resolution).map(Self.Point.init(_:))
		)!
		return Self.LineString(points: points)
	}
	
}

// MARK: Helper functions

public extension GeodeticGeometry.Point where GeometricSystem: GeometricSystemAlgebra {

	var bbox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.bbox(forPoint: self)
	}

}

public extension GeodeticGeometry.Line where GeometricSystem: GeometricSystemAlgebra {

	var naiveBBox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.naiveBBox(forMultiPoint: self)
	}

	var bbox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.bbox(forMultiPoint: self)
	}

	var naiveCenter: Self.GeometricSystem.Coordinates {
		Self.GeometricSystem.center(forBBox: self.naiveBBox)
	}

	var naiveCenterPoint: Self.GeometricSystem.Point {
		.init(self.naiveCenter)
	}

	var center: Self.GeometricSystem.Coordinates {
		Self.GeometricSystem.center(forBBox: self.bbox)
	}

	var centerPoint: Self.GeometricSystem.Point {
		.init(self.center)
	}

}

public extension GeodeticGeometry.LineString where GeometricSystem: GeometricSystemAlgebra {

	var bbox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.bbox(forMultiPoint: self)
	}

	func bezier(sharpness: Double, resolution: Double) -> Self {
		// NOTE: For some reason, this does not compile without type casts.
		// Cannot convert return expression of type 'Self.GeometricSystem.LineString' to return type 'Self'
		// Insert ' as! Self'
		// Cannot convert value of type 'Self' to expected argument type 'Self.GeometricSystem.LineString'
		// Insert ' as! Self.GeometricSystem.LineString'
		Self.GeometricSystem.bezier(
			forLineString: self as! Self.GeometricSystem.LineString,
			sharpness: sharpness,
			resolution: resolution
		) as! Self
	}

}

// MARK: - 2D

// MARK: Required methods

public extension TwoDimensionsGeometricSystem {

	static func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (minX, maxX) = points.map(\.x).minAndMax(),
					let (minY, maxY) = points.map(\.y).minAndMax()
		else { return nil }

		return Self.BoundingBox(
			min: .init(.init(x: minX, y: minY)),
			max: .init(.init(x: maxX, y: maxY))
		)
	}

	static func bbox<Points: Collection>(forCollection points: Points) ->  Self.BoundingBox?
	where Points.Element == Self.Point,
				Self.BoundingBox.Size.RawValue: TwoDimensionsCoordinate
	{
		guard let bbox = Self.naiveBBox(forCollection: points) else { return nil }
		if bbox.size.width > .halfRotation {
			let offsetCoords = points.map(\.withPositiveLongitude)

			return Self.bbox(forCollection: offsetCoords)
		} else {
			return bbox
		}
	}
	
	static func center(forBBox bbox: Self.BoundingBox) -> Self.Coordinates {
		return bbox.origin.coordinates + bbox.size / 2
	}
	
}

// MARK: Specific methods

extension TwoDimensionsGeometricSystem {
	
	/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
	///
	/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
	public static func centerOfMass<Points: Collection>(forCollection points: Points) -> Self.Point?
	where Points.Element == Self.Point
	{
		// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
		// We take any point to translate all the points around 0
		guard let centre: Self.Coordinates = Self.naiveCentroid(forCollection: points) else { return nil }
		let translation: Self.Coordinates = centre
		var sx: Self.Coordinates.X = 0
		var sy: Self.Coordinates.Y = 0
		var sArea: Double = 0
		
		let neutralizedPoints: [Self.Coordinates] = points.map { $0 - translation }
		
		for i in 0..<points.count - 1 {
			// pi is the current point
			let pi: Self.Coordinates = neutralizedPoints[i]
			let xi: Self.Coordinates.X = pi.x
			let yi: Self.Coordinates.Y = pi.y
			
			// pj is the next point (pi+1)
			let pj: Self.Coordinates = neutralizedPoints[i + 1]
			let xj: Self.Coordinates.X = pj.x
			let yj: Self.Coordinates.Y = pj.y
			
			// a is the common factor to compute the signed area and the final coordinates
			let a: Double = xi.decimalDegrees * yj.decimalDegrees - xj.decimalDegrees * yi.decimalDegrees
			
			// sArea is the sum used to compute the signed area
			sArea += a
			
			// sx and sy are the sums used to compute the final coordinates
			sx += (xi + xj) * Self.Coordinates.X(a)
			sy += (yi + yj) * Self.Coordinates.Y(a)
		}
		
		// Shape has no area: fallback on turf.centroid
		if (sArea == 0) {
			return centre
		} else {
			// Compute the signed area, and factorize 1/6A
			let area: Double = sArea * 0.5
			let areaFactor: Double = 1 / (6 * area)
			
			// Compute the final coordinates, adding back the values that have been neutralized
			return Self.Point.init(
				x: translation.x + (Self.Point.X(areaFactor) * sx),
				y: translation.y + (Self.Point.Y(areaFactor) * sy)
			)
		}
	}

	/// Calculates the signed area of a planar non-self-intersecting polygon
	/// (not taking into account the curvature of the Earth).
	///
	/// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
	public static func plannarArea<Points: Collection>(forCollection points: Points) -> Double
	where Points.Element == Self.Point
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
	where Points.Element == Self.Point
	{
		return Self.plannarArea(forCollection: points) > 0
	}

}

// MARK: - 3D

// MARK: Required methods

extension ThreeDimensionsGeometricSystem {
	
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
		return Self.Point.init(
			x: bbox.origin.x + bbox.twoDimensions.width / 2,
			y: bbox.origin.y + bbox.twoDimensions.height / 2,
			z: bbox.origin.z + bbox.zHeight / 2
		)
	}
	
}
