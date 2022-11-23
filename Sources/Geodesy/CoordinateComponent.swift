//
//  CoordinateComponent.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation
import ValueWithUnit
import SwiftGeoToolbox

// MARK: - CoordinateComponent

public protocol CoordinateComponent<Unit>:
	SafeRawRepresentable,
	BinaryFloatingPoint,
	InitializableByNumber,
	CustomStringConvertible,
	CustomDebugStringConvertible,
	Zeroable
where RawValue: ValueWithUnit.Value<Unit>
{
	associatedtype Unit: ValueWithUnit.Unit
}

public extension CoordinateComponent {

	// MARK: ExpressibleByFloatLiteral

	init(floatLiteral value: Double) {
		self.init(value)
	}

	// MARK: ExpressibleByIntegerLiteral

	init(integerLiteral value: Int) {
		self.init(rawValue: RawValue(value))
	}

	// MARK: FloatingPoint

	static var nan: Self { Self(RawValue.nan) }
	static var signalingNaN: Self { Self(RawValue.signalingNaN) }
	static var infinity: Self { Self(RawValue.infinity) }
	static var greatestFiniteMagnitude: Self { Self(RawValue.greatestFiniteMagnitude) }
	static var pi: Self { Self(RawValue.pi) }

	static var leastNormalMagnitude: Self { Self(RawValue.leastNormalMagnitude) }
	static var leastNonzeroMagnitude: Self { Self(RawValue.leastNonzeroMagnitude) }

	var exponent: RawValue.Exponent { self.rawValue.exponent }
	var sign: FloatingPointSign { self.rawValue.sign }
	var significand: Self { Self(self.rawValue.significand) }
	var ulp: Self { Self(self.rawValue.ulp) }

	var nextUp: Self { Self(self.rawValue.nextUp) }

	var isNormal: Bool { self.rawValue.isNormal }
	var isFinite: Bool { self.rawValue.isFinite }
	var isZero: Bool { self.rawValue.isZero }
	var isSubnormal: Bool { self.rawValue.isSubnormal }
	var isInfinite: Bool { self.rawValue.isInfinite }
	var isNaN: Bool { self.rawValue.isNaN }
	var isSignalingNaN: Bool { self.rawValue.isSignalingNaN }
	var isCanonical: Bool { self.rawValue.isCanonical }

	init(sign: FloatingPointSign, exponent: RawValue.Exponent, significand: Self) {
		self.init(rawValue: RawValue(sign: sign, exponent: exponent, significand: significand.rawValue))
	}

	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue / rhs.rawValue)
	}
	static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}

	func isEqual(to other: Self) -> Bool {
		self.rawValue == other.rawValue
	}
	func isLess(than other: Self) -> Bool {
		self.rawValue < other.rawValue
	}
	func isLessThanOrEqualTo(_ other: Self) -> Bool {
		self.rawValue <= other.rawValue
	}

	mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self += Self.init(rawValue: lhs.rawValue * rhs.rawValue)
	}
	mutating func formRemainder(dividingBy other: Self) {
		self = Self.init(rawValue: self.rawValue.remainder(dividingBy: other.rawValue))
	}
	mutating func formTruncatingRemainder(dividingBy other: Self) {
		self = Self.init(rawValue: self.rawValue.truncatingRemainder(dividingBy: other.rawValue))
	}
	mutating func formSquareRoot() {
		self = Self.init(rawValue: self.rawValue.squareRoot())
	}
	mutating func round(_ rule: FloatingPointRoundingRule) {
		self = Self.init(rawValue: self.rawValue.rounded(rule))
	}

	// MARK: Numeric

	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(rawValue: lhs.rawValue * rhs.rawValue)
	}
	static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	var magnitude: Self { Self.init(rawValue: self.rawValue.magnitude) }

	init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = RawValue(exactly: source) else { return nil }
		self.init(rawValue: value)
	}

	// MARK: AdditiveArithmetic

	static var zero: Self { Self.init(rawValue: RawValue.zero) }

	// MARK: Strideable

	static func + (lhs: Self, rhs: Self) -> Self {
		return Self.init(rawValue: lhs.rawValue + rhs.rawValue)
	}

	static func - (lhs: Self, rhs: Self) -> Self {
		return Self.init(rawValue: lhs.rawValue - rhs.rawValue)
	}

	func advanced(by n: RawValue.Stride) -> Self {
		return Self.init(rawValue: self.rawValue.advanced(by: n))
	}

	func distance(to other: Self) -> RawValue.Stride {
		return self.rawValue.distance(to: other.rawValue)
	}

	// MARK: BinaryFloatingPoint

	static var exponentBitCount: Int { RawValue.exponentBitCount }
	static var significandBitCount: Int { RawValue.significandBitCount }

	var binade: Self { Self.init(rawValue: self.rawValue.binade) }
	var exponentBitPattern: RawValue.RawExponent { self.rawValue.exponentBitPattern }
	var significandBitPattern: RawValue.RawSignificand {
		self.rawValue.significandBitPattern
	}
	var significandWidth: Int { self.rawValue.significandWidth }

	init(
		sign: FloatingPointSign,
		exponentBitPattern: RawValue.RawExponent,
		significandBitPattern: RawValue.RawSignificand
	) {
		self.init(rawValue: RawValue(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}

	init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(rawValue: .init(rawValue: .init(value)))
	}

	init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(rawValue: .init(rawValue: .init(value)))
	}

	// MARK: CustomStringConvertible

	var description: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 9
		formatter.locale = .en
		return formatter.string(for: Double(self))
			?? "\(self.rawValue.rawValue)"
	}

	// MARK: CustomDebugStringConvertible

	var debugDescription: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 99
		formatter.locale = .en
		return formatter.string(for: Double(self))
			?? "\(self.rawValue.rawValue)"
	}
	
}

