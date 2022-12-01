//
//  Vector.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public struct Vector<CRS: Geodesy.CoordinateReferenceSystem>:
	Hashable,
	SafeRawRepresentable,
	Zeroable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	InitializableByNumber
{
	public var rawValue: CRS.Coordinates
	public var components: CRS.Coordinates.Components {
		get { self.rawValue.components }
		set { self.rawValue = .init(components: newValue) }
	}

	public init(rawValue: CRS.Coordinates) {
		self.rawValue = rawValue
	}
	init(from: CRS.Coordinates, to: CRS.Coordinates) {
		self.init(rawValue: to - from)
	}
	init(from: Point<CRS>, to: Point<CRS>) {
		self.init(from: from.coordinates, to: to.coordinates)
	}
}

// Zeroable
public extension Vector {
	static var zero: Self { Self.init(rawValue: .zero) }
}

// AdditiveArithmetic
public extension Vector where RawValue: AdditiveArithmetic {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue + rhs.rawValue)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue - rhs.rawValue)
	}
}
// MultiplicativeArithmetic
public extension Vector where RawValue: MultiplicativeArithmetic {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue * rhs.rawValue)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue / rhs.rawValue)
	}
}

// InitializableByInteger
public extension Vector {
	init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(rawValue: .init(value))
	}
}
// InitializableByFloatingPoint
public extension Vector {
	init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(rawValue: .init(value))
	}
}

// MARK: - 2D

public extension Vector where RawValue: AtLeastTwoDimensionalCoordinates {
	typealias DX = Self.RawValue.X
	typealias DY = Self.RawValue.Y

	/// - Warning: In a geographic CRS, ``Vector2D/dx`` represents the vertical length,
	///   because ``Vector2D/DX`` represents the latitude (vertical axis).
	///   You can use ``Vector2D/verticalDelta`` to remove ambiguity.
	var dx: DX { self.rawValue.x }
	/// - Warning: In a geographic CRS, ``Vector2D/dy`` represents the horizontal length,
	///   because ``Vector2D/DY`` represents the longitude (horizontal axis).
	///   You can use ``Vector2D/horizontalDelta`` to remove ambiguity.
	var dy: DY { self.rawValue.y }

	var verticalDelta: DX { self.dx }
	var horizontalDelta: DY { self.dy }
}

// MARK: - 3D

public extension Vector where RawValue: AtLeastThreeDimensionalCoordinates {
	var dz: RawValue.Z { self.rawValue.z }
}

// MARK: - Extensions

public extension Coordinates where CRS.Coordinates == Self {
	static func + (lhs: Self, rhs: Vector<CRS>) -> Self {
		lhs + rhs.rawValue
	}
}
