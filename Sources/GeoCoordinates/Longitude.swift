//
//  Longitude.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

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
