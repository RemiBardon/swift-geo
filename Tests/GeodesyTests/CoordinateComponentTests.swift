//
//  CoordinateComponentTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 21/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import WGS84Core
import XCTest

final class CoordinateComponentTests: XCTestCase {

	typealias X = Coordinate2D.X

	// MARK: - Init from literal

	func testInitFromFloatLiteral() {
		XCTAssertEqual(X(0.0), X.zero)
		XCTAssertEqual(X(5.0).rawValue, 5)
	}

	func testInitFromIntegerLiteral() {
		XCTAssertEqual(X(0), X.zero)
		XCTAssertEqual(X(5).rawValue, 5.0)
	}

	// MARK: - Plus operator

	func testPlusZero() {
		let x = X(10)
		XCTAssertEqual(x + X.zero, x)
	}

	func testPlusSelf() {
		let x = X(10)
		XCTAssertEqual(x + x, X(20))
	}

	func testPlusPositive() {
		XCTAssertEqual(X(10) + X(2), X(12))
	}

	func testPlusNegative() {
		XCTAssertEqual(X(-10) + X(2), X(-8))
	}

	func testPlusAroundZero() {
		XCTAssertEqual(X(10) + X(-15), X(-5))
	}

	func testPlusMutating() {
		var x = X(10)
		x += X(2)
		XCTAssertEqual(x, X(12))
	}

	// MARK: - Minus operator

	func testMinusZero() {
		let x = X(10)
		XCTAssertEqual(x - X.zero, x)
	}

	func testMinusSelf() {
		let x = X(10)
		XCTAssertEqual(x - x, X.zero)
	}

	func testMinusPositive() {
		XCTAssertEqual(X(10) - X(2), X(8))
	}

	func testMinusNegative() {
		XCTAssertEqual(X(-10) - X(-2), X(-8))
	}

	func testMinusAroundZero() {
		XCTAssertEqual(X(10) - X(15), X(-5))
	}

	func testMinusMutating() {
		var x = X(10)
		x -= X(2)
		XCTAssertEqual(x, X(8))
	}

	// MARK: - Times operator

	func testTimesZero() {
		XCTAssertEqual(X(10) * X.zero, X.zero)
	}

	func testTimesOne() {
		let x = X(10)
		XCTAssertEqual(x * X(1), x)
	}

	func testTimesPositive() {
		XCTAssertEqual(X(10) * X(2), X(20))
	}

	func testTimesNegative() {
		XCTAssertEqual(X(-10) * X(-2), X(20))
	}

	func testTimesAroundZero() {
		XCTAssertEqual(X(10) * X(-5), X(-50))
	}

	func testTimesMutating() {
		var x = X(10)
		x *= X(2)
		XCTAssertEqual(x, X(20))
	}

	// MARK: - Divide operator

	func testDivideOne() {
		let x = X(10)
		XCTAssertEqual(x / X(1), x)
	}

	func testDividePositive() {
		XCTAssertEqual(X(10) / X(2), X(5))
	}

	func testDivideNegative() {
		XCTAssertEqual(X(-10) / X(-2), X(5))
	}

	func testDivideAroundZero() {
		XCTAssertEqual(X(10) / X(-5), X(-2))
	}

	func testDivideMutating() {
		var x = X(10)
		x /= X(2)
		XCTAssertEqual(x, X(5))
	}

	// MARK: FloatingPoint

	func testFloatingPointZero() {
		XCTAssertTrue(X.zero.isZero)
		XCTAssertFalse(X(1).isZero)
	}

	func testFloatingPointNaN() {
		XCTAssertTrue(X.nan.isNaN)
		XCTAssertTrue(X.signalingNaN.isSignalingNaN)
		XCTAssertFalse(X(1).isNaN)
		XCTAssertFalse(X(1).isSignalingNaN)
	}

	func testFloatingInfinity() {
		XCTAssertTrue(X.infinity.isInfinite)
		XCTAssertFalse(X.infinity.isFinite)
	}

	func testFloatingPointSign() {
		XCTAssertEqual(X( 10).sign, FloatingPointSign.plus)
		XCTAssertEqual(X(  0).sign, FloatingPointSign.plus)
		XCTAssertEqual(X( -0).sign, FloatingPointSign.plus)
		XCTAssertEqual(X(-10).sign, FloatingPointSign.minus)
	}

	func testFloatingPointComparison() {
		XCTAssertEqual(X(10), X(10))
		XCTAssertLessThan(X(10), X(20))
		XCTAssertLessThanOrEqual(X(10), X(10))
		XCTAssertGreaterThan(X(20), X(10))
		XCTAssertGreaterThanOrEqual(X(10), X(10))
	}

	func testFloatingPointSquareRoot() {
		var x = X(16)
		let expected = X(4)
		XCTAssertEqual(x.squareRoot(), expected)
		x.formSquareRoot()
		XCTAssertEqual(x, expected)
	}

	// MARK: Numeric

	func testNumericInit() {
		XCTAssertEqual(X(exactly: 1), X(1))
	}

	// MARK: Strideable

	func testStrideableDistance() {
		XCTAssertEqual(X(5).distance(to: X( 15)), X.Stride( 10))
		XCTAssertEqual(X(5).distance(to: X(-15)), X.Stride(-20))
	}

	// MARK: BinaryFloatingPoint

	func testBinaryFloatingPointInit() {
		XCTAssertEqual(X(Int(10)), X(10))
		XCTAssertEqual(X(Double(10)), X(10))
	}

}
