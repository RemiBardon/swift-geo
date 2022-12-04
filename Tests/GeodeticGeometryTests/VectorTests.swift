//
//  VectorTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/12/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import SwiftGeoToolbox
import WGS84Geometry
import XCTest

final class VectorTests: XCTestCase {

	func testVectorArithmetic() {
		XCTAssertEqual(
			Vector2D(from: .init(x: 10, y: 15), to: .init(x: 12, y: 18)),
			Vector2D(dx: 2, dy: 3)
		)
		XCTAssertEqual(
			Vector2D(dx: 4, dy: 6).half,
			Vector2D(dx: 2, dy: 3)
		)
		XCTAssertEqual(
			2 * Vector2D(dx: 4, dy: 6),
			Vector2D(dx: 8, dy: 12)
		)
	}

}
