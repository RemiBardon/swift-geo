//
//  Coordinate.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Coordinate: BinaryFloatingPoint {
	
	var degrees: Double { get set }
	
	init(degrees: Double)
	
}

extension Coordinate {
	
	// MARK: ExpressibleByFloatLiteral
	
	public init(floatLiteral value: Double) {
		self.init(degrees: value)
	}
	
	// MARK: ExpressibleByIntegerLiteral
	
	public init(integerLiteral value: Int) {
		self.init(degrees: Double(value))
	}
	
	// MARK: FloatingPoint
	
	public static var nan: Self { Self.init(degrees: Double.nan) }
	public static var signalingNaN: Self { Self.init(degrees: Double.signalingNaN) }
	public static var infinity: Self { Self.init(degrees: Double.infinity) }
	public static var greatestFiniteMagnitude: Self { Self.init(degrees: Double.greatestFiniteMagnitude) }
	public static var pi: Self { Self.init(degrees: Double.pi) }
	
	public static var leastNormalMagnitude: Self { Self.init(degrees: Double.leastNormalMagnitude) }
	public static var leastNonzeroMagnitude: Self { Self.init(degrees: Double.leastNonzeroMagnitude) }
	
	public var exponent: Double.Exponent { self.degrees.exponent }
	public var sign: FloatingPointSign { self.degrees.sign }
	public var significand: Self { Self.init(degrees: self.degrees.significand) }
	public var ulp: Self { Self.init(degrees: self.degrees.ulp) }
	
	public var nextUp: Self { Self.init(degrees: self.degrees.nextUp) }
	
	public var isNormal: Bool { self.degrees.isNormal }
	public var isFinite: Bool { self.degrees.isFinite }
	public var isZero: Bool { self.degrees.isZero }
	public var isSubnormal: Bool { self.degrees.isSubnormal }
	public var isInfinite: Bool { self.degrees.isInfinite }
	public var isNaN: Bool { self.degrees.isNaN }
	public var isSignalingNaN: Bool { self.degrees.isSignalingNaN }
	public var isCanonical: Bool { self.degrees.isCanonical }
	
	public init(sign: FloatingPointSign, exponent: Int, significand: Self) {
		self.init(degrees: Double(sign: sign, exponent: exponent, significand: significand.degrees))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(degrees: lhs.degrees / rhs.degrees)
	}
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.degrees /= rhs.degrees
	}
	
	public func isEqual(to other: Self) -> Bool { self.degrees == other.degrees }
	public func isLess(than other: Self) -> Bool { self.degrees < other.degrees }
	public func isLessThanOrEqualTo(_ other: Self) -> Bool { self.degrees <= other.degrees }
	
	public mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self.degrees += lhs.degrees * rhs.degrees
	}
	public mutating func formRemainder(dividingBy other: Self) {
		self.degrees.formRemainder(dividingBy: other.degrees)
	}
	public mutating func formTruncatingRemainder(dividingBy other: Self) {
		self.degrees.formTruncatingRemainder(dividingBy: other.degrees)
	}
	public mutating func formSquareRoot() {
		self.degrees.formSquareRoot()
	}
	public mutating func round(_ rule: FloatingPointRoundingRule) {
		self.degrees.round(rule)
	}
	
	// MARK: Numeric
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(degrees: lhs.degrees * rhs.degrees)
	}
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.degrees *= rhs.degrees
	}
	
	public var magnitude: Self { Self.init(degrees: self.degrees.magnitude) }
	
	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Double(exactly: source) else { return nil }
		self.init(degrees: value)
	}
	
	// MARK: AdditiveArithmetic
	
	public static var zero: Self { Self.init(degrees: .zero) }
	
	// MARK: Strideable
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self.init(degrees: lhs.degrees + rhs.degrees)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self.init(degrees: lhs.degrees - rhs.degrees)
	}
	
	public func advanced(by n: Double.Stride) -> Self {
		return Self.init(degrees: self.degrees.advanced(by: n))
	}
	
	public func distance(to other: Self) -> Double.Stride {
		return self.degrees.distance(to: other.degrees)
	}
	
	// MARK: BinaryFloatingPoint
	
	public static var exponentBitCount: Int { Double.exponentBitCount }
	public static var significandBitCount: Int { Double.significandBitCount }
	
	public var binade: Self { Self.init(degrees: self.degrees.binade) }
	public var exponentBitPattern: Double.RawExponent { self.degrees.exponentBitPattern }
	public var significandBitPattern: Double.RawSignificand { self.degrees.significandBitPattern }
	public var significandWidth: Int { self.degrees.significandWidth }
	
	public init(
		sign: FloatingPointSign,
		exponentBitPattern: Double.RawExponent,
		significandBitPattern: Double.RawSignificand
	) {
		self.init(degrees: Double(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}
	
}

// TODO: Create custom struct that handles cycling in an interval
public struct Latitude: Coordinate {
	
	public var degrees: Double
	
	public init(degrees: Double) {
		self.degrees = degrees
	}
	
}

public struct Longitude: Coordinate {
	
	public var degrees: Double
	
	public init(degrees: Double) {
		self.degrees = degrees
	}
	
}
