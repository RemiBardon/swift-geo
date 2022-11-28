//
//  GeodeticGeometry+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty
import SwiftGeoToolbox
import ValueWithUnit

// MARK: - Default `GeometricSystemAlgebra` implementations

public extension GeometricSystemAlgebra {

	static func bbox(forPoint point: Self.Point) -> Self.BoundingBox {
		Self.BoundingBox(origin: point.coordinates, size: .zero)
	}

	static func bbox<Iterator>(forIterator iterator: inout Iterator) -> Self.BoundingBox?
	where Iterator: IteratorProtocol, Iterator.Element: Boundable<Self.BoundingBox>
	{
		guard let element = iterator.next() else {
			return nil
		}
		var bbox: Self.BoundingBox = element.bbox
		while let element = iterator.next() {
			bbox = bbox.union(element.bbox)
		}
		return bbox
	}

	static func bbox<S>(
		forNonEmptyIterator iterator: inout NonEmptyIterator<S>
	) -> Self.BoundingBox
	where S.Element: Boundable<Self.BoundingBox>
	{
		var bbox: Self.BoundingBox = iterator.first().bbox
		while let element = iterator.next() {
			bbox = bbox.union(element.bbox)
		}
		return bbox
	}

	static func bbox<C>(forIterable elements: C) -> Self.BoundingBox?
	where C: Iterable, C.Element: Boundable<Self.BoundingBox>
	{
		var iterator = elements.makeIterator()
		return Self.bbox(forIterator: &iterator)
	}

	static func bbox<C>(forNonEmptyIterable elements: C) -> Self.BoundingBox
	where C: NonEmptyIterable, C.Element: Boundable<Self.BoundingBox>
	{
		var iterator = elements.makeIterator()
		return Self.bbox(forIterator: &iterator) ?? iterator.first().bbox
	}

	static func geographicBBox<C: Collection>(forCollection coordinates: C) -> Self.BoundingBox?
	where C.Element == Self.Coordinates
	{
		return Self.geographicBBox(forCollection: coordinates.map(Self.Point.init(coordinates:)))
	}
	
	static func geographicBBox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point
	{
		return self.geographicBBox(forCollection: multiPoint.points)
			?? self.bbox(forPoint: multiPoint.points.first)
	}


	static func center<C>(forIterable elements: C) -> Self.Coordinates?
	where C: Iterable, C.Element == Self.Point
	{
		Self.bbox(forIterable: elements).flatMap(Self.center(forBBox:))
	}

	static func centroid<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
	where Points.Element == Self.Point
	{
		guard !points.isEmpty else { return nil }
		return points.sum().coordinates / .init(points.count)
	}

	static func pointAlong(line: Self.Line, fraction: Double) -> Self.Coordinates {
		precondition((Double(0.0)...Double(1.0)).contains(fraction))
		return line.start.coordinates + fraction * line.vector.end.coordinates
	}

