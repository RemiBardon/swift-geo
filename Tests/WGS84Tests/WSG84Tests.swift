//
//  WGS84Tests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import GeodeticConversions
import WGS84
import XCTest

final class ConversionTests: XCTestCase {
	/// Example from <https://epsg.io/transform#s_srs=4979&t_srs=4978&x=90&y=0>.
	func testEPSG9602() {
		let c1 = Coordinate2D(x: 0, y: 90)
		let c2 = c1.to(WGS84Geographic3DCRS.self)
		XCTAssertEqual(c2, Coordinate3D(x: 0, y: 90, z: 0))
		let c3 = c2.to(WGS84GeocentricCRS.self)
		XCTAssertEqual(c3, Coordinates3DOf<WGS84GeocentricCRS>(
			x: 3.905482530786651e-10,
			y: .init(WGS84Ensemble.Ellipsoid.semiMajorAxis),
			z: 0
		))
		let c4 = c3.to(WGS84Geographic3DCRS.self)
		XCTAssertEqual(c4, Coordinate3D(x: 0, y: 90, z: 0))
		let c5 = c4.to(WGS84Geographic2DCRS.self)
		XCTAssertEqual(c5, c1)
	}

	func testCoordinateComponentsUnit() {
		XCTAssertEqual(Coordinate2D.X(10).decimalDegrees, 10)
		XCTAssertEqual(Coordinate2D.Y(10).decimalDegrees, 10)
	}
}
