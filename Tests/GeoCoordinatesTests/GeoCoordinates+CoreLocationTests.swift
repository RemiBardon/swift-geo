//
//  GeoCoordinates+CoreLocationTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 03/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(CoreLocation)
@testable import GeoCoordinates
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
	
	static var testCoordinates: [WGS84Coordinate2D] {
		return product(testLatitudes, testLongitudes).map(WGS84Coordinate2D.init(latitude:longitude:))
	}
	
	func testCoordinate2DFromCoreLocationCoordinate() {
		let testValues = product(Self.testLatitudes, Self.testLongitudes)
			.map { ($0.0.decimalDegrees, $0.1.decimalDegrees) }
			.map(CLLocationCoordinate2D.init(latitude:longitude:))
		
		testValues.forEach { clLocationCoordinate in
			let coordinate = WGS84Coordinate2D(clLocationCoordinate)
			
			XCTAssertEqual(coordinate.latitude.decimalDegrees, clLocationCoordinate.latitude)
			XCTAssertEqual(coordinate.longitude.decimalDegrees, clLocationCoordinate.longitude)
		}
	}
	
	func testCoordinate2DFromCoreLocation() {
		let testValues = product(Self.testLatitudes, Self.testLongitudes)
			.map { ($0.0.decimalDegrees, $0.1.decimalDegrees) }
			.map(CLLocation.init(latitude:longitude:))
		
		testValues.forEach { clLocation in
			let coordinate = WGS84Coordinate2D(clLocation)
			
			XCTAssertEqual(coordinate.latitude.decimalDegrees, clLocation.coordinate.latitude)
			XCTAssertEqual(coordinate.longitude.decimalDegrees, clLocation.coordinate.longitude)
		}
	}
	
	func testCoordinate2DToCoreLocationCoordinate() {
		Self.testCoordinates.forEach { coordinate in
			let clLocationCoordinate = coordinate.clLocationCoordinate2D
			
			XCTAssertEqual(clLocationCoordinate.latitude, coordinate.latitude.decimalDegrees)
			XCTAssertEqual(clLocationCoordinate.longitude, coordinate.longitude.decimalDegrees)
		}
	}
	
	func testCoordinate2DToCoreLocation() {
		Self.testCoordinates.forEach { coordinate in
			let clLocation = coordinate.clLocation
			
			XCTAssertEqual(clLocation.coordinate.latitude, coordinate.latitude.decimalDegrees)
			XCTAssertEqual(clLocation.coordinate.longitude, coordinate.longitude.decimalDegrees)
		}
	}
	
}
#endif
