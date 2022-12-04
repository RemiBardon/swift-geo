//
//  Coordinates.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import SwiftGeoToolbox

// MARK: - Coordinates

public protocol Coordinates<CRS>:
	Hashable,
	Zeroable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	InitializableByNumber,
	CustomStringConvertible,
	CustomDebugStringConvertible
{
	associatedtype CRS: Geodesy.CoordinateReferenceSystem
	associatedtype Components

	var components: Components { get set }

	init(components: Components)
}

// CustomStringConvertible & CustomDebugStringConvertible
public extension Coordinates {
	var description: String { String(describing: self.components) }
	var debugDescription: String {
		"<\(Self.CRS.epsgName)>\(String(reflecting: self.components))"
	}
}

// MARK: 2D Coordinates

public protocol AtLeastTwoDimensionalCoordinates<CRS>: Geodesy.Coordinates
where CRS: AtLeastTwoDimensionalCRS {
	associatedtype X: CoordinateComponent
	associatedtype Y: CoordinateComponent

	var x: X { get set }
	var y: Y { get set }
}

public extension AtLeastTwoDimensionalCoordinates where X == Geodesy.Latitude {
	typealias Latitude = Geodesy.Latitude
	var latitude: Latitude { self.x }
}

public extension AtLeastTwoDimensionalCoordinates where Y == Geodesy.Longitude {
	typealias Longitude = Geodesy.Longitude
	var longitude: Longitude { self.y }
}

public protocol TwoDimensionalCoordinates<CRS>: AtLeastTwoDimensionalCoordinates
where Components == (X, Y) {
	init(x: X, y: Y)
}

public struct Coordinates2DOf<CRS>: TwoDimensionalCoordinates
where CRS: TwoDimensionalCRS
{
	public typealias X = CRS.CoordinateSystem.Axis1.Value
	public typealias Y = CRS.CoordinateSystem.Axis2.Value

	public var x: X
	public var y: Y

	public var components: (X, Y) {
		get { (self.x, self.y) }
		set {
			self.x = newValue.0
			self.y = newValue.1
		}
	}

	public init(x: X, y: Y) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
	}
	public init(components: (X, Y)) {
		self.init(x: components.0, y: components.1)
	}
}

// Zeroable
public extension Coordinates2DOf {
	static var zero: Self { Self.init(x: .zero, y: .zero) }
}

// AdditiveArithmetic
public extension Coordinates2DOf {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
}
// MultiplicativeArithmetic
public extension Coordinates2DOf {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}
}

// InitializableByInteger
public extension Coordinates2DOf {
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}
}
// InitializableByFloatingPoint
public extension Coordinates2DOf {
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}
}

public extension TwoDimensionalCoordinates where X == Latitude {
	var latitude: X { self.x }
}
public extension TwoDimensionalCoordinates where Y == Longitude {
	var longitude: Y { self.y }
	var withPositiveLongitude: Self {
		Self.init(x: self.x, y: self.longitude.positive)
	}
}
public extension TwoDimensionalCoordinates
where X == Latitude, Y == Longitude
{
	init(latitude: X, longitude: Y) {
		self.init(x: latitude, y: longitude)
	}
}

// MARK: 3D Coordinates

public protocol AtLeastThreeDimensionalCoordinates<CRS>: AtLeastTwoDimensionalCoordinates
where CRS: AtLeastTwoDimensionalCRS {
	associatedtype Z: CoordinateComponent

	var z: Z { get set }
}
public protocol ThreeDimensionalCoordinates<CRS>: AtLeastThreeDimensionalCoordinates
where Components == (X, Y, Z) {
	init(x: X, y: Y, z: Z)
}

public struct Coordinates3DOf<CRS: ThreeDimensionalCRS>: ThreeDimensionalCoordinates {
	public typealias X = CRS.CoordinateSystem.Axis1.Value
	public typealias Y = CRS.CoordinateSystem.Axis2.Value
	public typealias Z = CRS.CoordinateSystem.Axis3.Value

	public var x: X
	public var y: Y
	public var z: Z

	public var components: (X, Y, Z) {
		get { (self.x, self.y, self.z) }
		set {
			self.x = newValue.0
			self.y = newValue.1
			self.z = newValue.2
		}
	}

	public init(x: X, y: Y, z: Z) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
		self.z = z
	}
	public init(components: (X, Y, Z)) {
		self.init(x: components.0, y: components.1, z: components.2)
	}
}

// Zeroable
public extension Coordinates3DOf {
	static var zero: Self { Self.init(x: .zero, y: .zero, z: .zero) }
}

// AdditiveArithmetic
public extension Coordinates3DOf {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
	}
}
// MultiplicativeArithmetic
public extension Coordinates3DOf {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
	}
}

// InitializableByInteger
public extension Coordinates3DOf {
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}
}
// InitializableByFloatingPoint
public extension Coordinates3DOf {
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}
}

public extension ThreeDimensionalCoordinates where X == Latitude {
	var latitude: X { self.x }
}
public extension ThreeDimensionalCoordinates where Y == Longitude {
	var longitude: Y { self.y }
	var withPositiveLongitude: Self {
		Self.init(x: self.x, y: self.longitude.positive, z: self.z)
	}
}
public extension ThreeDimensionalCoordinates where Z == Altitude {
	var altitude: Z { self.z }
}

public extension ThreeDimensionalCoordinates
where X == Latitude, Y == Longitude, Z == Altitude
{
	init(latitude: X, longitude: Y, altitude: Z) {
		self.init(x: latitude, y: longitude, z: altitude)
	}
}
