//
//  Coordinate+Display.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import Foundation

extension Coordinate {
	
	public var directionChar: Character {
		return self.decimalDegrees < .zero ? Self.negativeDirectionChar : Self.positiveDirectionChar
	}
	
	/// `(dd - deg) * 60`
	public var minutes: Double {
		return decimalDegrees.fraction * 60
	}
	
	/// `(|(dd - deg) * 60| - min) * 60`
	public var seconds: Double {
		return minutes.fraction * 60
	}
	
	public init(degrees: Int, minutes: Double) {
		self.init(decimalDegrees: Double(degrees) + minutes / 60)
	}
	
	public init(degrees: Int, minutes: Int, seconds: Double) {
		self.init(degrees: degrees, minutes: Double(minutes) + seconds / 60)
	}
	
}

// MARK: - GeographicNotation

extension Coordinate {
	
	public func ddNotation(maxDigits: UInt8 = 6) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		return formatter.string(from: NSNumber(value: decimalDegrees)) ?? String(decimalDegrees)
	}
	
	public func dmNotation(full: Bool = false, maxDigits: UInt8 = 3) -> String {
		// Degree
		var parts = ["\(Int(abs(decimalDegrees.whole)))°"]
		
		// Minute
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		if full || minutes > 0, let string = formatter.string(from: NSNumber(value: minutes)) {
			parts.append("\(string)'")
		}
		
		// Letter
		parts.append(String(directionChar))
		return parts.joined(separator: " ")
	}
	
	public func dmsNotation(full: Bool = false, maxDigits: UInt8 = 1) -> String {
		// Degree
		var parts = ["\(Int(abs(decimalDegrees.whole)))°"]
		
		// Minute
		if full || minutes > 0 { parts.append("\(Int(minutes.whole))'") }
		
		// Second
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		if full || seconds > 0, let string = formatter.string(from: NSNumber(value: seconds)) {
			parts.append("\(string)\"")
		}
		
		// Letter
		parts.append(String(directionChar))
		return parts.joined(separator: " ")
	}
	
}

extension Coordinate2D: GeographicNotation {
	
	public func ddNotation(maxDigits: UInt8) -> String {
		let lat = self.latitude.ddNotation(maxDigits: maxDigits)
		let long = self.longitude.ddNotation(maxDigits: maxDigits)
		return "\(lat), \(long)"
	}
	
	public func dmNotation(full: Bool = false, maxDigits: UInt8) -> String {
		let lat = self.latitude.dmNotation(full: full, maxDigits: maxDigits)
		let long = self.longitude.dmNotation(full: full, maxDigits: maxDigits)
		return "\(lat), \(long)"
	}
	
	public func dmsNotation(full: Bool = false, maxDigits: UInt8) -> String {
		let lat = self.latitude.dmsNotation(full: full, maxDigits: maxDigits)
		let long = self.longitude.dmsNotation(full: full, maxDigits: maxDigits)
		return "\(lat), \(long)"
	}
	
}
