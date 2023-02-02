//
//  GeodeticDisplayTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 17/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import WGS84Core
import XCTest

final class GeodeticDisplayTests: XCTestCase {

	func testDescriptions() {
		let coord = Coordinate2D(x: 1.1232456789, y: -10.1232456789)
		XCTAssertEqual(String(describing: coord), "(1.12324568, -10.12324568)")
		XCTAssertEqual(
			String(reflecting: coord),
			"<WGS 84 (geographic 2D)>(1.12324568, -10.12324568)"
		)
		XCTAssertEqual(coord.ddNotation, "1.123246, -10.123246")
		XCTAssertEqual(coord.dmNotation, "1° 7.395' N, 10° 7.395' W")
		XCTAssertEqual(coord.dmsNotation, #"1° 7' 23.6844" N, 10° 7' 23.6844" W"#)
	}

}
