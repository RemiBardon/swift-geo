//
//  BinarySizeBenchmark1.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 31/01/2023.
//

import GeodeticGeometry
import NonEmpty
import TurfCore
import WGS84
import XCTest

final class BinarySizeBenchmark1: XCTestCase {

	func testPerformance() throws {
		let generator = { Coordinate2D(x: .random(), y: .random()) }
		let coordinates = Array(repeating: generator, count: 1_000).map { $0() }
		let points = MultiPoint<WGS84Geographic2DCRS>(coordinates: try! .init(coordinates))
		measure(metrics: [XCTMemoryMetric(), XCTClockMetric()]) {
			print(String(describing: points.center))
		}
	}

}
