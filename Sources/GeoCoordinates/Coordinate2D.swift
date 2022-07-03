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

extension Coordinate2D: AdditiveArithmetic {
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return lhs.offsetBy(dx: rhs.x, dy: rhs.y)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return lhs + (-rhs)
	}
	
}

extension Coordinate2D {
	
	public prefix static func - (value: Self) -> Self {
		return Self.init(x: -value.x, y: -value.y)
	}
	
}

extension Coordinate2D: Coordinates {

//	public init<N: BinaryFloatingPoint>(repeating number: N) {
//		self.init(x: Self.X(number), y: Self.Y(number))
//	}

	public init<N: BinaryInteger>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number))
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		return Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}

}
