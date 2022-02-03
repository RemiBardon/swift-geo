//
//  GeoModels+CoreLocationTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@testable import GeoModels
import XCTest
import Algorithms

final class GeoModelsCoreLocationTests: XCTestCase {
	
	func testCoordinate2DToCoreLocationCoordinate() {
		func test(latitude: Latitude, longitude: Longitude) {
			let coordinate = Coordinate2D(latitude: latitude, longitude: longitude)
			let clLocationCoordinate = coordinate.clLocationCoordinate2D
			
			XCTAssertEqual(clLocationCoordinate.latitude, coordinate.latitude.degrees)
			XCTAssertEqual(clLocationCoordinate.longitude, coordinate.longitude.degrees)
		}
		
		let latitudes: [Latitude] = [-90, -89, -45, 0, 45, 89, 90]
			+ Array(repeating: Latitude.random, count: 8).map { $0() }
		let longitudes: [Longitude] = [-180, -179, -90, 0, 90, 179, 180]
			+ Array(repeating: Longitude.random, count: 8).map { $0() }
		
		product(latitudes, longitudes).forEach(test(latitude:longitude:))
	}
	
}
