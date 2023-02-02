//
//  GeographicNotation.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 25/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol GeographicNotation {
	
	/// Decimal Degree notation.
	@inlinable func ddNotation(maxDigits: UInt8) -> String
	
	/// Degree Minute notation (with or without `0` values).
	@inlinable func dmNotation(full: Bool, maxDigits: UInt8) -> String
	
	/// Degree Minute Second notation (with or without `0` values).
	@inlinable func dmsNotation(full: Bool, maxDigits: UInt8) -> String
	
}

extension GeographicNotation {
	
	/// Decimal Degree notation.
	@inlinable public var ddNotation: String {
		self.ddNotation(maxDigits: 6)
	}
	
	/// Degree Minute notation.
	@inlinable public var dmNotation: String {
		self.dmNotation(maxDigits: 3)
	}
	
	/// Degree Minute Second notation.
	@inlinable public var dmsNotation: String {
		self.dmsNotation(maxDigits: 4)
	}
	
	/// Degree Minute notation.
	@inlinable public func dmNotation(maxDigits: UInt8) -> String {
		self.dmNotation(full: false, maxDigits: maxDigits)
	}
	
	/// Degree Minute Second notation.
	@inlinable public func dmsNotation(maxDigits: UInt8) -> String {
		self.dmsNotation(full: false, maxDigits: maxDigits)
	}
	
}
