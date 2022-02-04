//
//  CoordinateTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@testable import GeoModels
import XCTest

final class CoordinateTests: XCTestCase {
	
	private static func generate<T: ValidatableCoordinate>(
		_ count: Int,
		randomCoordinatesIn range: Range<T>
	) -> [T] where T.RawSignificand: FixedWidthInteger {
		Array(repeating: { T.random(in: range) }, count: count).map { $0() }
	}
	private static func generate<T: ValidatableCoordinate>(
		_ count: Int,
		randomCoordinatesIn range: ClosedRange<T>
	) -> [T] where T.RawSignificand: FixedWidthInteger {
		Array(repeating: { T.random(in: range) }, count: count).map { $0() }
	}
	private static func generate<T: ValidatableCoordinate>(
		_ count: Int,
		randomCoordinatesUsing generator: @escaping () -> T
	) -> [T] {
		Array(repeating: generator, count: count).map { $0() }
	}
	
	func testValidLatitudes() {
		test(Latitude.self)
	}
	
	func testValidLongitudes() {
		test(Longitude.self)
	}
	
	func test<C: AngularCoordinate>(_ type: C.Type) where C.RawSignificand: FixedWidthInteger {
		// Special values
		test(C.max,  isValid: true, equals: .max )
		test(C.zero, isValid: true, equals: .zero)
		test(C.min,  isValid: true, equals: .min )
		
		// Valid
		Self.generate(16, randomCoordinatesIn: C.validRange)
			.forEach { test($0, isValid: true, equals: $0) }
		
		// Positive, invalid
		Self.generate(16, randomCoordinatesIn: C.max.nextUp...C.fullRotation)
			.forEach { test($0, isValid: false, equals: $0 - .fullRotation) }
		
		// Negative, invalid
		Self.generate(16, randomCoordinatesIn: (-C.fullRotation)..<C.min)
			.forEach { test($0, isValid: false, equals: $0 + .fullRotation) }
		
		// Exactly 1 rotation
		test( C.fullRotation, isValid: false, equals: 0)
		test(-C.fullRotation, isValid: false, equals: 0)
		
		// Exactly 2 rotations
		test( 2 * C.fullRotation, isValid: false, equals: 0)
		test(-2 * C.fullRotation, isValid: false, equals: 0)
		
		// Positive, 2 or more rotations
		Self.generate(4, randomCoordinatesIn: C.validRange)
			.forEach {
				let offsetLong = $0 + (C(Int.random(in: 2...8)) * .fullRotation)
				test(offsetLong, isValid: false, almostEquals: $0)
			}
		
		// Negative, 2 or more rotations
		Self.generate(4, randomCoordinatesIn: C.validRange)
			.forEach {
				let offsetLong = $0 - (C(Int.random(in: 2...8)) * .fullRotation)
				test(offsetLong, isValid: false, almostEquals: $0)
			}
	}
	
	func test<C: AngularCoordinate>(_ value: C, isValid: Bool, equals: C) {
		XCTAssertEqual(value.isValid, isValid)
		XCTAssertEqual(value.valid, equals)
	}
	func test<C: AngularCoordinate>(_ value: C, isValid: Bool, almostEquals: C) {
		XCTAssertEqual(value.isValid, isValid)
		XCTAssertLessThan(value.valid.distance(to: almostEquals), 0.000_001)
	}
	
}
