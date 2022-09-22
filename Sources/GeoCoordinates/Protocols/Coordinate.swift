//
//  Coordinate.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Coordinate: BinaryFloatingPoint, CustomStringConvertible, CustomDebugStringConvertible {
	
	var value: Double { get set }
	
	init(value: Double)
	
}

extension Coordinate {
	
	// MARK: ExpressibleByFloatLiteral
	
	public init(floatLiteral value: Double) {
		self.init(value: value)
	}
	
	// MARK: ExpressibleByIntegerLiteral
	
	public init(integerLiteral value: Int) {
		self.init(value: Double(value))
	}
	
	// MARK: FloatingPoint
	
	public static var nan: Self { Self.init(value: Double.nan) }
	public static var signalingNaN: Self { Self.init(value: Double.signalingNaN) }
	public static var infinity: Self { Self.init(value: Double.infinity) }
	public static var greatestFiniteMagnitude: Self { Self.init(value: Double.greatestFiniteMagnitude) }
	public static var pi: Self { Self.init(value: Double.pi) }
	
	public static var leastNormalMagnitude: Self { Self.init(value: Double.leastNormalMagnitude) }
	public static var leastNonzeroMagnitude: Self { Self.init(value: Double.leastNonzeroMagnitude) }
	
	public var exponent: Double.Exponent { self.value.exponent }
	public var sign: FloatingPointSign { self.value.sign }
	public var significand: Self { Self.init(value: self.value.significand) }
	public var ulp: Self { Self.init(value: self.value.ulp) }
	
	public var nextUp: Self { Self.init(value: self.value.nextUp) }
	
	public var isNormal: Bool { self.value.isNormal }
	public var isFinite: Bool { self.value.isFinite }
	public var isZero: Bool { self.value.isZero }
	public var isSubnormal: Bool { self.value.isSubnormal }
	public var isInfinite: Bool { self.value.isInfinite }
	public var isNaN: Bool { self.value.isNaN }
	public var isSignalingNaN: Bool { self.value.isSignalingNaN }
	public var isCanonical: Bool { self.value.isCanonical }
	
	public init(sign: FloatingPointSign, exponent: Int, significand: Self) {
		self.init(value: Double(sign: sign, exponent: exponent, significand: significand.value))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(value: lhs.value / rhs.value)
	}
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs.value /= rhs.value
	}
	
	public func isEqual(to other: Self) -> Bool { self.value == other.value }
	public func isLess(than other: Self) -> Bool { self.value < other.value }
	public func isLessThanOrEqualTo(_ other: Self) -> Bool { self.value <= other.value }
	
	public mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self.value += lhs.value * rhs.value
	}
	public mutating func formRemainder(dividingBy other: Self) {
		self.value.formRemainder(dividingBy: other.value)
	}
	public mutating func formTruncatingRemainder(dividingBy other: Self) {
		self.value.formTruncatingRemainder(dividingBy: other.value)
	}
	public mutating func formSquareRoot() {
		self.value.formSquareRoot()
	}
	public mutating func round(_ rule: FloatingPointRoundingRule) {
		self.value.round(rule)
	}
	
	// MARK: Numeric
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self.init(value: lhs.value * rhs.value)
	}
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs.value *= rhs.value
	}
	
	public var magnitude: Self { Self.init(value: self.value.magnitude) }
	
	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Double(exactly: source) else { return nil }
		self.init(value: value)
	}
	
	// MARK: AdditiveArithmetic
	
	public static var zero: Self { Self.init(value: .zero) }
	
	// MARK: Strideable
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self.init(value: lhs.value + rhs.value)
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self.init(value: lhs.value - rhs.value)
	}
	
	public func advanced(by n: Double.Stride) -> Self {
		return Self.init(value: self.value.advanced(by: n))
	}
	
	public func distance(to other: Self) -> Double.Stride {
		return self.value.distance(to: other.value)
	}
	
	// MARK: BinaryFloatingPoint
	
	public static var exponentBitCount: Int { Double.exponentBitCount }
	public static var significandBitCount: Int { Double.significandBitCount }
	
	public var binade: Self { Self.init(value: self.value.binade) }
	public var exponentBitPattern: Double.RawExponent { self.value.exponentBitPattern }
	public var significandBitPattern: Double.RawSignificand { self.value.significandBitPattern }
	public var significandWidth: Int { self.value.significandWidth }
	
	public init(
		sign: FloatingPointSign,
		exponentBitPattern: Double.RawExponent,
		significandBitPattern: Double.RawSignificand
	) {
		self.init(value: Double(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}

	public init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(value: Double(value))
	}

	public init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(value: Double(value))
	}

	// MARK: CustomStringConvertible

	public var description: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: self.value)) ?? "\(self.value)"
	}

	// MARK: CustomDebugStringConvertible

	public var debugDescription: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 3
		formatter.locale = .en
		return formatter.string(from: NSNumber(value: self.value)) ?? "\(self.value)"
	}
	
}
