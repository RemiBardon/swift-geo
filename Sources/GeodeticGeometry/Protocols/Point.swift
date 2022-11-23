//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

//public protocol Coordinates<GeometricSystem>: Geodesy.Coordinates {
//	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem<GeometricSystem.CRS>
//	where GeometricSystem.Coordinates == Self
//}

public protocol Point<GeometricSystem>:
	Hashable,
	SafeRawRepresentable,
	Zeroable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	InitializableByNumber
{
	typealias CRS = GeometricSystem.CRS
	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem<CRS>
	where GeometricSystem.Point == Self
	associatedtype Coordinates: Geodesy.Coordinates<CRS>

	var coordinates: Coordinates { get set }

	init(coordinates: Coordinates)

	func offsetBy(_ size: GeometricSystem.Size) -> Self
}

public extension Point {

	// MARK: Zeroable

	static var zero: Self { Self.init(coordinates: .zero) }

	// MARK: RawRepresentable

	var rawValue: Self.Coordinates.RawValue {
		self.coordinates.rawValue
	}

	init(rawValue: Self.Coordinates.RawValue) {
		self.init(coordinates: .init(rawValue: rawValue))
	}

	// MARK: AdditiveArithmetic

	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates + rhs.coordinates)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates - rhs.coordinates)
	}

	// MARK: MultiplicativeArithmetic

	static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(coordinates: lhs.coordinates * rhs.coordinates)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		return Self.init(coordinates: lhs.coordinates / rhs.coordinates)
	}

	// MARK: InitializableByNumber

	init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(coordinates: .init(value))
	}
	init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(coordinates: .init(value))
	}

}

public extension Point where Coordinates: AtLeastTwoDimensionalCoordinate {
	var x: Self.Coordinates.X { self.coordinates.x }
	var y: Self.Coordinates.Y { self.coordinates.y }
}

public extension Point
where Coordinates: AtLeastTwoDimensionalCoordinate,
			CRS: GeographicCRS
{
	var latitude: Coordinates.X { self.coordinates.x }
	var longitude: Coordinates.Y { self.coordinates.y }
}

public extension Point where Coordinates: TwoDimensionalCoordinate {
	func offsetBy(
		dx: Coordinates.X = .zero,
		dy: Coordinates.Y = .zero
	) -> Self {
		Self.init(coordinates: self.coordinates.offsetBy(dx: dx, dy: dy))
	}
	func offsetBy(
		dLat: Coordinates.X = .zero,
		dLong: Coordinates.Y = .zero
	) -> Self where Coordinates.CRS: GeographicCRS {
		self.offsetBy(dx: dLat, dy: dLong)
	}
}

public extension Point
where Coordinates: TwoDimensionalCoordinate,
			CRS: GeographicCRS
{
	init(latitude: Coordinates.X, longitude: Coordinates.Y) {
		self.init(coordinates: .init(x: latitude, y: longitude))
	}
}

public extension Point
where Coordinates: TwoDimensionalCoordinate,
			CRS: GeographicCRS,
			// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
			//       results in a compiler error.
			CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent
{
	var withPositiveLongitude: Self {
		Self.init(latitude: self.latitude, longitude: self.longitude.positive)
	}
}

public extension Point
where Coordinates: TwoDimensionalCoordinate,
			GeometricSystem.Size.RawValue == Coordinates
{
	func offsetBy(_ size: GeometricSystem.Size) -> Self {
		self.offsetBy(dx: size.dx, dy: size.dy)
	}
}

public extension Point where Coordinates: AtLeastThreeDimensionalCoordinate {
	var z: Self.Coordinates.Z { self.coordinates.z }
}

public extension Point
where Coordinates: AtLeastThreeDimensionalCoordinate,
			CRS: GeographicCRS
{
	var altitude: Coordinates.Z { self.coordinates.z }
}

public extension Point where Coordinates: ThreeDimensionalCoordinate {
	func offsetBy(
		dx: Coordinates.X = .zero,
		dy: Coordinates.Y = .zero,
		dz: Coordinates.Z = .zero
	) -> Self {
		Self.init(coordinates: self.coordinates.offsetBy(dx: dx, dy: dy, dz: dz))
	}
	func offsetBy(
		dLat: Coordinates.X = .zero,
		dLong: Coordinates.Y = .zero,
		dAlt: Coordinates.Z = .zero
	) -> Self where Coordinates.CRS: GeographicCRS {
		self.offsetBy(dx: dLat, dy: dLong, dz: dAlt)
	}
}

public extension Point
where Coordinates: ThreeDimensionalCoordinate,
			CRS: GeographicCRS
{
	init(latitude: Coordinates.X, longitude: Coordinates.Y, altitude: Coordinates.Z) {
		self.init(coordinates: .init(x: latitude, y: longitude, z: altitude))
	}
}

public extension Point
where Coordinates: ThreeDimensionalCoordinate,
			CRS: GeographicCRS,
			// NOTE: For some reason, replacing `CRS.CoordinateSystem.Axis2.Value` by `Self.Coordinates.Y`
			//       results in a compiler error.
			CRS.CoordinateSystem.Axis2.Value: AngularCoordinateComponent
{
	var withPositiveLongitude: Self {
		Self.init(latitude: self.latitude, longitude: self.longitude.positive, altitude: self.altitude)
	}
}

public extension Point
where Coordinates: ThreeDimensionalCoordinate,
			GeometricSystem.Size.RawValue == Coordinates
{
	func offsetBy(_ size: GeometricSystem.Size) -> Self {
		self.offsetBy(dx: size.dx, dy: size.dy, dz: size.dz)
	}
}
