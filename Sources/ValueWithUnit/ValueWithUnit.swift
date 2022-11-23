//
//  ValueWithUnit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 13/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import SwiftGeoToolbox

public protocol Unit: Hashable, Sendable {
	#warning("TODO: Add name")
}

public protocol Value<Unit>:
	BinaryFloatingPoint,
	MultiplicativeArithmetic,
	Zeroable,
	SafeRawRepresentable,
	InitializableByNumber
where RawValue: BinaryFloatingPoint
{
	associatedtype Unit: ValueWithUnit.Unit
}

public extension Value {

	// MARK: ExpressibleByFloatLiteral

	init(floatLiteral value: Double) {
		self.init(value)
	}

	// MARK: ExpressibleByIntegerLiteral

	init(integerLiteral value: Int) {
		self.init(Double(value))
	}

	// MARK: Comparable

	static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue < rhs.rawValue
	}

	// MARK: FloatingPoint

	static var nan: Self { Self(RawValue.nan) }
	static var signalingNaN: Self { Self(RawValue.signalingNaN) }
	static var infinity: Self { Self(RawValue.infinity) }
	static var greatestFiniteMagnitude: Self { Self(RawValue.greatestFiniteMagnitude) }
	static var pi: Self { Self(RawValue.pi) }

	static var leastNormalMagnitude: Self { Self(RawValue.leastNormalMagnitude) }
	static var leastNonzeroMagnitude: Self { Self(RawValue.leastNonzeroMagnitude) }

	var exponent: RawValue.Exponent { RawValue(self.rawValue).exponent }
	var sign: FloatingPointSign { RawValue(self.rawValue).sign }
	var significand: Self { Self(RawValue(self.rawValue).significand) }
	var ulp: Self { Self(RawValue(self.rawValue).ulp) }

	var nextUp: Self { Self(RawValue(self.rawValue).nextUp) }

	var isNormal: Bool { RawValue(self.rawValue).isNormal }
	var isFinite: Bool { RawValue(self.rawValue).isFinite }
	var isZero: Bool { RawValue(self.rawValue).isZero }
	var isSubnormal: Bool { RawValue(self.rawValue).isSubnormal }
	var isInfinite: Bool { RawValue(self.rawValue).isInfinite }
	var isNaN: Bool { RawValue(self.rawValue).isNaN }
	var isSignalingNaN: Bool { RawValue(self.rawValue).isSignalingNaN }
	var isCanonical: Bool { RawValue(self.rawValue).isCanonical }

	init(sign: FloatingPointSign, exponent: RawValue.Exponent, significand: Self) {
		self.init(RawValue(sign: sign, exponent: exponent, significand: RawValue(significand.rawValue)))
	}

	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue / rhs.rawValue)
	}
	static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}

	func isEqual(to other: Self) -> Bool {
		RawValue(self.rawValue) == RawValue(other.rawValue)
	}
	func isLess(than other: Self) -> Bool {
		RawValue(self.rawValue) < RawValue(other.rawValue)
	}
	func isLessThanOrEqualTo(_ other: Self) -> Bool {
		RawValue(self.rawValue) <= RawValue(other.rawValue)
	}

	mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self += Self(RawValue(lhs.rawValue) * RawValue(rhs.rawValue))
	}
	mutating func formRemainder(dividingBy other: Self) {
		self = Self(RawValue(self.rawValue).remainder(dividingBy: RawValue(other.rawValue)))
	}
	mutating func formTruncatingRemainder(dividingBy other: Self) {
		self = Self(RawValue(self.rawValue).truncatingRemainder(dividingBy: RawValue(other.rawValue)))
	}
	mutating func formSquareRoot() {
		self = Self(RawValue(self.rawValue).squareRoot())
	}
	mutating func round(_ rule: FloatingPointRoundingRule) {
		self = Self(RawValue(self.rawValue).rounded(rule))
	}

	// MARK: Numeric

	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue * rhs.rawValue)
	}
	static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	var magnitude: Self { Self(RawValue(self.rawValue).magnitude) }

	init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = RawValue(exactly: source) else { return nil }
		self.init(value)
	}

	// MARK: AdditiveArithmetic

	static var zero: Self { Self(RawValue.zero) }

	// MARK: Strideable

	static func + (lhs: Self, rhs: Self) -> Self {
		return Self.init(rawValue: lhs.rawValue + rhs.rawValue)
	}

	static func - (lhs: Self, rhs: Self) -> Self {
		return Self.init(rawValue: lhs.rawValue - rhs.rawValue)
	}

	func advanced(by n: RawValue.Stride) -> Self {
		return Self(RawValue(self.rawValue).advanced(by: n))
	}

	func distance(to other: Self) -> RawValue.Stride {
		return RawValue(self.rawValue).distance(to: RawValue(other.rawValue))
	}

	// MARK: BinaryFloatingPoint

	static var exponentBitCount: Int { RawValue.exponentBitCount }
	static var significandBitCount: Int { RawValue.significandBitCount }

	var binade: Self { Self(RawValue(self.rawValue).binade) }
	var exponentBitPattern: RawValue.RawExponent { RawValue(self.rawValue).exponentBitPattern }
	var significandBitPattern: RawValue.RawSignificand {
		RawValue(self.rawValue).significandBitPattern
	}
	var significandWidth: Int { RawValue(self.rawValue).significandWidth }

	init(
		sign: FloatingPointSign,
		exponentBitPattern: RawValue.RawExponent,
		significandBitPattern: RawValue.RawSignificand
	) {
		self.init(RawValue(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}

	init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(rawValue: .init(value))
	}

	init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(rawValue: .init(value))
	}

}

public struct DoubleOf<U: ValueWithUnit.Unit>: Value, Hashable {
	public typealias Unit = U
	public var rawValue: Double
	public init(rawValue: RawValue) {
		self.rawValue = rawValue
	}
}

// MARK: - Angles

public protocol AngleUnit: Unit {
	/// Value in radians equal to `1` `Self`.
	static var radiansFactor: Double { get }
}

public extension Value where Unit: AngleUnit {
	var radians: Double { Double(self.rawValue) * Self.Unit.radiansFactor }
	var degrees: Double { (self.radians / Double.pi) * 180.0 }
}
public extension Value where Unit == Radian {
	var radians: Double { Double(self.rawValue) }
}
public extension Value where Unit == Degree {
	var degrees: Double { Double(self.rawValue) }
}

public struct Radian: AngleUnit {
	public static let radiansFactor: Double = 1.0
}
public struct Degree: AngleUnit {
	public static let radiansFactor: Double = 180.0 / .pi
}

// MARK: - Lengths

public protocol LengthUnit: Unit {
	/// Value in meters equal to `1` `Self`.
  static var metersFactor: Double { get }
}
public struct Meter: LengthUnit {
  public static let metersFactor: Double = 1
}
