//
//  Latitude.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

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
