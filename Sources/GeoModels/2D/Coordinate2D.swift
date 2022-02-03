//
//  Coordinate2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Coordinate2D: Hashable {
	
	public static var zero: Coordinate2D {
		Coordinate2D(latitude: 0, longitude: 0)
	}
	
	public var latitude: Latitude
	public var longitude: Longitude
	
	public var x: Longitude { longitude }
	public var y: Latitude { latitude }
	
	public var withPositiveLongitude: Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: longitude.positive)
	}
	
	public init(
		latitude: Latitude,
		longitude: Longitude
	) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	public func offsetBy(dLat: Latitude = 0, dLong: Longitude = 0) -> Coordinate2D {
		Coordinate2D(latitude: latitude + dLat, longitude: longitude + dLong)
	}
	public func offsetBy(dx: Longitude = 0, dy: Latitude = 0) -> Coordinate2D {
		Coordinate2D(latitude: latitude + dy, longitude: longitude + dx)
	}
	
}

// MARK: - Operators

extension Coordinate2D {
	
	public static func + (lhs: Coordinate2D, rhs: Coordinate2D) -> Coordinate2D {
		return lhs.offsetBy(dLat: rhs.latitude, dLong: rhs.longitude)
	}
	
	public static func - (lhs: Coordinate2D, rhs: Coordinate2D) -> Coordinate2D {
		return lhs + (-rhs)
	}
	
	public prefix static func - (value: Coordinate2D) -> Coordinate2D {
		return Coordinate2D(latitude: -value.latitude, longitude: -value.longitude)
	}
	
}
