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

public typealias CoordinateComponent = ValueWithUnit.Value

// MARK: CustomStringConvertible & CustomDebugStringConvertible

public extension CoordinateComponent {
	var description: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 9
		formatter.locale = .en
		return formatter.string(for: Double(self.rawValue)) ?? String(describing: self.rawValue)
	}
	var debugDescription: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.locale = .en
		formatter.maximumFractionDigits = 99
		return formatter.string(for: Double(self.rawValue)) ?? String(reflecting: self.rawValue)
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
