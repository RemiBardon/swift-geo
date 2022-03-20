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
	
	public var twoDimensions: Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: longitude)
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

extension Coordinate3D {
	
	public static func + (lhs: Coordinate3D, rhs: Coordinate3D) -> Coordinate3D {
		return lhs.offsetBy(dLat: rhs.latitude, dLong: rhs.longitude, dAlt: rhs.altitude)
	}
	
	public static func - (lhs: Coordinate3D, rhs: Coordinate3D) -> Coordinate3D {
		return lhs + (-rhs)
	}
	
	public prefix static func - (value: Coordinate3D) -> Coordinate3D {
		return Coordinate3D(
			latitude: -value.latitude,
			longitude: -value.longitude,
			altitude: -value.altitude
		)
	}
	
}