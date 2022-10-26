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

public protocol CoordinateComponent:
	SafeRawRepresentable,
	BinaryFloatingPoint,
	InitializableByNumber,
	CustomStringConvertible,
	CustomDebugStringConvertible,
	Zeroable
where RawValue: Value
{}

extension CoordinateComponent {

	internal var _rawValue: RawValue.RawValue { self.rawValue.rawValue }
	
	// MARK: ExpressibleByFloatLiteral
	
	public init(floatLiteral value: Double) {
		self.init(value)
	}
	
	// MARK: ExpressibleByIntegerLiteral
	
	public init(integerLiteral value: Int) {
		self.init(Double(value))
	}
	
	// MARK: FloatingPoint
	
	public static var nan: Self { Self(Double.nan) }
	public static var signalingNaN: Self { Self(Double.signalingNaN) }
	public static var infinity: Self { Self(Double.infinity) }
	public static var greatestFiniteMagnitude: Self { Self(Double.greatestFiniteMagnitude) }
	public static var pi: Self { Self(Double.pi) }
	
	public static var leastNormalMagnitude: Self { Self(Double.leastNormalMagnitude) }
	public static var leastNonzeroMagnitude: Self { Self(Double.leastNonzeroMagnitude) }
	
	public var exponent: Double.Exponent { Double(self._rawValue).exponent }
	public var sign: FloatingPointSign { Double(self._rawValue).sign }
	public var significand: Self { Self(Double(self._rawValue).significand) }
	public var ulp: Self { Self(Double(self._rawValue).ulp) }
	
	public var nextUp: Self { Self(Double(self._rawValue).nextUp) }
	
	public var isNormal: Bool { Double(self._rawValue).isNormal }
	public var isFinite: Bool { Double(self._rawValue).isFinite }
	public var isZero: Bool { Double(self._rawValue).isZero }
	public var isSubnormal: Bool { Double(self._rawValue).isSubnormal }
	public var isInfinite: Bool { Double(self._rawValue).isInfinite }
	public var isNaN: Bool { Double(self._rawValue).isNaN }
	public var isSignalingNaN: Bool { Double(self._rawValue).isSignalingNaN }
	public var isCanonical: Bool { Double(self._rawValue).isCanonical }
	
	public init(sign: FloatingPointSign, exponent: Int, significand: Self) {
		self.init(Double(sign: sign, exponent: exponent, significand: Double(significand._rawValue)))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self(Double(lhs._rawValue) / Double(rhs._rawValue))
	}
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
	
	public func isEqual(to other: Self) -> Bool {
		Double(self._rawValue) == Double(other._rawValue)
	}
	public func isLess(than other: Self) -> Bool {
		Double(self._rawValue) < Double(other._rawValue)
	}
	public func isLessThanOrEqualTo(_ other: Self) -> Bool {
		Double(self._rawValue) <= Double(other._rawValue)
	}
	
	public mutating func addProduct(_ lhs: Self, _ rhs: Self) {
		self += Self(Double(lhs._rawValue) * Double(rhs._rawValue))
	}
	public mutating func formRemainder(dividingBy other: Self) {
		self = Self(Double(self._rawValue).remainder(dividingBy: Double(other._rawValue)))
	}
	public mutating func formTruncatingRemainder(dividingBy other: Self) {
		self = Self(Double(self._rawValue).truncatingRemainder(dividingBy: Double(other._rawValue)))
	}
	public mutating func formSquareRoot() {
		self = Self(Double(self._rawValue).squareRoot())
	}
	public mutating func round(_ rule: FloatingPointRoundingRule) {
		self = Self(Double(self._rawValue).rounded(rule))
	}
	
	// MARK: Numeric
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self(Double(lhs._rawValue) * Double(rhs._rawValue))
	}
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	
	public var magnitude: Self { Self(Double(self._rawValue).magnitude) }
	
	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Double(exactly: source) else { return nil }
		self.init(value)
	}
	
	// MARK: AdditiveArithmetic
	
	public static var zero: Self { Self(Double.zero) }
	
	// MARK: Strideable
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self(Double(lhs._rawValue) + Double(rhs._rawValue))
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self(Double(lhs._rawValue) - Double(rhs._rawValue))
	}
	
	public func advanced(by n: Double.Stride) -> Self {
		return Self(Double(self._rawValue).advanced(by: n))
	}
	
	public func distance(to other: Self) -> Double.Stride {
		return Double(self._rawValue).distance(to: Double(other._rawValue))
	}
	
	// MARK: BinaryFloatingPoint
	
	public static var exponentBitCount: Int { Double.exponentBitCount }
	public static var significandBitCount: Int { Double.significandBitCount }
	
	public var binade: Self { Self(Double(self._rawValue).binade) }
	public var exponentBitPattern: Double.RawExponent { Double(self._rawValue).exponentBitPattern }
	public var significandBitPattern: Double.RawSignificand {
		Double(self._rawValue).significandBitPattern
	}
	public var significandWidth: Int { Double(self._rawValue).significandWidth }
	
	public init(
		sign: FloatingPointSign,
		exponentBitPattern: Double.RawExponent,
		significandBitPattern: Double.RawSignificand
	) {
		self.init(Double(
			sign: sign,
			exponentBitPattern: exponentBitPattern,
			significandBitPattern: significandBitPattern
		))
	}

	public init<Source>(_ value: Source) where Source: BinaryFloatingPoint {
		self.init(rawValue: .init(rawValue: .init(value)))
	}

	public init<Source>(_ value: Source) where Source: BinaryInteger {
		self.init(rawValue: .init(rawValue: .init(value)))
	}

	// MARK: CustomStringConvertible

	public var description: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(for: self._rawValue) ?? "\(self._rawValue)"
	}

	// MARK: CustomDebugStringConvertible

	public var debugDescription: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 99
		formatter.locale = .en
		return formatter.string(for: self._rawValue) ?? "\(self._rawValue)"
	}
	
}

// MARK: - ValidatableCoordinateComponent

public protocol ValidatableCoordinateComponent: CoordinateComponent {

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
public protocol AngularCoordinateComponent: ValidatableCoordinateComponent {

	static var fullRotation: Self { get }
	static var halfRotation: Self { get }

	/// "N" or "E" depending on axis
	static var positiveDirectionChar: Character { get }

	/// "S" or "W" depending on axis
	static var negativeDirectionChar: Character { get }

	var decimalDegrees: Double { get set }
	var radians: Double { get set }

	init(decimalDegrees: Double)
	init(radians: Double)

}

public extension AngularCoordinateComponent {

	static var min: Self { -halfRotation }
	static var max: Self { halfRotation }

	var valid: Self {
		if isValid {
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

	init(radians: Double) {
		self.init(decimalDegrees: radians * 180.0 / .pi)
	}

}
