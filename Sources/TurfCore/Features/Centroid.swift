//
//  Centroid.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import SwiftGeoToolbox

// MARK: - Functions

public func centroid<CRS, Iterator>(
	forIterator iterator: inout Iterator,
	crs: CRS.Type
) -> CRS.Coordinates?
where Iterator: IteratorProtocol,
			CRS: CoordinateReferenceSystem,
			Iterator.Element == CRS.Coordinates
{
	guard let element = iterator.next() else { return nil }
	var sum: CRS.Coordinates = element
	var count: Int = 0
	while let element = iterator.next() {
		sum += element
		count += 1
	}
	return sum / count
}

public func centroid<CRS, S>(
	forNonEmptyIterator iterator: inout NonEmptyIterator<S>,
	crs: CRS.Type
) -> CRS.Coordinates
where CRS: CoordinateReferenceSystem,
			S.Element == CRS.Coordinates
{
	var sum: CRS.Coordinates = iterator.first()
	var count: Int = 0
	while let element = iterator.next() {
		sum += element
		count += 1
	}
	return sum / count
}

public func centroid<CRS, C>(
	forIterable elements: C,
	crs: CRS.Type
) -> CRS.Coordinates?
where C: Iterable,
			CRS: CoordinateReferenceSystem,
			C.Element == CRS.Coordinates
{
	var iterator = elements.makeIterator()
	return TurfCore.centroid(forIterator: &iterator, crs: crs)
}

public func centroid<CRS, C>(
	forNonEmptyIterable elements: C,
	crs: CRS.Type
) -> CRS.Coordinates
where C: NonEmptyIterable,
			CRS: CoordinateReferenceSystem,
			C.Element == CRS.Coordinates
{
	var iterator = elements.makeIterator()
	return TurfCore.centroid(forIterator: &iterator, crs: CRS.self) ?? iterator.first()
}

public func centroid<C>(forCollection elements: C) -> C.Element?
where C: Collection,
			C.Element: Coordinates,
			C.Element == C.Element.CRS.Coordinates
{
	var iterator = elements.makeIterator()
	return TurfCore.centroid(forIterator: &iterator, crs: C.Element.CRS.self)
}

// MARK: - Helpers

// MARK: Iterable types

extension Iterable
where Self.Element: Coordinates,
			Self.Element == Self.Element.CRS.Coordinates
{
	public var centroid: Self.Element.CRS.Coordinates? {
		TurfCore.centroid(forIterable: self, crs: Self.Element.CRS.self)
	}
}

extension NonEmptyIterable
where Self.Element: Coordinates,
			Self.Element == Self.Element.CRS.Coordinates
{
	public var centroid: Self.Element.CRS.Coordinates {
		TurfCore.centroid(forNonEmptyIterable: self, crs: Self.Element.CRS.self)
	}
}

extension Collection
where Self.Element: Coordinates,
			Self.Element == Self.Element.CRS.Coordinates
{
	public var centroid: Self.Element.CRS.Coordinates? {
		var iterator = self.makeIterator()
		return TurfCore.centroid(forIterator: &iterator, crs: Self.Element.CRS.self)
	}
}
