//
//  SnapshotTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 18/09/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import SnapshotTesting
import Turf
import WGS84Core
import WGS84Geometry
import XCTest

final class SnapshotTests: XCTestCase {

	override func setUp() {
		self.continueAfterFailure = false
	}

	@MainActor
	func testCubicBezier() async throws {
		let square = LineString2D(coordinates: .init(
			.init(x:  0, y:  0),
			.init(x:  0, y: 10),
			.init(x: 10, y: 10),
			.init(x: 10, y:  0)
		)).closed()
		let snap10 = try await snapshot(square)
		assertSnapshot(matching: snap10, as: .image(precision: 0.99), named: "square")

		let squareBezier1 = square.bezier(sharpness: 1, resolution: 2)
		let snap11 = try await snapshot(squareBezier1)
		assertSnapshot(matching: snap11, as: .image(precision: 0.99), named: "squareBezier1")

		let squareBezier2 = square.bezier(sharpness: 0.5, resolution: 10)
		let snap12 = try await snapshot(squareBezier2)
		assertSnapshot(matching: snap12, as: .image(precision: 0.99), named: "squareBezier2")

		let squareBezier3 = square.bezier(sharpness: 0, resolution: 10)
		let snap13 = try await snapshot(squareBezier3)
		assertSnapshot(matching: snap13, as: .image(precision: 0.99), named: "squareBezier3")

		let route = LineString2D(coordinates: .init(
			.init(latitude: 48.864716, longitude:  2.394014), // Paris
			.init(latitude: 47.218102, longitude: -1.552800), // Nantes
			.init(latitude: 44.836151, longitude: -0.580816), // Bordeaux
			.init(latitude: 48.580002, longitude:  7.750000), // Strasbourg
			.init(latitude: 50.629250, longitude:  3.057256)  // Lille
		)).closed()
		let snap20 = try await snapshot(route)
		assertSnapshot(matching: snap20, as: .image(precision: 0.99), named: "route")

		let routeBezier2 = route.bezier(sharpness: 0.5, resolution: 10)
		let snap22 = try await snapshot(routeBezier2)
		assertSnapshot(matching: snap22, as: .image(precision: 0.99), named: "routeBezier2")
	}

}
