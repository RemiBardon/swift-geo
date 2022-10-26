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
	Hashable, SafeRawRepresentable, Zeroable, AdditiveArithmetic, MultiplicativeArithmetic
{
	typealias CRS = GeometricSystem.CRS
	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem

	init(rawValue: RawValue)
	init(from: GeometricSystem.Point, to: GeometricSystem.Point)
}

public extension Size where RawValue: Zeroable {
	static var zero: Self { Self.init(rawValue: .zero) }
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

public extension Size where RawValue: TwoDimensionsCoordinate {
	/// - Warning: In a geographic CRS, `width` represents the vertical length,
	///   because `RawValue.X` represents the latitude (vertical axis).
	var width: RawValue.X { self.rawValue.x }
	/// - Warning: In a geographic CRS, `height` represents the horizontal length,
	///   because `RawValue.Y` represents the longitude (horizontal axis).
	var height: RawValue.Y { self.rawValue.y }
}
