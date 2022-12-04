//
//  GeographicBBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty
import SwiftGeoToolbox
import ValueWithUnit

//// MARK: - Implementations
//
//public func geographicBBox<CRS, Iterator>(forIterator iterator: inout Iterator) -> BoundingBox<CRS>?
//where Iterator: IteratorProtocol, Iterator.Element: Boundable<CRS>
//{
//	return bbox(forIterator: &iterator)
//}
//
//public func bbox<CRS, S>(
//	forNonEmptyIterator iterator: inout NonEmptyIterator<S>
//) -> BoundingBox<CRS>
//where S.Element: Boundable<CRS>
//{
//	var bbox = iterator.first().bbox
//	while let element = iterator.next() {
//		bbox = bbox.union(element.bbox)
//	}
//	return bbox
//}
//
//public func bbox<CRS, C>(forIterable elements: C) -> BoundingBox<CRS>?
//where C: Iterable, C.Element: Boundable<CRS>
//{
//	var iterator = elements.makeIterator()
//	return bbox(forIterator: &iterator)
//}
//
//public func bbox<CRS, C>(forNonEmptyIterable elements: C) -> BoundingBox<CRS>
//where C: NonEmptyIterable, C.Element: Boundable<CRS>
//{
//	var iterator = elements.makeIterator()
//	return bbox(forIterator: &iterator) ?? iterator.first().bbox
//}
//
//public func geographicBBox<CRS, C: Collection>(
//	forCollection coordinates: C
//) -> BoundingBox<CRS>?
//where C.Element == CRS.Coordinates
//{
//	return geographicBBox(forCollection: coordinates.map(Point<CRS>.init(coordinates:)))
//}
//
//public func geographicBBox<CRS, MultiPoint>(
//	forMultiPoint multiPoint: MultiPoint
//) -> BoundingBox<CRS>
//where MultiPoint: MultiPointProtocol,
//			MultiPoint.Point == Point<CRS>
//{
//	return geographicBBox(forIterable: multiPoint.points)
//	?? bbox(forPoint: multiPoint.points.first)
//}
//
//// MARK: - Helpers
//
//// MARK: Shapes
//
//extension Point where Self.Coordinates: Boundable {
//	public var geographicBBox: BoundingBox<CRS> { self.coordinates.bbox }
//}
//
//extension MultiPointProtocol: Boundable {
//	public var geographicBBox: BoundingBox<CRS> {
//		TurfCore.geographicBBox(forIterable: self.points)
//	}
//}
//
//public extension LineString {
//	var bbox: BoundingBox<CRS> {
//		bbox(forMultiPoint: self)
//	}
//}
//
//// MARK: Iterable types
//
//extension Iterable where Self.Element: Boundable {
//	public var bbox: BoundingBox<Self.Element.CRS>? {
//		TurfCore.bbox(forIterable: self)
//	}
//}
//
//extension NonEmptyIterable where Self.Element: Boundable {
//	public var bbox: BoundingBox<Self.Element.CRS> {
//		TurfCore.bbox(forNonEmptyIterable: self)
//	}
//}
//
//extension Sequence where Self.Element: Boundable, BoundingBox<Self.Element.CRS>: Boundable {
//	public var bbox: BoundingBox<Self.Element.CRS> {
//		self.reduce(.zero, { $0.union($1.bbox) })
//	}
//}

// MARK: - Implementations

public extension MultiPoint
where CRS.Coordinates: TwoDimensionalCoordinates & BoundableCoordinates,
			CRS.Coordinates.Y == Geodesy.Longitude,
			Point.Coordinates == CRS.Coordinates
{
	var geographicBBox: BoundingBox<CRS>? {
		guard let bbox = self.bbox else { return nil }

		if bbox.size.horizontalDelta > .halfRotation {
			let offsetCoords: [CRS.Coordinates] = self.points.map(\.coordinates.withPositiveLongitude)
			return TurfCore.bbox(forIterable: offsetCoords)
		} else {
			return bbox
		}
	}
}

public extension MultiPoint
where CRS.Coordinates: ThreeDimensionalCoordinates & BoundableCoordinates,
			CRS.Coordinates.Y == Geodesy.Longitude,
			Point.Coordinates == CRS.Coordinates
{
	var geographicBBox: BoundingBox<CRS>? {
		guard let bbox = self.bbox else { return nil }

		if bbox.size.horizontalDelta > .halfRotation {
			let offsetCoords: [CRS.Coordinates] = self.points.map(\.coordinates.withPositiveLongitude)
			return TurfCore.bbox(forIterable: offsetCoords)
		} else {
			return bbox
		}
	}
}

//public extension TwoDimensionalGeometricSystem {
//	static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
//	where Points.Element == Self.Point
//	{
//		guard let (minX, maxX) = points.map(\.x).minAndMax(),
//					let (minY, maxY) = points.map(\.y).minAndMax()
//		else { return nil }
//
//		return Self.BoundingBox(
//			min: .init(x: minX, y: minY),
//			max: .init(x: maxX, y: maxY)
//		)
//	}
//}
//
//#warning("TODO: Merge this implementations with the 3D version.")
//public extension TwoDimensionalGeometricSystem
//where Self.CRS: GeographicCRS,
//// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
////       results in a compiler error.
//Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent,
//Self.Size.DY: AngularCoordinateComponent
//{
//	static func geographicBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
//	where Points.Element == Self.Point,
//				Self.BoundingBox.Size.RawValue: TwoDimensionalCoordinate
//	{
//		guard let bbox = Self.bbox(forCollection: points) else { return nil }
//		if bbox.size.horizontalDelta > .halfRotation {
//			let offsetCoords: [Point] = points.map(\.withPositiveLongitude)
//
//			return Self.bbox(forCollection: offsetCoords)
//		} else {
//			return bbox
//		}
//	}
//}
//
//extension ThreeDimensionalGeometricSystem {
//	public static func bbox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
//	where Points.Element == Self.Point
//	{
//		guard let (minX, maxX) = points.map(\.x).minAndMax(),
//					let (minY, maxY) = points.map(\.y).minAndMax(),
//					let (minZ, maxZ) = points.map(\.z).minAndMax()
//		else { return nil }
//
//		return Self.BoundingBox(
//			min: Self.Coordinates(rawValue: (minX, minY, minZ)),
//			max: Self.Coordinates(rawValue: (maxX, maxY, maxZ))
//		)
//	}
//}
//
//public extension ThreeDimensionalGeometricSystem
//where Self.CRS: GeographicCRS,
//// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
////       results in a compiler error.
//Self.CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent,
//Self.Size.DY: AngularCoordinateComponent
//{
//	static func geographicBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
//	where Points.Element == Self.Point,
//				Self.BoundingBox.Size.RawValue: ThreeDimensionalCoordinate
//	{
//		guard let bbox = Self.bbox(forCollection: points) else { return nil }
//		if bbox.size.horizontalDelta > .halfRotation {
//			let offsetCoords: [Point] = points.map(\.withPositiveLongitude)
//
//			return Self.bbox(forCollection: offsetCoords)
//		} else {
//			return bbox
//		}
//	}
//}
