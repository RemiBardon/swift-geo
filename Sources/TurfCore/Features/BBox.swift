//
//  BBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import SwiftGeoToolbox

// MARK: - Protocols

public protocol Boundable<CRS> {
	associatedtype CRS: CoordinateReferenceSystem
	var bbox: BoundingBox<CRS> { get }
}

public protocol BoundableCoordinates: Coordinates, Boundable {
	/// Returns new coordinates made with the minimum coordinate components.
	///
	/// Example:
	/// ```swift
	/// let min = Coordinate2D.makeMin(
	/// 	Coordinate2D(5, 10),
	/// 	Coordinate2D(3, 12)
	/// )
	/// assert(min == Coordinate2D(3, 10))
	/// ```
	static func makeMin(_ lhs: Self, _ rhs: Self) -> Self
	/// Returns new coordinates made with the maximum coordinate components.
	///
	/// Example:
	/// ```swift
	/// let max = Coordinate2D.makeMax(
	/// 	Coordinate2D(5, 10),
	/// 	Coordinate2D(3, 12)
	/// )
	/// assert(max == Coordinate2D(5, 12))
	/// ```
	static func makeMax(_ lhs: Self, _ rhs: Self) -> Self
	/// Returns new coordinates made with the minimum and maximum coordinate components.
	///
	/// Example:
	/// ```swift
	/// let (min, max) = Coordinate2D.makeMinAndMax([
	/// 	Coordinate2D(5, 10),
	/// 	Coordinate2D(3, 12),
	/// 	Coordinate2D(4, 15),
	/// 	Coordinate2D(2, 14),
	/// ])!
	/// assert(min == Coordinate2D(2, 10))
	/// assert(max == Coordinate2D(5, 15))
	/// ```
	static func makeMinAndMax<S: Collection<Self>>(_ coordinates: S) -> (Self, Self)?
}

public extension BoundableCoordinates {
	static func makeMinAndMax<S: Collection<Self>>(_ coordinates: S) -> (Self, Self)? {
		guard let first = coordinates.first else { return nil }

		var (min, max) = (first, first)
		for c in coordinates.dropFirst() {
			min = Self.makeMin(min, c)
			max = Self.makeMax(max, c)
		}

		return (min, max)
	}
}

extension BoundingBox where Self.Coordinates: BoundableCoordinates {
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: Self) -> Self {
		if let (min, max) = Self.Coordinates.makeMinAndMax([
			self.origin,
			other.origin,
			self.origin + self.size,
			other.origin + other.size
		]) {
			return Self.init(min: min, max: max)
		} else {
			return self
		}
	}
}

// MARK: - Functions

public func bbox<CRS>(forPoint point: Point<CRS>) -> BoundingBox<CRS> {
	return BoundingBox(origin: point.coordinates, size: .zero)
}

public func bbox<CRS, Iterator>(forIterator iterator: inout Iterator) -> BoundingBox<CRS>?
where Iterator: IteratorProtocol,
			Iterator.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	guard let element = iterator.next() else {
		return nil
	}
	var bbox = element.bbox
	while let element = iterator.next() {
		bbox = bbox.union(element.bbox)
	}
	return bbox
}

public func bbox<CRS, S>(
	forNonEmptyIterator iterator: inout NonEmptyIterator<S>
) -> BoundingBox<CRS>
where S.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	var bbox = iterator.first().bbox
	while let element = iterator.next() {
		bbox = bbox.union(element.bbox)
	}
	return bbox
}

public func bbox<CRS, C>(forIterable elements: C) -> BoundingBox<CRS>?
where C: Iterable,
			C.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	var iterator = elements.makeIterator()
	return bbox(forIterator: &iterator)
}

public func bbox<CRS, C>(forNonEmptyIterable elements: C) -> BoundingBox<CRS>
where C: NonEmptyIterable,
			C.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	var iterator = elements.makeIterator()
	return bbox(forIterator: &iterator) ?? iterator.first().bbox
}

// MARK: - Helpers

// MARK: Concepts

extension BoundingBox: Boundable {
	public var bbox: Self { self }
}

extension Coordinates {
	public var bbox: BoundingBox<CRS> {
		guard let origin = self as? CRS.Coordinates else {
			logger.error("""
			\(Self.self) was not \(CRS.Coordinates.self). \
			Make sure your `CoordinateReferenceSystem` was defined correctly.
			Recovering fatal error by returning `BoundingBox.zero`.
			""")
			return BoundingBox(origin: .zero, size: .zero)
		}
		return BoundingBox(origin: origin, size: .zero)
	}
}
extension Coordinates2DOf: Boundable {}
extension Coordinates3DOf: Boundable {}

// MARK: Shapes

extension Point: Boundable {
	public var bbox: BoundingBox<CRS> { TurfCore.bbox(forPoint: self) }
}

extension MultiPointProtocol
where Self.Points: Iterable,
			Self.CRS.Coordinates: BoundableCoordinates
{
	public var bbox: BoundingBox<CRS> {
		TurfCore.bbox(forIterable: self.points) ?? self.points.first.bbox
	}
}

extension MultiPoint: Boundable where Self.CRS.Coordinates: BoundableCoordinates {}
extension Line: Boundable where Self.CRS.Coordinates: BoundableCoordinates {}
extension MultiLine: Boundable where Self.CRS.Coordinates: BoundableCoordinates {}
extension LineString: Boundable where Self.CRS.Coordinates: BoundableCoordinates {}
extension LinearRing: Boundable where Self.CRS.Coordinates: BoundableCoordinates {}

// MARK: Iterable types

public extension Iterable
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	var bbox: BoundingBox<Self.Element.CRS>? {
		TurfCore.bbox(forIterable: self)
	}
}

public extension NonEmptyIterable
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	var bbox: BoundingBox<Self.Element.CRS> {
		TurfCore.bbox(forNonEmptyIterable: self)
	}
}

public extension Collection
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	var bbox: BoundingBox<Self.Element.CRS>? {
		self.isEmpty ? nil : self.reduce(.zero, { $0.union($1.bbox) })
	}
}

// MARK: - Implementations

extension Coordinates2DOf: BoundableCoordinates {
	public static func makeMin(_ lhs: Self, _ rhs: Self) -> Self {
		Self.init(
			x: min(lhs.x, rhs.x),
			y: min(lhs.y, rhs.y)
		)
	}
	public static func makeMax(_ lhs: Self, _ rhs: Self) -> Self {
		Self.init(
			x: max(lhs.x, rhs.x),
			y: max(lhs.y, rhs.y)
		)
	}
}

extension Coordinates3DOf: BoundableCoordinates {
	public static func makeMin(_ lhs: Self, _ rhs: Self) -> Self {
		Self.init(
			x: min(lhs.x, rhs.x),
			y: min(lhs.y, rhs.y),
			z: min(lhs.z, rhs.z)
		)
	}
	public static func makeMax(_ lhs: Self, _ rhs: Self) -> Self {
		Self.init(
			x: max(lhs.x, rhs.x),
			y: max(lhs.y, rhs.y),
			z: max(lhs.z, rhs.z)
		)
	}
}
