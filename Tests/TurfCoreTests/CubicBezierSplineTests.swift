//
//  CubicBezierSplineTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 23/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import typealias NonEmpty.AtLeast2
@testable import struct TurfCore.CubicBezierSpline
import WGS84Core
import XCTest

final class CubicBezierSplineTests: XCTestCase {

	typealias CRS2D = EPSG4326
	typealias Spline = CubicBezierSpline<CRS2D>

	func testPointBetween() {
		let a = Coordinate2D(x: 10, y: 10)
		let b = Coordinate2D(x: 20, y: 20)
		let res = Spline.pointBetween(a, and: b, fraction: 0.5)
		XCTAssertEqual(res, Coordinate2D(x: 15, y: 15))
	}

	func testPointInQuadCurve() {
		let a = Coordinate2D(x: 10, y: 10)
		let b = Coordinate2D(x: 20, y: 20)
		let c = Coordinate2D(x: 30, y: 10)
		let res = Spline.pointInQuadCurve(a, b, c, fraction: 0.5)
		XCTAssertEqual(res, Coordinate2D(x: 20, y: 15))
	}

	func testControlPoints() {
		let a = Coordinate2D(x: 10, y: 10)
		let b = Coordinate2D(x: 20, y: 20)
		let c = Coordinate2D(x: 30, y: 10)
		let res1 = Spline(coordinates: AtLeast2<[Coordinate2D]>(a, b, c), sharpness: 1)
		XCTAssertEqual(res1.controls.map(controlsToString), [
			"((10, 10),(10, 10),(20, 20),(20, 20))",
			"((20, 20),(20, 20),(30, 10),(30, 10))"
		])
		let res2 = Spline(coordinates: AtLeast2<[Coordinate2D]>(a, b, c), sharpness: 0)
		XCTAssertEqual(res2.controls.map(controlsToString), [
			"((10, 10),(10, 10),(15, 20),(20, 20))",
			"((20, 20),(25, 20),(30, 10),(30, 10))"
		])
	}

	func controlsToString(
		_ controls: (Coordinate2D, Coordinate2D, Coordinate2D, Coordinate2D)
	) -> String {
		"""
		(\
		(\(controls.0.ddNotation)),\
		(\(controls.1.ddNotation)),\
		(\(controls.2.ddNotation)),\
		(\(controls.3.ddNotation))\
		)
		"""
	}

}
