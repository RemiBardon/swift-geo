//
//  Coordinate.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Coordinate: BinaryFloatingPoint, GeographicNotation {
	
	/// "N" or "E" depending on axis
	static var positiveDirectionChar: Character { get }
	
	/// "S" or "W" depending on axis
	static var negativeDirectionChar: Character { get }
	
	var decimalDegrees: Double { get set }
	
	init(decimalDegrees: Double)
	
}

extension Coordinate {
	
	// MARK: ExpressibleByFloatLiteral
	
	public init(floatLiteral value: Double) {
		self.init(decimalDegrees: value)
	}
	
	// MARK: ExpressibleByIntegerLiteral
	
	public init(integerLiteral value: Int) {
		self.init(decimalDegrees: Double(value))
	}
	
	// MARK: FloatingPoint
	
	public static var nan: Self { Self.init(decimalDegrees: Double.nan) }
	public static var signalingNaN: Self { Self.init(decimalDegrees: Double.signalingNaN) }
	public static var infinity: Self { Self.init(decimalDegrees: Double.infinity) }
	public static var greatestFiniteMagnitude: Self { Self.init(decimalDegrees: Double.greatestFiniteMagnitude) }
	public static var pi: Self { Self.init(decimalDegrees: Double.pi) }
	
	public static var leastNormalMagnitude: Self { Self.init(decimalDegrees: Double.leastNormalMagnitude) }
	public static var leastNonzeroMagnitude: Self { Self.init(decimalDegrees: Double.leastNonzeroMagnitude) }
	
	public var exponent: Double.Exponent { self.decimalDegrees.exponent }
	public var sign: FloatingPointSign { self.decimalDegrees.sign }
	public var significand: Self { Self.init(decimalDegrees: self.decimalDegrees.significand) }
	public var ulp: Self { Self.init(decimalDegrees: self.decimalDegrees.ulp) }
	
	public var nextUp: Self { Self.init(decimalDegrees: self.decimalDegrees.nextUp) }
	
	public var isNormal: Bool { self.decimalDegrees.isNormal }
	public var isFinite: Bool { self.decimalDegrees.isFinite }
	public var isZero: Bool { self.decimalDegrees.isZero }
	public var isSubnormal: Bool { self.decimalDegrees.isSubnormal }
	public var isInfinite: Bool { self.decimalDegrees.isInfinite }
	public var isNaN: Bool { self.decimalDegrees.isNaN }
	public var isSignalingNaN: Bool { self.decimalDegrees.isSignalingNaN }
	public var isCanonical: Bool { self.decimalDegrees.isCanonical }
	
	public init(sign: FloatingPointSign, exponent: Int, significand: Self) {
		self.init(decimalDegrees: Double(sign: sign, exponent: exponent, significand: significand.decimalDegrees))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(decimalDegrees: lhs.decimalDegrees / rhs.decimalDegrees)
	}
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.decimalDegrees /= rhs.decimalDegrees
	}
	
	public func isEqual(to other: Self) -> Bool { self.decimalDegrees == other.decimalDegrees }
	public func isLess(than other: Self) -> Bool { self.decimalDegrees < other.decimalDegrees }
	public func isLessThanOrEqualTo(_ other: Self) -> Bool { self.decimalDegrees <= other.decimalDegrees }
	
	public mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self.decimalDegrees += lhs.decimalDegrees * rhs.decimalDegrees
	}
	public mutating func formRemainder(dividingBy other: Self) {
		self.decimalDegrees.formRemainder(dividingBy: other.decimalDegrees)
	}
	public mutating func formTruncatingRemainder(dividingBy other: Self) {
		self.decimalDegrees.formTruncatingRemainder(dividingBy: other.decimalDegrees)
	}
	public mutating func formSquareRoot() {
		self.decimalDegrees.formSquareRoot()
	}
	public mutating func round(_ rule: FloatingPointRoundingRule) {
		self.decimalDegrees.round(rule)
	}
	
	// MARK: Numeric
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(decimalDegrees: lhs.decimalDegrees * rhs.decimalDegrees)
	}
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.decimalDegrees *= rhs.decimalDegrees
	}
	
	public var magnitude: Self { Self.init(decimalDegrees: self.decimalDegrees.magnitude) }
	
	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Double(exactly: source) else { return nil }
		self.init(decimalDegrees: value)
	}
	
	// MARK: AdditiveArithmetic
	
	public static var zero: Self { Self.init(decimalDegrees: .zero) }
	
	// MARK: Strideable
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self.init(decimalDegrees: lhs.decimalDegrees + rhs.decimalDegrees)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self.init(decimalDegrees: lhs.decimalDegrees - rhs.decimalDegrees)
	}
	
	public func advanced(by n: Double.Stride) -> Self {
		return Self.init(decimalDegrees: self.decimalDegrees.advanced(by: n))
	}
	
	public func distance(to other: Self) -> Double.Stride {
		return self.decimalDegrees.distance(to: other.decimalDegrees)
	}
	
	// MARK: BinaryFloatingPoint
	
	public static var exponentBitCount: Int { Double.exponentBitCount }
	public static var significandBitCount: Int { Double.significandBitCount }
	
	public var binade: Self { Self.init(decimalDegrees: self.decimalDegrees.binade) }
	public var exponentBitPattern: Double.RawExponent { self.decimalDegrees.exponentBitPattern }
	public var significandBitPattern: Double.RawSignificand { self.decimalDegrees.significandBitPattern }
	public var significandWidth: Int { self.decimalDegrees.significandWidth }
	
	public init(
		sign: FloatingPointSign,
		exponentBitPattern: Double.RawExponent,
		significandBitPattern: Double.RawSignificand
	) {
		self.init(decimalDegrees: Double(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}
	
}

// TODO: Create custom struct that handles cycling in an interval

/// The latitude component of a coordinate.
public struct Latitude: Coordinate {
	
	public static let positiveDirectionChar: Character = "N"
	public static let negativeDirectionChar: Character = "S"
	
	public static var fullRotation: Latitude = 180
	public static var halfRotation: Latitude = 90
	
	public var decimalDegrees: Double
	
	public var positive: Latitude {
		if decimalDegrees < .zero {
			// `degrees` is negative, so we end up with `180 - |degrees|`
			return self + Self.fullRotation
		} else {
			return self
		}
	}
	
	public init(decimalDegrees: Double) {
		self.decimalDegrees = decimalDegrees
	}
	
	public static func random() -> Self {
		return Self.random(in: -halfRotation...halfRotation)
	}
	
}

/// The longitude component of a coordinate.
public struct Longitude: Coordinate {
	
	public static let positiveDirectionChar: Character = "E"
	public static let negativeDirectionChar: Character = "W"
	
	public static var fullRotation: Longitude = 360
	public static var halfRotation: Longitude = 180
	
	public var decimalDegrees: Double
	
	public var positive: Longitude {
		if decimalDegrees < .zero {
			// `degrees` is negative, so we end up with `360 - |degrees|`
			return self + Self.fullRotation
		} else {
			return self
		}
	}
	
	public init(decimalDegrees: Double) {
		self.decimalDegrees = decimalDegrees
	}
	
	public static func random() -> Self {
		return Self.random(in: -halfRotation...halfRotation)
	}
	
}
