//
//  Coordinate2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Coordinate2D: Hashable {
	
	public typealias X = Longitude
	public typealias Y = Latitude
	
	public static var zero: Coordinate2D {
		Self.init(latitude: .zero, longitude: .zero)
	}
	
	public var latitude: Latitude
	public var longitude: Longitude
	
	public var x: X { longitude }
	public var y: Y { latitude }
	
	public var west: X { longitude }
	public var east: X { longitude }
	public var south: Y { latitude }
	public var north: Y { latitude }
	
	public var withPositiveLongitude: Coordinate2D {
		Self.init(latitude: latitude, longitude: longitude.positive)
	}
	
	public init(latitude: Latitude, longitude: Longitude) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	public init(x: X, y: Y) {
		self.init(latitude: y, longitude: x)
	}
	
	public func offsetBy(dLat: Latitude = 0, dLong: Longitude = 0) -> Coordinate2D {
		Self.init(latitude: latitude + dLat, longitude: longitude + dLong)
	}
	public func offsetBy(dx: X = .zero, dy: Y = .zero) -> Coordinate2D {
		Self.init(x: x + dx, y: y + dy)
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
		return Self.init(latitude: -value.latitude, longitude: -value.longitude)
	}
	
}
