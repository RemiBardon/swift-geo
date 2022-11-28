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

#warning("TODO: Replace all the `bbox` by one or two using `Boundable`")

public protocol GeometricSystemAlgebra: GeodeticGeometry.GeometricSystem {

	// MARK: Bounding box

	static func bbox(forPoint point: Self.Point) -> Self.BoundingBox

	/// Returns a naive [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of geometrical elements.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
	static func bbox<C>(forCollection elements: C) -> Self.BoundingBox?
	where C: Collection, C.Element: Boundable

	/// Returns a naive [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of geometrical elements.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
	static func bbox<C>(forNonEmptyCollection elements: C) -> Self.BoundingBox
	where C: NonEmptyProtocol, C.Element: Boundable

	/// Returns a naive [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 0°E).
	static func bbox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point

	/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Note: This implementation takes into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
	static func geographicBBox<C: Collection>(forCollection coordinates: C) -> Self.BoundingBox?
	where C.Element == Self.Coordinates

	/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Note: This implementation takes into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
	static func geographicBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point

	/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box)
	/// enclosing a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Note: This implementation takes into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a bounding box around 0°N 180°E).
	static func geographicBBox<MultiPoint>(forMultiPoint multiPoint: MultiPoint) -> Self.BoundingBox
	where MultiPoint: GeodeticGeometry.MultiPoint,
				MultiPoint.Point == Self.Point

	// MARK: Center

	/// Returns the linear center of a cluster of points.
	/// - Warning: This does not take into account the curvature of the Earth.
	/// - Warning: This is a naive implementation, not taking into account the angular coordinate system
	///   (i.e. a cluster around 0°N 180°E will have a center near 0°N 0°E).
	static func center<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
	where Points.Element == Self.Point

	static func center(forBBox bbox: Self.BoundingBox) -> Self.Coordinates

	// MARK: Centroid

	/// Calculates the centroid of a polygon using the mean of all vertices.
	static func centroid<Points: Collection>(forCollection points: Points) -> Self.Coordinates?
	where Points.Element == Self.Point

	// MARK: Bézier

	static func bezier(
		forLineString: Self.LineString,
		sharpness: Double,
		resolution: Double
	) -> Self.LineString

}
