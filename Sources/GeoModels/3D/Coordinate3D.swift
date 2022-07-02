//
//  Coordinate3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Coordinate3D: Hashable {
	
	public typealias X = Longitude
	public typealias Y = Latitude
	public typealias Z = Altitude
	
	public static var zero: Coordinate3D {
		Coordinate3D(latitude: .zero, longitude: .zero, altitude: .zero)
	}
	
	public var latitude: Latitude
	public var longitude: Longitude
	public var altitude: Altitude
	
	public var x: X { longitude }
	public var y: Y { latitude }
	public var z: Z { altitude }
	
	public var withPositiveLongitude: Coordinate3D {
		Coordinate3D(latitude: latitude, longitude: longitude.positive, altitude: altitude)
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
	
	public init(_ coordinate2d: Coordinate2D, altitude: Altitude = .zero) {
		self.init(latitude: coordinate2d.latitude, longitude: coordinate2d.longitude, altitude: altitude)
	}
	
	public func offsetBy(dLat: Latitude = .zero, dLong: Longitude = .zero, dAlt: Altitude = .zero) -> Coordinate3D {
		Coordinate3D(
			latitude: latitude + dLat,
			longitude: longitude + dLong,
			altitude: altitude + dAlt
		)
	}
	public func offsetBy(dx: X = .zero, dy: Y = .zero, dz: Z = .zero) -> Coordinate3D {
		Coordinate3D(x: x + dx, y: y + dy, z: z + dz)
	}
	
}

// MARK: - Operators

extension Coordinate3D: AdditiveArithmetic {
	
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

extension Coordinate3D: GeoModels.CompoundDimension {
	
	public typealias LowerDimension = GeoModels.Coordinate2D
	
	public var lowerDimension: Self.LowerDimension {
		LowerDimension(latitude: latitude, longitude: longitude)
	}
	
}

extension Coordinate3D: GeoModels.Coordinates {

	public init<N: BinaryFloatingPoint>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number), z: Self.Z(number))
	}

	public init<N: BinaryInteger>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number), z: Self.Z(number))
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		return Self.init(
			x: lhs.x / rhs.x,
			y: lhs.y / rhs.y,
			z: lhs.z / rhs.z
		)
	}

}
