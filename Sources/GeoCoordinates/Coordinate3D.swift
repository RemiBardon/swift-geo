//
//  Coordinate3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Coordinate3D<X, Y, Z>: Coordinates, CompoundDimension {

	associatedtype X: Coordinate
	associatedtype Y: Coordinate
	associatedtype Z: Coordinate

	var x: X { get set }
	var y: Y { get set }
	var z: Z { get set }

	init(x: X, y: Y, z: Z)

	func offsetBy(dx: X, dy: Y, dz: Z) -> Self

}

public extension Coordinate3D {

	func offsetBy(dx: X = .zero, dy: Y = .zero, dz: Z = .zero) -> Self {
		self.offsetBy(dx: dx, dy: dy, dz: dz)
	}

}

public struct WGS84Coordinate3D: Coordinate3D {
	
	public typealias X = Longitude
	public typealias Y = Latitude
	public typealias Z = Altitude
	
	public static var zero: Self {
		Self.init(latitude: .zero, longitude: .zero, altitude: .zero)
	}
	
	public var latitude: Latitude
	public var longitude: Longitude
	public var altitude: Altitude

	public var x: X {
		get { longitude }
		set { longitude = newValue }
	}
	public var y: Y {
		get { latitude }
		set { latitude = newValue }
	}
	public var z: Z {
		get { altitude }
		set { altitude = newValue }
	}

	public var withPositiveLongitude: Self {
		Self.init(latitude: latitude, longitude: longitude.positive, altitude: altitude)
	}
	
	public init(
		latitude: Latitude,
		longitude: Longitude,
		altitude: Altitude
	) {
		self.latitude = latitude
		self.longitude = longitude
		self.altitude = altitude
	}
	
	public init(x: X, y: Y, z: Z) {
		self.init(latitude: y, longitude: x, altitude: z)
	}
	
	public init(_ coordinate2d: WGS84Coordinate2D, altitude: Altitude = .zero) {
		self.init(latitude: coordinate2d.latitude, longitude: coordinate2d.longitude, altitude: altitude)
	}
	
	public func offsetBy(dLat: Latitude = .zero, dLong: Longitude = .zero, dAlt: Altitude = .zero) -> Self {
		Self.init(
			latitude: latitude + dLat,
			longitude: longitude + dLong,
			altitude: altitude + dAlt
		)
	}
	public func offsetBy(dx: X, dy: Y, dz: Z) -> Self {
		Self.init(x: x + dx, y: y + dy, z: z + dz)
	}
	
}

// MARK: - Operators

/// ``Foundation/AdditiveArithmetic``
extension Coordinate3D {
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return lhs.offsetBy(dx: rhs.x, dy: rhs.y, dz: rhs.z)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return lhs + (-rhs)
	}
	
}

extension Coordinate3D {
	
	public prefix static func - (value: Self) -> Self {
		return Self.init(
			x: -value.x,
			y: -value.y,
			z: -value.z
		)
	}
	
}

// MARK: - Protocol conformances

/// ``GeoCoordinates/CompoundDimension``
extension WGS84Coordinate3D {
	
	public typealias LowerDimension = WGS84Coordinate2D
	
	public var lowerDimension: Self.LowerDimension {
		LowerDimension(latitude: latitude, longitude: longitude)
	}
	
}

/// ``GeoCoordinates/Coordinates``
extension Coordinate3D {

	public init<N: BinaryFloatingPoint>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number), z: Self.Z(number))
	}

	public init<N: BinaryInteger>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number), z: Self.Z(number))
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(
			x: lhs.x * rhs.x,
			y: lhs.y * rhs.y,
			z: lhs.z * rhs.z
		)
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		return Self.init(
			x: lhs.x / rhs.x,
			y: lhs.y / rhs.y,
			z: lhs.z / rhs.z
		)
	}

}

extension Coordinate3D {

	public var description: String {
		"(\(String(describing: self.x)),\(String(describing: self.y)),\(String(describing: self.z)))"
	}

	public var debugDescription: String {
		"(\(String(reflecting: self.x)),\(String(reflecting: self.y)),\(String(reflecting: self.z)))"
	}

}
