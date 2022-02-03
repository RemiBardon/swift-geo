//
//  TurfTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@testable import Turf
import XCTest
import GeoModels

class TurfTests: XCTestCase {
	
	func testPointsBoundingBoxCrosses180thMeridian() throws {
		func test(coordinates: [Coordinate2D], crosses: Bool) throws {
			let bbox = try XCTUnwrap(Turf.bbox(for: coordinates))
			XCTAssertEqual(bbox.crosses180thMeridian, crosses)
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
	
	func testMinimumBoundingBoxCrosses180thMeridian() throws {
		func test(coordinates: [Coordinate2D], crosses: Bool) throws {
			let bbox = try XCTUnwrap(Turf.minimumBBox(for: coordinates))
			XCTAssertEqual(bbox.crosses180thMeridian, crosses)
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
	
	func testMinimumBBox() throws {
		func test(
			coordinates: [Coordinate2D],
			topLat: Coordinate,
			leftLong: Coordinate,
			latDelta: Coordinate,
			longDelta: Coordinate
		) throws {
			let bbox = try XCTUnwrap(Turf.minimumBBox(for: coordinates))
			
			let expectedOrigin = Coordinate2D(latitude: topLat, longitude: leftLong)
			
			XCTAssertEqual(bbox.northWest, expectedOrigin, "Origin")
			XCTAssertEqual(bbox.height, latDelta, "Latitude delta")
			XCTAssertEqual(bbox.width, longDelta, "Longitude delta")
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
			topLat: 45,
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
			topLat: 15,
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
			topLat: 80,
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
			topLat: -15,
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
			topLat: -10,
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
			topLat: -65,
			leftLong: 145,
			latDelta: 20,
			longDelta: (-170 + 360) - 145
		)
		// Pink: Around Null Island's antipode
		try test(
			coordinates: [
				.init(latitude:  15, longitude: -160),
				.init(latitude: -15, longitude: -170),
				.init(latitude: -10, longitude:  160),
			],
			topLat: 15,
			leftLong: 160,
			latDelta: 30,
			longDelta: 40
		)
	}
	
}
