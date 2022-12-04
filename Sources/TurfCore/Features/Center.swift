//
//  Center.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import SwiftGeoToolbox

// MARK: - Functions

public func center<CRS, Iterator>(forIterator iterator: inout Iterator) -> CRS.Coordinates?
where Iterator: IteratorProtocol,
			Iterator.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	TurfCore.bbox(forIterator: &iterator)?.center
}

public func center<CRS, S>(
	forNonEmptyIterator iterator: inout NonEmptyIterator<S>
) -> CRS.Coordinates
where S.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	TurfCore.bbox(forNonEmptyIterator: &iterator).center
}

public func center<CRS, C>(forIterable elements: C) -> CRS.Coordinates?
where C: Iterable,
			C.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	TurfCore.bbox(forIterable: elements)?.center
}

public func center<CRS, C>(forNonEmptyIterable elements: C) -> CRS.Coordinates
where C: NonEmptyIterable,
			C.Element: Boundable<CRS>,
			CRS.Coordinates: BoundableCoordinates
{
	TurfCore.bbox(forNonEmptyIterable: elements).center
}

// MARK: - Helpers

// MARK: Concepts

public extension Vector {
	var center: CRS.Coordinates { self.half.rawValue }
}

// MARK: Shapes

public extension Line {
	var center: CRS.Coordinates {
		self.start.coordinates + Vector(from: self.start, to: self.end).half
	}
}

// MARK: Iterable types

extension Iterable
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	public var center: Self.Element.CRS.Coordinates? { self.bbox?.center }
}

extension NonEmptyIterable
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	public var center: Self.Element.CRS.Coordinates { self.bbox.center }
}

extension Collection
where Self.Element: Boundable,
			Self.Element.CRS.Coordinates: BoundableCoordinates
{
	public var center: Self.Element.CRS.Coordinates? { self.bbox?.center }
}
