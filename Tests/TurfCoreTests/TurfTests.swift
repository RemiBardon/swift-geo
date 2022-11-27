//
//  TurfTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import TurfCore
import WGS84Core
import WGS84Geometry
import XCTest

final class TurfTests: XCTestCase {
	
	func testNaiveBBoxNeverCrosses180thMeridian() throws {
		func test(coordinates: [Coordinate2D], crosses: Bool) throws {
			let bbox = try XCTUnwrap(WGS842D.bbox(forCollection: coordinates))
			XCTAssertEqual(bbox.crosses180thMeridian, crosses, String(reflecting: bbox))
		}
		
		// Green: Across the world
		try test(coordinates: [
			.init(latitude: -65, longitude:  175),
			.init(latitude: -70, longitude: -170),
			.init(latitude: -80, longitude: -175),
			.init(latitude: -85, longitude:  145),
		], crosses: false)
		// Pink: Around Null Island's antipode
		try test(coordinates: [
			.init(latitude:  15, longitude: -160),
			.init(latitude: -15, longitude: -170),
			.init(latitude: -10, longitude:  160),
		], crosses: false)
	}
	
	func testGeographicBBoxCrosses180thMeridian() throws {
		func test(coordinates: [Coordinate2D], crosses: Bool) throws {
			let bbox = try XCTUnwrap(WGS842D.geographicBBox(forCollection: coordinates))
			XCTAssertEqual(bbox.crosses180thMeridian, crosses, String(reflecting: bbox))
		}
		
		// Green: Across the world
		try test(coordinates: [
			.init(latitude: -65, longitude:  175),
			.init(latitude: -70, longitude: -170),
			.init(latitude: -80, longitude: -175),
			.init(latitude: -85, longitude:  145),
		], crosses: true)
		// Pink: Around Null Island's antipode
		try test(coordinates: [
			.init(latitude:  15, longitude: -160),
			.init(latitude: -15, longitude: -170),
			.init(latitude: -10, longitude:  160),
		], crosses: true)
	}
	
	func testGeographicBBox() throws {
		func test(
			coordinates: [Coordinate2D],
			bottomLat: Coordinate2D.X,
			leftLong: Coordinate2D.Y,
			latDelta: Coordinate2D.X,
			longDelta: Coordinate2D.Y,
			file: StaticString = #filePath,
			line: UInt = #line
		) throws {
			let bbox = try XCTUnwrap(WGS842D.geographicBBox(forCollection: coordinates))
			
			let expectedOrigin = Coordinate2D(latitude: bottomLat, longitude: leftLong)
			
			XCTAssertEqual(bbox.origin, expectedOrigin, "Origin", file: file, line: line)
			XCTAssertEqual(bbox.dLat, latDelta, "Latitude delta", file: file, line: line)
			XCTAssertEqual(bbox.dLong, longDelta, "Longitude delta", file: file, line: line)
		}
		
		// Blue: Positive latitudes, positive longitudes
		try test(
			coordinates: [
				.init(latitude: 20, longitude: 10),
				.init(latitude: 40, longitude: 20),
				.init(latitude: 45, longitude: 40),
				.init(latitude: 35, longitude: 50),
				.init(latitude: 10, longitude: 35),
			],
			bottomLat: 10,
			leftLong: 10,
			latDelta: 35,
			longDelta: 40
		)
		// Orange: Around Null Island
		try test(
			coordinates: [
				.init(latitude:   5, longitude: -30),
				.init(latitude:  15, longitude:  10),
				.init(latitude: -20, longitude:   5),
				.init(latitude: -10, longitude: -15),
			],
			bottomLat: -20,
			leftLong: -30,
			latDelta: 35,
			longDelta: 40
		)
		// Purple: Positive and negative longitudes
		try test(
			coordinates: [
				.init(latitude: 80, longitude:  20),
				.init(latitude: 70, longitude: -15),
				.init(latitude: 65, longitude:  10),
			],
			bottomLat: 65,
			leftLong: -15,
			latDelta: 15,
			longDelta: 35
		)
		// Red: Negative latitudes, negative longitudes
		try test(
			coordinates: [
				.init(latitude: -20, longitude:  -80),
				.init(latitude: -45, longitude:  -75),
				.init(latitude: -50, longitude:  -80),
				.init(latitude: -40, longitude:  -95),
				.init(latitude: -40, longitude: -110),
				.init(latitude: -15, longitude: -100),
			],
			bottomLat: -50,
			leftLong: -110,
			latDelta: 35,
			longDelta: 35
		)
		// Brown: Twisted shape
		try test(
			coordinates: [
				.init(latitude: -30, longitude: 70),
				.init(latitude: -10, longitude: 65),
				.init(latitude: -40, longitude: 85),
				.init(latitude: -15, longitude: 95),
			],
			bottomLat: -40,
			leftLong: 65,
			latDelta: 30,
			longDelta: 30
		)
		// Green: Across the world
		try test(
			coordinates: [
				.init(latitude: -65, longitude:  175),
				.init(latitude: -70, longitude: -170),
				.init(latitude: -80, longitude: -175),
				.init(latitude: -85, longitude:  145),
			],
			bottomLat: -85,
			leftLong: 145,
			latDelta: 20,
			longDelta: (-170 + .fullRotation) - 145
		)
		// Pink: Around Null Island's antipode
		try test(
			coordinates: [
				.init(latitude:  15, longitude: -160),
				.init(latitude: -15, longitude: -170),
				.init(latitude: -10, longitude:  160),
			],
			bottomLat: -15,
			leftLong: 160,
			latDelta: 30,
			longDelta: 40
		)
	}
	