// MARK: - ValidatableCoordinateComponent

public protocol ValidatableCoordinateComponent<Unit>: CoordinateComponent {

	static var min: Self { get }
	static var max: Self { get }
	static var validRange: ClosedRange<Self> { get }

	/// Tells if this value is in valid bounds or not.
	var isValid: Bool { get }

	/// A copy of this value, in valid bounds.
	///
	/// In angular coordinate system, it means rotating the value
	/// to put it in the valid range.
	///
	/// In linear coordinate system, it can mean making the value positive.
	var valid: Self { get }

	static func random() -> Self

}

extension ValidatableCoordinateComponent {
	public static var validRange: ClosedRange<Self> { min...max }
	public var isValid: Bool { Self.validRange.contains(self) }
}

extension ValidatableCoordinateComponent where Self.RawSignificand: FixedWidthInteger {
	public static func random() -> Self {
		return Self.random(in: validRange)
	}
}

// MARK: - AngularCoordinateComponent

/// - Todo: Create custom struct that handles cycling in an interval.
public protocol AngularCoordinateComponent<Unit>: ValidatableCoordinateComponent
where Unit: AngleUnit
{

	static var fullRotation: Self { get }
	static var halfRotation: Self { get }

	/// `"N"` or `"E"` depending on axis.
	static var positiveDirectionChar: Character { get }

	/// `"S"` or `"W"` depending on axis.
	static var negativeDirectionChar: Character { get }

	var decimalDegrees: Double { get set }
	var radians: Double { get set }

	var positive: Self { get }

	init(decimalDegrees: Double)
	init(radians: Double)

}

public extension AngularCoordinateComponent {

	static var min: Self { -halfRotation }
	static var max: Self { halfRotation }

	var valid: Self {
		if self.isValid {
			return self
		} else {
			let remainder = self.truncatingRemainder(dividingBy: Self.fullRotation)

			if abs(remainder) > .halfRotation {
				let base = self < .zero ? Self.fullRotation : -Self.fullRotation
				return base + remainder
			} else {
				return remainder
			}
		}
	}

	var radians: Double {
		get { self.decimalDegrees * .pi / 180.0 }
		set { self.decimalDegrees = newValue * 180.0 / .pi }
	}

	var positive: Self {
		if self.rawValue < .zero {
			// `self.rawValue` is negative, so we end up with `Self.fullRotation - |self.rawValue|`
			return self + Self.fullRotation
		} else {
			return self
		}
	}

	init(radians: Double) {
		self.init(decimalDegrees: radians * 180.0 / .pi)
	}

}
