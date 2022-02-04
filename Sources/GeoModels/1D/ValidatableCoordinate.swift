//
//  ValidatableCoordinate.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol ValidatableCoordinate: Coordinate {
	
	static var min: Self { get }
	static var max: Self { get }
	
	/// Tells if this value is in valid bounds or not.
	var isValid: Bool { get }
	
	/// A copy of this value, in valid bounds.
	///
	/// In angular coordinate system, it means rotating the value
	/// to put it in the valid range.
	///
	/// In linear coordinate system, it can mean making the value positive.
	var valid: Self { get }
	
}

extension  ValidatableCoordinate {
	
	static var validRange: ClosedRange<Self> { min...max }
	
	public var isValid: Bool {
		Self.validRange.contains(self)
	}
	
}
