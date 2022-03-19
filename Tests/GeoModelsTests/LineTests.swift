//
//  LineTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels
import XCTest

final class LineTests: XCTestCase {
	
	func testLine2DCrosses180thMeridian() throws {
		self.continueAfterFailure = true
		
		func test(from longitude1: Longitude, to longitude2: Longitude, crosses: Bool) {
			let start = Coordinate2D(latitude: 0, longitude: longitude1)
			let end = Coordinate2D(latitude: 0, longitude: longitude2)
			let line = Line2D(start: start, end: end)
			
			XCTAssertEqual(
				line.crosses180thMeridian,
				crosses,
				"From \(longitude1) to \(longitude2): longitudeDelta=\(line.longitudeDelta), minimalLongitudeDelta=\(line.minimalLongitudeDelta)"
			)
		}
		
		// Exactly 0° length
		test(from: -180, to: -180, crosses: false)
		test(from:  -90, to:  -90, crosses: false)
		test(from:    0, to:    0, crosses: false)
		test(from:   90, to:   90, crosses: false)
		test(from:  180, to:  180, crosses: false)
		
		// Exactly 180° length
		test(from:    0, to: 180, crosses: false)
		test(from:  -90, to:  90, crosses: false)
		test(from: -180, to:   0, crosses: false)
		
		throw XCTSkip("FIXME")
		
		// A bit more than 180° length
		test(from:   -1, to: 180, crosses: true)
		test(from:  -91, to:  90, crosses: true)
		test(from: -180, to:   1, crosses: true)
		
		// Almost 360° length
		test(from: -179, to: 180, crosses: false)
		test(from: -180, to: 179, crosses: false)
		test(from: 179, to: -180, crosses: true)
		test(from: 180, to: -179, crosses: true)
		
		// Exactly 360° length
		test(from: -180, to: 180, crosses: false)
		test(from: 180, to: -180, crosses: true)
	}
	
	func testLine2DMinimalLongitudeDelta() {
		self.continueAfterFailure = true
		
		func test(from longitude1: Longitude, to longitude2: Longitude, equals minimalDelta: Longitude) {
			let start = Coordinate2D(latitude: 0, longitude: longitude1)
			let end = Coordinate2D(latitude: 0, longitude: longitude2)
			let line = Line2D(start: start, end: end)
			
			XCTAssertEqual(
				line.minimalLongitudeDelta,
				minimalDelta,
				"From \(longitude1) to \(longitude2): longitudeDelta=\(line.longitudeDelta), minimalLongitudeDelta=\(line.minimalLongitudeDelta)"
			)
		}
		
		func symetricTest(between longitude1: Longitude, and longitude2: Longitude, equals minimalDelta: Longitude) {
			test(from: longitude1, to: longitude2, equals: minimalDelta)
			test(from: longitude2, to: longitude1, equals: minimalDelta)
		}
		
		// Exactly 0° length
		symetricTest(between: -180, and: -180, equals: 0)
		symetricTest(between:  -90, and:  -90, equals: 0)
		symetricTest(between:    0, and:    0, equals: 0)
		
		// Exactly 180° length
		symetricTest(between:    0, and: 180, equals: 180)
		symetricTest(between:  -90, and:  90, equals: 180)
		symetricTest(between: -180, and:   0, equals: 180)
		
		// A bit more than 180° length
		test(from:   -1, to: 180, equals: -179)
		test(from:  -91, to:  90, equals: -179)
		test(from: -180, to:   1, equals: -179)
		test(from:   1, to: -180, equals:  179)
		test(from:  91, to:  -90, equals:  179)
		test(from: 180, to:   -1, equals:  179)
		
		// Almost 360° length
		test(from: -179, to: 180, equals: -1)
		test(from: -180, to: 179, equals: -1)
		test(from: 179, to: -180, equals:  1)
		test(from: 180, to: -179, equals:  1)
		
		// Exactly 360° length
		symetricTest(between: -180, and: 180, equals: 0)
	}
	
	func testLine2DNonEmpty() {
		XCTAssertEqual(Line2D(start: .zero, end: .zero).points.count, 2)
	}
	
}
