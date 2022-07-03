//
//  CoordinateDisplayTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates
import XCTest

final class GeoModelsDisplayTests: XCTestCase {
	
	func testDms() {
		let coord1 = Coordinate2D(latitude: 42.20960219, longitude: 76.90894410)
		XCTAssertEqual(coord1.dmsNotation, "42° 12' 34.5679\" N, 76° 54' 32.1988\" E")
		XCTAssertEqual(coord1.dmsNotation(maxDigits: 3), "42° 12' 34.568\" N, 76° 54' 32.199\" E")
		XCTAssertEqual(coord1.dmsNotation(maxDigits: 5), "42° 12' 34.56788\" N, 76° 54' 32.19876\" E")
		
		let coord2 = Coordinate2D(latitude: -42.20960219, longitude: -76.90894410)
		XCTAssertEqual(coord2.dmsNotation, "42° 12' 34.5679\" S, 76° 54' 32.1988\" W")
	}
	
}