	func testLineBBox() throws {
		func test(line: Line2D, bbox expected: BoundingBox2D) throws {
			let bbox = try XCTUnwrap(line.bbox)
			XCTAssertEqual(bbox, expected)
		}

		let line1 = Line2D(
			start: Point2D(latitude: .min + 30, longitude: .min + 50),
			end: Point2D(latitude: .max - 10, longitude: .max - 10)
		)
		try test(line: line1, bbox: BoundingBox2D(
			southWest: line1.start.coordinates,
			northEast: line1.end.coordinates
		))
	}

	@MainActor
	func testCubicBezier() async throws {
		var lineString1 = LineString2D(coordinates: .init(
			.init(x:  0, y:  0),
			.init(x:  0, y: 10),
			.init(x: 10, y: 10),
			.init(x: 10, y:  0)
		))

		let bezier0 = lineString1.bezier(sharpness: 1, resolution: 1)
		XCTAssertEqual(bezier0, lineString1)

		let bezier1 = lineString1.bezier(sharpness: 1, resolution: 2)
		XCTAssertEqual(bezier1, LineString2D(coordinates: .init(
			.init(x:  0, y:  0),
			.init(x:  0, y:  5),
			.init(x:  0, y: 10),
			.init(x:  5, y: 10),
			.init(x: 10, y: 10),
			.init(x: 10, y:  5),
			.init(x: 10, y:  0)
		)))

		lineString1.close()

		let bezier10 = lineString1.bezier(sharpness: 1, resolution: 1)
		XCTAssertEqual(bezier10, lineString1)

		let bezier11 = lineString1.bezier(sharpness: 1, resolution: 2)
		XCTAssertEqual(bezier11, LineString2D(coordinates: .init(
			.init(x:  0, y:  0),
			.init(x:  0, y:  5),
			.init(x:  0, y: 10),
			.init(x:  5, y: 10),
			.init(x: 10, y: 10),
			.init(x: 10, y:  5),
			.init(x: 10, y:  0),
			.init(x:  5, y:  0),
			.init(x:  0, y:  0)
		)))
	}

	func testCubicBezierDescriptions() {
		let lineString1 = LineString2D(coordinates: .init(
			.init(x:  0, y:  0),
			.init(x:  0, y: 10),
			.init(x: 10, y: 10),
			.init(x: 10, y:  0)
		)).closed()

		let bezier20 = lineString1.bezier(sharpness: 0.5, resolution: 10)
		XCTAssertEqual(String(reflecting: bezier20), """
		<LineString | WGS 84 (geographic 2D)>\
		[(0, 0),(-0.3375, 0.55),(-0.6, 1.4),(-0.7875, 2.475),(-0.9, 3.7),(-0.9375, 5),(-0.9, 6.3),\
		(-0.7875, 7.525),(-0.6, 8.6),(-0.3375, 9.45),(0, 10),(0.55, 10.3375),(1.4, 10.6),\
		(2.475, 10.7875),(3.7, 10.9),(5, 10.9375),(6.3, 10.9),(7.525, 10.7875),(8.6, 10.6),\
		(9.45, 10.3375),(10, 10),(10.3375, 9.45),(10.6, 8.6),(10.7875, 7.525),(10.9, 6.3),\
		(10.9375, 5),(10.9, 3.7),(10.7875, 2.475),(10.6, 1.4),(10.3375, 0.55),(10, 0),(9.45, -0.3375),\
		(8.6, -0.6),(7.525, -0.7875),(6.3, -0.9),(5, -0.9375),(3.7, -0.9),(2.475, -0.7875),\
		(1.4, -0.6),(0.55, -0.3375),(0, 0)]
		""")

		let bezier21 = lineString1.bezier(sharpness: 0, resolution: 10)
		XCTAssertEqual(String(reflecting: bezier21), """
		<LineString | WGS 84 (geographic 2D)>\
		[(0, 0),(-0.675, 0.82),(-1.2, 1.76),(-1.575, 2.79),(-1.8, 3.88),(-1.875, 5),(-1.8, 6.12),\
		(-1.575, 7.21),(-1.2, 8.24),(-0.675, 9.18),(0, 10),(0.82, 10.675),(1.76, 11.2),(2.79, 11.575),\
		(3.88, 11.8),(5, 11.875),(6.12, 11.8),(7.21, 11.575),(8.24, 11.2),(9.18, 10.675),(10, 10),\
		(10.675, 9.18),(11.2, 8.24),(11.575, 7.21),(11.8, 6.12),(11.875, 5),(11.8, 3.88),\
		(11.575, 2.79),(11.2, 1.76),(10.675, 0.82),(10, 0),(9.18, -0.675),(8.24, -1.2),(7.21, -1.575),\
		(6.12, -1.8),(5, -1.875),(3.88, -1.8),(2.79, -1.575),(1.76, -1.2),(0.82, -0.675),(0, 0)]
		""")
	}
	
}
