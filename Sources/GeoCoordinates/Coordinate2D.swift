//
//  Coordinate2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Coordinate2D<X, Y>: Coordinates {
	
	associatedtype X: Coordinate
	associatedtype Y: Coordinate

	var x: X { get set }
	var y: Y { get set }

	init(x: X, y: Y)

	func offsetBy(dx: X, dy: Y) -> Self

}

public extension Coordinate2D {

	func offsetBy(dx: X = .zero, dy: Y = .zero) -> Self {
		self.offsetBy(dx: dx, dy: dy)
	}

}

public struct WGS84Coordinate2D: Coordinate2D {

	public typealias X = Longitude
	public typealias Y = Latitude
	
	public static var zero: Self {
		Self.init(latitude: .zero, longitude: .zero)
	}
	
	public var latitude: Latitude
	public var longitude: Longitude

	public var x: X {
		get { longitude }
		set { longitude = newValue }
	}
	public var y: Y {
		get { latitude }
		set { latitude = newValue }
	}
	
	public var west: X { longitude }
	public var east: X { longitude }
	public var south: Y { latitude }
	public var north: Y { latitude }
	
	public var withPositiveLongitude: Self {
		Self.init(latitude: latitude, longitude: longitude.positive)
	}
	
	public init(latitude: Latitude, longitude: Longitude) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	public init(x: X, y: Y) {
		self.init(latitude: y, longitude: x)
	}
	
	public func offsetBy(dLat: Latitude = 0, dLong: Longitude = 0) -> Self {
		Self.init(latitude: latitude + dLat, longitude: longitude + dLong)
	}
	public func offsetBy(dx: X, dy: Y) -> Self {
		Self.init(x: x + dx, y: y + dy)
	}
	
}

// MARK: - Operators

/// ``Foundation/AdditiveArithmetic``
extension Coordinate2D {
	
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

/// ``GeoCoordinates/Coordinates``
extension Coordinate2D {

	public init<N: BinaryFloatingPoint>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number))
	}

	public init<N: BinaryInteger>(repeating number: N) {
		self.init(x: Self.X(number), y: Self.Y(number))
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
	}

	public static func / (lhs: Self, rhs: Self) -> Self {
		return Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}

}

extension Coordinate2D {

	public var description: String {
		"(\(String(describing: self.x)),\(String(describing: self.y)))"
	}

	public var debugDescription: String {
		"(\(String(reflecting: self.x)),\(String(reflecting: self.y)))"
	}

}
