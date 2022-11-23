//
//  CoordinatesTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 21/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import WGS84Core
import XCTest

final class CoordinatesTests: XCTestCase {

	// MARK: - Init from literal

	func testInitFromFloatLiteral() {
		XCTAssertEqual(Coordinate2D(x: 0.0, y: 0.0), Coordinate2D.zero)
		let c = Coordinate2D(x: 5.0, y: 10.0)
		XCTAssertEqual(c.x, 5)
		XCTAssertEqual(c.y, 10)
	}

	func testInitFromIntegerLiteral() {
		XCTAssertEqual(Coordinate2D(x: 0, y: 0), Coordinate2D.zero)
		let c = Coordinate2D(x: 5, y: 10)
		XCTAssertEqual(c.x, 5.0)
		XCTAssertEqual(c.y, 10.0)
	}

	// MARK: - Plus operator

	func testPlusZero() {
		let c = Coordinate2D(x: 10, y: 10)
		let res = c + Coordinate2D.zero
		let expected = c
		XCTAssertEqual(res, expected)
	}

	func testPlusSelf() {
		let c = Coordinate2D(x: 10, y: 10)
		let res = c + c
		let expected = Coordinate2D(x: 20, y: 20)
		XCTAssertEqual(res, expected)
	}

	func testPlusPositive() {
		let res = Coordinate2D(x: 10, y: 10) + Coordinate2D(x: 2, y: 4)
		let expected = Coordinate2D(x: 12, y: 14)
		XCTAssertEqual(res, expected)
	}

	func testPlusNegative() {
		let res = Coordinate2D(x: -10, y: -10) + Coordinate2D(x: 2, y: 4)
		let expected = Coordinate2D(x: -8, y: -6)
		XCTAssertEqual(res, expected)
	}

	func testPlusAroundZero() {
		let res = Coordinate2D(x: 10, y: 10) + Coordinate2D(x: -15, y: -20)
		let expected = Coordinate2D(x: -5, y: -10)
		XCTAssertEqual(res, expected)
	}

	// MARK: - Minus operator

	func testMinusZero() {
		let c = Coordinate2D(x: 10, y: 10)
		let res = c - Coordinate2D.zero
		let expected = c
		XCTAssertEqual(res, expected)
	}

	func testMinusSelf() {
		let c = Coordinate2D(x: 10, y: 10)
		let res = c - c
		let expected = Coordinate2D.zero
		XCTAssertEqual(res, expected)
	}

	func testMinusPositive() {
		let res = Coordinate2D(x: 10, y: 10) - Coordinate2D(x: 2, y: 4)
		let expected = Coordinate2D(x: 8, y: 6)
		XCTAssertEqual(res, expected)
	}

	func testMinusNegative() {
		let res = Coordinate2D(x: -10, y: -10) - Coordinate2D(x: -2, y: -4)
		let expected = Coordinate2D(x: -8, y: -6)
		XCTAssertEqual(res, expected)
	}

	func testMinusAroundZero() {
		let res = Coordinate2D(x: 10, y: 10) - Coordinate2D(x: 15, y: 20)
		let expected = Coordinate2D(x: -5, y: -10)
		XCTAssertEqual(res, expected)
	}

	// MARK: - Times operator

	func testTimesZero() {
		let c = Coordinate2D(x: 10, y: 10)
		XCTAssertEqual(c * Coordinate2D.zero, Coordinate2D.zero)
	}

	func testTimesOne() {
		let c = Coordinate2D(x: 10, y: 10)
		XCTAssertEqual(c * Coordinate2D(x: 1, y: 1), c)
	}

	func testTimesPositive() {
		let res = Coordinate2D(x: 10, y: 10) * Coordinate2D(x: 2, y: 4)
		let expected = Coordinate2D(x: 20, y: 40)
		XCTAssertEqual(res, expected)
	}

	func testTimesNegative() {
		let res = Coordinate2D(x: -10, y: -10) * Coordinate2D(x: -2, y: -4)
		let expected = Coordinate2D(x: 20, y: 40)
		XCTAssertEqual(res, expected)
	}

	func testTimesAroundZero() {
		let res = Coordinate2D(x: 10, y: 10) * Coordinate2D(x: -2, y: -4)
		let expected = Coordinate2D(x: -20, y: -40)
		XCTAssertEqual(res, expected)
	}

}
