//
//  Turf+MapKitTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit
import Turf
import WGS84
import XCTest

class TurfMapKitTests: XCTestCase {
	
	static let worldWidth = 268435456.0
	
	/// Just a test to keep in mind that coordinates are completely different from map points.
	func testMapPointDiffersFromCoordinate() {
		let point1 = MKMapPoint(x: 3, y: 1)
		let point2 = MKMapPoint(CLLocationCoordinate2D(latitude: 1, longitude: 3))
		XCTAssertNotEqual(point1, point2)
		
		let overAntiMeridian = CLLocationCoordinate2D(latitude: 10, longitude: 210)
		XCTAssertEqual(overAntiMeridian.longitude, 210)
		XCTAssertLessThan(MKMapPoint(overAntiMeridian).x, MKMapRect.world.maxX)
		XCTAssertEqual(MKMapPoint(overAntiMeridian).x, -1)
	}
	
	/// Just a test to show the size of Earth.
	func testWorldSize() {
		let origin = MKMapPoint(x: 0.0, y: 0.0)
		let size = MKMapSize(width: Self.worldWidth, height: 268435456.0)
		let rect = MKMapRect(origin: origin, size: size)
		XCTAssertEqual(MKMapRect.world, rect)
		
		let region = MKCoordinateRegion(rect)
		XCTAssertEqual(region.center, CLLocationCoordinate2D(latitude: 0, longitude: 0))
		XCTAssertEqual(region.span.longitudeDelta, 360)
		XCTAssertEqual(region.span.latitudeDelta, 170.10225755961318)
	}
	
	func testConversionFromRectToRegionCanCauseUnexpectedResult() {
		let points = [
			CLLocationCoordinate2D(latitude: 75, longitude:  160),
			CLLocationCoordinate2D(latitude: 65, longitude: -160),
			CLLocationCoordinate2D(latitude: 50, longitude: -170),
			CLLocationCoordinate2D(latitude: 45, longitude:  170),
		].map(MKMapPoint.init)
		
		let origin = MKMapPoint(CLLocationCoordinate2D(latitude: 75, longitude: 160))
		// Latitude is not 60 due to Earth's curvature
		let center = CLLocationCoordinate2D(latitude: 63.71151678614042, longitude: 0)
		
		let size = MKMapSize(
			width:  points[0].x.distance(to: points[1].x),
			height: points[0].y.distance(to: points[3].y)
		)
		
		let rect = MKMapRect(origin: origin, size: size)
		XCTAssertLessThan(rect.width, Self.worldWidth / 2)
		
		let region = MKCoordinateRegion(rect)
		XCTAssertEqual(region.center, center)
		XCTAssertEqual(region.span.longitudeDelta.rounded(), 320)
	}
	
	func testNaiveBBoxForEmptyListReturnsWorld() throws {
		throw XCTSkip("Commented out")
//		XCTAssertEqual(Turf.mkNaiveBBox(for: [Point2D]()), .world)
	}
	
}
#endif
