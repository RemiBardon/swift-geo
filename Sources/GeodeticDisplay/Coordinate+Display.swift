//
//  Coordinate+Display.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

extension CoordinateComponent {

	public func decimalNotation(maxDigits: UInt8 = 6) -> String {
		DecimalNumberFormatter().string(for: self.rawValue, maxDigits: maxDigits)
	}

}

extension AngularCoordinateComponent {
	
	public var directionChar: Character {
		return self.decimalDegrees < .zero ? Self.negativeDirectionChar : Self.positiveDirectionChar
	}
	
	/// `(dd - deg) * 60`
	public var minutes: Double {
		return decimalDegrees.swiftgeo_fraction * 60
	}
	
	/// `(|(dd - deg) * 60| - min) * 60`
	public var seconds: Double {
		return minutes.swiftgeo_fraction * 60
	}
	
	public init(degrees: Int, minutes: Double) {
		self.init(decimalDegrees: Double(degrees) + minutes / 60)
	}
	
	public init(degrees: Int, minutes: Int, seconds: Double) {
		self.init(degrees: degrees, minutes: Double(minutes) + seconds / 60)
	}
	
}

// MARK: - GeographicNotation

extension AngularCoordinateComponent {
	
	public func ddNotation(maxDigits: UInt8 = 6) -> String {
		DecimalNumberFormatter().string(for: self.decimalDegrees, maxDigits: maxDigits)
	}
	
	public func dmNotation(full: Bool = false, maxDigits: UInt8 = 3) -> String {
		// Degree
		var parts = ["\(Int(abs(decimalDegrees.swiftgeo_whole)))°"]
		
		// Minute
		if full || self.minutes > 0 {
			let formatter = DecimalNumberFormatter()
			let string = formatter.string(for: self.minutes, maxDigits: maxDigits)
			parts.append("\(string)'")
		}
		
		// Letter
		parts.append(String(self.directionChar))
		return parts.joined(separator: " ")
	}
	
	public func dmsNotation(full: Bool = false, maxDigits: UInt8 = 1) -> String {
		// Degree
		var parts = ["\(Int(abs(decimalDegrees.swiftgeo_whole)))°"]
		
		// Minute
		if full || self.minutes > 0 { parts.append("\(Int(self.minutes.swiftgeo_whole))'") }
		
		// Second
		if full || self.seconds > 0 {
			let formatter = DecimalNumberFormatter()
			let string = formatter.string(for: self.seconds, maxDigits: maxDigits)
			parts.append("\(string)\"")
		}
		
		// Letter
		parts.append(String(self.directionChar))
		return parts.joined(separator: " ")
	}
	
}
