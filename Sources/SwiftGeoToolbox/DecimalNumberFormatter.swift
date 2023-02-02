//
//  DecimalNumberFormatter.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 12/01/2023.
//  Copyright © 2023 Rémi Bardon. All rights reserved.
//

import Foundation

public struct DecimalNumberFormatter {

	public init() {}

	/// - Note: [Rémi BARDON] This is a bad implementation, but I couldn't find
	///         a better/simpler one without using `Foundation`.
	@inlinable public func string<N: BinaryFloatingPoint>(for n: N, maxDigits: UInt8 = 6) -> String {
		let sign: String = n.sign == .minus ? "-" : ""
		let val: N = abs(n)
		let whole: String = String(format: "%d", Int(val.swiftgeo_whole))
		let fraction: String = String(String(
			format: "%.*g",
			arguments: [
				maxDigits,
				Double(val.swiftgeo_fraction),
			]
		).dropFirst())
		return sign + whole + fraction
	}

}
