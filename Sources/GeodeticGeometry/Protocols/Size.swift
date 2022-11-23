//
//  Size.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public protocol Size<GeometricSystem>:
	Hashable,
	SafeRawRepresentable,
	Zeroable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	InitializableByNumber
{
	typealias CRS = GeometricSystem.CRS
	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem

	init(from: GeometricSystem.Point, to: GeometricSystem.Point)
}

public extension Size where RawValue: Zeroable {
	static var zero: Self { Self.init(rawValue: .zero) }
}

public extension Size where RawValue: InitializableByInteger {
	init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(rawValue: .init(value))
	}
}

public extension Size where RawValue: InitializableByFloatingPoint {
	init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(rawValue: .init(value))
	}
}

public extension Size where RawValue == GeometricSystem.Point.Coordinates {
	init(from: GeometricSystem.Point, to: GeometricSystem.Point) {
		self.init(rawValue: to.coordinates - from.coordinates)
	}
}

public extension Size where RawValue: AdditiveArithmetic {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue + rhs.rawValue)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue - rhs.rawValue)
	}
}

public extension Size where RawValue: MultiplicativeArithmetic {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue * rhs.rawValue)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue / rhs.rawValue)
	}
}

// MARK: - 2D

public extension Size where RawValue: AtLeastTwoDimensionalCoordinate {
	var dx: RawValue.X { self.rawValue.x }
	var dy: RawValue.Y { self.rawValue.y }

	/// - Warning: In a geographic CRS, ``Size2D/width`` represents the vertical length,
	///   because ``Size2D/DX`` represents the latitude (vertical axis).
	///   You can use ``Size2D/horizontalDelta`` to remove ambiguity.
	var width: RawValue.X { self.dx }
	/// - Warning: In a geographic CRS, ``Size2D/height`` represents the horizontal length,
	///   because ``Size2D/DY`` represents the longitude (horizontal axis).
	///   You can use ``Size2D/horizontalDelta`` to remove ambiguity.
	var height: RawValue.Y { self.dy }

	var verticalDelta: RawValue.X { self.dx }
	var horizontalDelta: RawValue.Y { self.dy }
}

public protocol Size2D<GeometricSystem>: Size {
	associatedtype DX: CoordinateComponent
	associatedtype DY: CoordinateComponent

	/// - Warning: In a geographic CRS, ``Size2D/dx`` represents the vertical length,
	///   because ``Size2D/DX`` represents the latitude (vertical axis).
	///   You can use ``Size2D/verticalDelta`` to remove ambiguity.
	var dx: DX { get }
	/// - Warning: In a geographic CRS, ``Size2D/dy`` represents the horizontal length,
	///   because ``Size2D/DY`` represents the longitude (horizontal axis).
	///   You can use ``Size2D/horizontalDelta`` to remove ambiguity.
	var dy: DY { get }

	var verticalDelta: DX { get }
	var horizontalDelta: DY { get }
}

public extension Size2D {
	var verticalDelta: DX { self.dx }
	var horizontalDelta: DY { self.dy }
}

// MARK: - 3D

public extension Size where RawValue: AtLeastThreeDimensionalCoordinate {
	var dz: RawValue.Z { self.rawValue.z }
	var zHeight: RawValue.Z { self.dz }
}

public protocol Size3D<GeometricSystem>: Size2D {
	associatedtype DZ: CoordinateComponent
	var dz: DZ { get }
}
