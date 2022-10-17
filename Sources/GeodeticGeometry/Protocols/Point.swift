//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

@dynamicMemberLookup
public protocol Point<CRS>: Hashable, Zeroable, AdditiveArithmetic {

	associatedtype CRS: CoordinateReferenceSystem
	associatedtype Coordinates: Geodesy.Coordinates<CRS>

	var coordinates: Coordinates { get set }

	init(_ coordinates: Coordinates)

}

public extension Point {

	static var zero: Self { Self(.zero) }

	subscript<T>(dynamicMember keyPath: KeyPath<Coordinates, T>) -> T {
		self.coordinates[keyPath: keyPath]
	}

	// MARK: AdditiveArithmetic

	static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.coordinates + rhs.coordinates)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.coordinates - rhs.coordinates)
	}

}

public extension Point where Coordinates: TwoDimensionsCoordinate {
	func offsetBy(
		dx: Coordinates.X = .zero,
		dy: Coordinates.Y = .zero
	) -> Self {
		Self(self.coordinates.offsetBy(dx: dx, dy: dy))
	}
	func offsetBy(
		dLat: Coordinates.X = .zero,
		dLong: Coordinates.Y = .zero
	) -> Self where Coordinates.CRS: GeographicCRS {
		self.offsetBy(dx: dLat, dy: dLong)
	}
}

public extension Point where Coordinates: ThreeDimensionsCoordinate {
	func offsetBy(
		dx: Coordinates.X = .zero,
		dy: Coordinates.Y = .zero,
		dz: Coordinates.Z = .zero
	) -> Self {
		Self(self.coordinates.offsetBy(dx: dx, dy: dy, dz: dz))
	}
	func offsetBy(
		dLat: Coordinates.X = .zero,
		dLong: Coordinates.Y = .zero,
		dAlt: Coordinates.Z = .zero
	) -> Self where Coordinates.CRS: GeographicCRS {
		self.offsetBy(dx: dLat, dy: dLong, dz: dAlt)
	}
}

public struct PointOf<Coordinates: Geodesy.Coordinates>: Point {

	public typealias CRS = Coordinates.CRS

	public var coordinates: Coordinates

	public init(_ coordinates: Coordinates) {
		self.coordinates = coordinates
	}

}
