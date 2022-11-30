//
//  GeodeticConversionsTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 30/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticConversions
import WGS84Core
import WGS84Conversions
import XCTest

final class GeodeticConversionsTests: XCTestCase {

	func test2DTo3DUsesTransitiveDefinition() {
		let c1: Coordinate2D = Coordinate2D(x: 0.1, y: 0.1)
		let transitive1: Coordinate2D = c1.to3D(Coordinate3D.CRS.self).to2D(Coordinate2D.CRS.self)
		let transitive2: Coordinate2D = c1.to(Coordinate3D.CRS.self).to(Coordinate2D.CRS.self)
		let nonTransitive: Coordinate2D = c1.toEPSG4978().fromEPSG4978()

		XCTAssertEqual(transitive1, c1)
		XCTAssertEqual(transitive2, c1)
		// FIXME: Find a way to test this once round tripping works
		XCTAssertNotEqual(nonTransitive, c1)
	}

	func testRoundTripping() throws {
		throw XCTSkip("Round tripping doesn't work")
//		let expected: Coordinate2D = Coordinate2D(x: 0.1, y: 0.1)
//		let res: Coordinate2D = expected.toEPSG4978().fromEPSG4978()
//		XCTAssertEqual(res, expected)
	}

}
