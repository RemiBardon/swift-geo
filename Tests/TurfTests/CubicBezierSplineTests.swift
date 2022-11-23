//
//  CubicBezierSplineTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 23/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import SwiftGeoToolbox
@testable import struct Turf.CubicBezierSpline
import WGS84
import XCTest

final class CubicBezierSplineTests: XCTestCase {

	func testPointBetween() {
		let a = Coordinate2D(x: 10, y: 10)
		let b = Coordinate2D(x: 20, y: 20)
		let res = CubicBezierSpline<WGS842D>.pointBetween(a, and: b, fraction: 0.5)
		XCTAssertEqual(res, Coordinate2D(x: 15, y: 15))
	}

	func testPointInQuadCurve() {
		let a = Coordinate2D(x: 10, y: 10)
		let b = Coordinate2D(x: 20, y: 20)
		let c = Coordinate2D(x: 30, y: 10)
		let res = CubicBezierSpline<WGS842D>.pointInQuadCurve(a, b, c, fraction: 0.5)
		XCTAssertEqual(res, Coordinate2D(x: 20, y: 15))
	}

}
