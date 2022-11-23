//
//  Display.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

#if canImport(GeodeticDisplay)
import GeodeticDisplay

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

extension Coordinate3D: GeographicNotation {

	public func ddNotation(maxDigits: UInt8) -> String {
		let lat = self.latitude.ddNotation(maxDigits: maxDigits)
		let long = self.longitude.ddNotation(maxDigits: maxDigits)
		let alt = self.altitude.decimalNotation(maxDigits: maxDigits)
		return "\(lat), \(long), \(alt)"
	}

	public func dmNotation(full: Bool = false, maxDigits: UInt8) -> String {
		let lat = self.latitude.dmNotation(full: full, maxDigits: maxDigits)
		let long = self.longitude.dmNotation(full: full, maxDigits: maxDigits)
		let alt = self.altitude.decimalNotation(maxDigits: maxDigits)
		return "\(lat), \(long), \(alt)"
	}

	public func dmsNotation(full: Bool = false, maxDigits: UInt8) -> String {
		let lat = self.latitude.dmsNotation(full: full, maxDigits: maxDigits)
		let long = self.longitude.dmsNotation(full: full, maxDigits: maxDigits)
		let alt = self.altitude.decimalNotation(maxDigits: maxDigits)
		return "\(lat), \(long), \(alt)"
	}

}
#endif
