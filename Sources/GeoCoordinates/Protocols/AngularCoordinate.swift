//
//  AngularCoordinate.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// - Todo: Create custom struct that handles cycling in an interval.
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