	static func bezier(
		forLineString lineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString {
		let spline = CubicBezierSpline<Self>(points: lineString.points, sharpness: sharpness)
		let points = AtLeast2<[Self.Point]>(
			rawValue: spline.curve(resolution: resolution).map(Self.Point.init(coordinates:))
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

	var bbox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.bbox(forMultiPoint: self)
	}

	var geographicBBox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.geographicBBox(forMultiPoint: self)
	}

	var center: Self.GeometricSystem.Coordinates {
		Self.GeometricSystem.center(forBBox: self.bbox)
	}

	var centerPoint: Self.GeometricSystem.Point {
		.init(coordinates: self.center)
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

public extension TwoDimensionalGeometricSystem {

	static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (minX, maxX) = points.map(\.x).minAndMax(),
					let (minY, maxY) = points.map(\.y).minAndMax()
		else { return nil }

		return Self.BoundingBox(
			min: .init(x: minX, y: minY),
			max: .init(x: maxX, y: maxY)
		)
	}
	
}

#warning("TODO: Merge this implementations with the 3D version.")
public extension TwoDimensionalGeometricSystem
where Self.CRS: GeographicCRS,
			// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
			//       results in a compiler error.
			Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent,
			Self.Size.DY: AngularCoordinateComponent
{
	static func geographicBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point,
				Self.BoundingBox.Size.RawValue: TwoDimensionalCoordinate
	{
		guard let bbox = Self.bbox(forCollection: points) else { return nil }
		if bbox.size.horizontalDelta > .halfRotation {
			let offsetCoords: [Point] = points.map(\.withPositiveLongitude)

			return Self.bbox(forCollection: offsetCoords)
		} else {
			return bbox
		}
	}
}

// MARK: Specific methods

extension TwoDimensionalGeometricSystem where Self: GeometricSystemAlgebra {
	
	/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
	///
	/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
	///
	/// - Note: This code is not very clean, but Compile Time Optimizations have been added to reduce
	///         type checking from `>500ms` to `<50ms`.
	public static func centerOfMass<Points: Collection>(
		forCollection points: Points
	) -> Self.Coordinates?
	where Points.Element == Self.Point,
				Self.Point.CRS.CoordinateSystem: TwoDimensionalCS,
				Self.Point.CRS.CoordinateSystem.Axis1.Value: AngularCoordinateComponent,
				Self.Point.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent
	{
		// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
		// We take any point to translate all the points around 0
		guard let centre: Self.Coordinates = Self.centroid(forCollection: points) else { return nil }
		let translation: Self.Coordinates = centre
		var sx: Self.Coordinates.X = 0
		var sy: Self.Coordinates.Y = 0
		var sArea: Double = 0
		
		let neutralizedPoints: [Self.Coordinates] = points.map { $0.coordinates - translation }
		
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
			let __sx1 = (xi + xj)
			let __sx2 = __sx1 * Self.Coordinates.X(decimalDegrees: a)
			sx += __sx2
			let __sy1 = (yi + yj)
			let __sy2 = __sy1 * Self.Coordinates.Y(decimalDegrees: a)
			sy += __sy2
		}
		
		// Shape has no area: fallback on turf.centroid
		if (sArea == 0) {
			return centre
		} else {
			// Compute the signed area, and factorize 1/6A
			let area: Double = sArea * 0.5
			let areaFactor: Double = 1 / (6 * area)
			
			// Compute the final coordinates, adding back the values that have been neutralized
			let dx = Self.Coordinates.X(decimalDegrees: areaFactor) * sx
			let dy = Self.Coordinates.Y(decimalDegrees: areaFactor) * sy
			return translation.offsetBy(dx: dx, dy: dy)
		}
	}

	/// Calculates the signed area of a planar non-self-intersecting polygon
	/// (not taking into account the curvature of the Earth).
	///
	/// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
	public static func plannarArea<Points: Collection>(forCollection points: Points) -> Double
	where Points.Element == Self.Point,
				// NOTE: For some reason, replacing `Self.CRS.CoordinateSystem.Axis1.Value`
				//       by `Self.Coordinates.X` results in a compiler error.
				Self.CRS.CoordinateSystem.Axis1.Value: AngularCoordinateComponent,
				// NOTE: For some reason, replacing `Self.CRS.CoordinateSystem.Axis2.Value`
				//       by `Self.Coordinates.Y` results in a compiler error.
				Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent
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
	where Points.Element == Self.Point,
				// NOTE: For some reason, replacing `Self.CRS.CoordinateSystem.Axis1.Value`
				//       by `Self.Coordinates.X` results in a compiler error.
				Self.CRS.CoordinateSystem.Axis1.Value: AngularCoordinateComponent,
				// NOTE: For some reason, replacing `Self.CRS.CoordinateSystem.Axis2.Value`
				//       by `Self.Coordinates.Y` results in a compiler error.
				Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent
	{
		return Self.plannarArea(forCollection: points) > 0
	}

}

// MARK: - 3D

// MARK: Required methods

extension ThreeDimensionalGeometricSystem {
	
	public static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (minX, maxX) = points.map(\.x).minAndMax(),
					let (minY, maxY) = points.map(\.y).minAndMax(),
					let (minZ, maxZ) = points.map(\.z).minAndMax()
		else { return nil }

		return Self.BoundingBox(
			min: Self.Coordinates(rawValue: (minX, minY, minZ)),
			max: Self.Coordinates(rawValue: (maxX, maxY, maxZ))
		)
	}
	
	public static func center(forBBox bbox: Self.BoundingBox) -> Self.Coordinates
	where Self.Size.RawValue == Self.Coordinates
	{
		return bbox.origin.offsetBy(
			dx: bbox.size.dx / 2,
			dy: bbox.size.dy / 2,
			dz: bbox.size.dz / 2
		)
	}
	
}

public extension ThreeDimensionalGeometricSystem
where Self.CRS: GeographicCRS,
			// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
			//       results in a compiler error.
			Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent,
			Self.Size.DY: AngularCoordinateComponent
{
	static func geographicBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point,
				Self.BoundingBox.Size.RawValue: ThreeDimensionalCoordinate
	{
		guard let bbox = Self.bbox(forCollection: points) else { return nil }
		if bbox.size.horizontalDelta > .halfRotation {
			let offsetCoords: [Point] = points.map(\.withPositiveLongitude)

			return Self.bbox(forCollection: offsetCoords)
		} else {
			return bbox
		}
	}
}
