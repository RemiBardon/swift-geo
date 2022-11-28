//
//  Boundable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry

public protocol Boundable<BoundingBox> {
	associatedtype BoundingBox: GeodeticGeometry.BoundingBox & Boundable

	var bbox: BoundingBox { get }

	func union(_ other: Self) -> Self
}

// MARK: - Default implementations

// MARK: Bounding box

extension GeodeticGeometry.BoundingBox {
	public var bbox: Self { self }
}

// MARK: Shapes

extension GeodeticGeometry.Point where Self.Coordinates: Boundable {
	public var bbox: Self.Coordinates.BoundingBox { self.coordinates.bbox }
}

// MARK: Iterable types

extension Iterable
where Self.Element: Boundable,
			Self.Element.BoundingBox.GeometricSystem: GeometricSystemAlgebra,
			Self.Element.BoundingBox == Self.Element.BoundingBox.GeometricSystem.BoundingBox
{
	public var bbox: Self.Element.BoundingBox? {
		Self.Element.BoundingBox.GeometricSystem.bbox(forIterable: self)
	}
}

extension NonEmptyIterable
where Self.Element: Boundable,
			Self.Element.BoundingBox.GeometricSystem: GeometricSystemAlgebra,
			Self.Element.BoundingBox == Self.Element.BoundingBox.GeometricSystem.BoundingBox
{
	public var bbox: Self.Element.BoundingBox {
		Self.Element.BoundingBox.GeometricSystem.bbox(forNonEmptyIterable: self)
	}
}

extension Sequence where Self.Element: Boundable, Self.Element.BoundingBox: Boundable {
	public var bbox: Self.Element.BoundingBox {
		self.reduce(.zero, { $0.union($1.bbox) })
	}
}
