//
//  Coordinate+Display.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import class Foundation.NumberFormatter
import class Foundation.NSNumber
import Geodesy

extension CoordinateComponent {

	public func decimalNotation(maxDigits: UInt8 = 6) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		return formatter.string(for: self.rawValue) ?? String(describing: self.rawValue)
	}

}

extension AngularCoordinateComponent {
	
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

extension AngularCoordinateComponent {
	
	public func ddNotation(maxDigits: UInt8 = 6) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		return formatter.string(for: decimalDegrees) ?? String(decimalDegrees)
	}
	
	public func dmNotation(full: Bool = false, maxDigits: UInt8 = 3) -> String {
		// Degree
		var parts = ["\(Int(abs(decimalDegrees.whole)))°"]
		
		// Minute
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = Int(maxDigits)
		formatter.locale = .en
		if full || minutes > 0, let string = formatter.string(for: minutes) {
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
		if full || seconds > 0, let string = formatter.string(for: seconds) {
			parts.append("\(string)\"")
		}
		
		// Letter
		parts.append(String(directionChar))
		return parts.joined(separator: " ")
	}
	
}
