//
//  AngularCoordinate.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol AngularCoordinate: ValidatableCoordinate, GeographicNotation {
	
	static var fullRotation: Self { get }
	static var halfRotation: Self { get }
	
	/// "N" or "E" depending on axis
	static var positiveDirectionChar: Character { get }
	
	/// "S" or "W" depending on axis
	static var negativeDirectionChar: Character { get }
	
	var decimalDegrees: Double { get set }
	
	init(decimalDegrees: Double)
	
}

extension AngularCoordinate {
	
	public var value: Double {
		get { decimalDegrees }
		set { decimalDegrees = newValue }
	}
	
	public init(value: Double) {
		self.init(decimalDegrees: value)
	}
	
}

// TODO: Create custom struct that handles cycling in an interval

/// The latitude component of a geographical coordinate.
public struct Latitude: AngularCoordinate {
	
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

/// The longitude component of a geographical coordinate.
public struct Longitude: AngularCoordinate {
	
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

extension AngularCoordinate {
	
	public static var min: Self { -halfRotation }
	public static var max: Self { halfRotation }
	
	public var valid: Self {
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
	
}
