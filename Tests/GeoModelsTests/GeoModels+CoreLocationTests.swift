//
//  GeoModels+CoreLocationTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
@testable import GeoModels
import XCTest
import Algorithms
import CoreLocation

final class GeoModelsCoreLocationTests: XCTestCase {
	
	static var testLatitudes: [Latitude] {
		return [-90, -89, -45, 0, 45, 89, 90]
			+ Array(repeating: Latitude.random, count: 8).map { $0() }
	}
	
	static var testLongitudes: [Longitude] {
		return [-180, -179, -90, 0, 90, 179, 180]
			+ Array(repeating: Longitude.random, count: 8).map { $0() }
	}
	
	static var testCoordinates: [Coordinate2D] {
		return product(testLatitudes, testLongitudes).map(Coordinate2D.init(latitude:longitude:))
	}
	
	func testCoordinate2DFromCoreLocationCoordinate() {
		let testValues = product(Self.testLatitudes, Self.testLongitudes)
			.map { ($0.0.degrees, $0.1.degrees) }
			.map(CLLocationCoordinate2D.init(latitude:longitude:))
		
		testValues.forEach { clLocationCoordinate in
			let coordinate = Coordinate2D(clLocationCoordinate)
			
			XCTAssertEqual(coordinate.latitude.degrees, clLocationCoordinate.latitude)
			XCTAssertEqual(coordinate.longitude.degrees, clLocationCoordinate.longitude)
		}
	}
	
	func testCoordinate2DFromCoreLocation() {
		let testValues = product(Self.testLatitudes, Self.testLongitudes)
			.map { ($0.0.degrees, $0.1.degrees) }
			.map(CLLocation.init(latitude:longitude:))
		
		testValues.forEach { clLocation in
			let coordinate = Coordinate2D(clLocation)
			
			XCTAssertEqual(coordinate.latitude.degrees, clLocation.coordinate.latitude)
			XCTAssertEqual(coordinate.longitude.degrees, clLocation.coordinate.longitude)
		}
	}
	
	func testCoordinate2DToCoreLocationCoordinate() {
		Self.testCoordinates.forEach { coordinate in
			let clLocationCoordinate = coordinate.clLocationCoordinate2D
			
			XCTAssertEqual(clLocationCoordinate.latitude, coordinate.latitude.degrees)
			XCTAssertEqual(clLocationCoordinate.longitude, coordinate.longitude.degrees)
		}
	}
	
	func testCoordinate2DToCoreLocation() {
		Self.testCoordinates.forEach { coordinate in
			let clLocation = coordinate.clLocation
			
			XCTAssertEqual(clLocation.coordinate.latitude, coordinate.latitude.degrees)
			XCTAssertEqual(clLocation.coordinate.longitude, coordinate.longitude.degrees)
		}
	}
	
}
#endif
