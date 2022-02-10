//
//  GeoJSON+EncodableTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@testable import GeoJSON
import XCTest

final class GeoJSONEncodableTests: XCTestCase {
	
	func testPosition2DEncode() throws {
		let data = try JSONEncoder().encode(Position2D.nantes)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, "[-1.55366,47.21881]")
	}
	
	func testPoint2DEncode() throws {
		let point = Point2D(coordinates: .nantes)
		let data = try JSONEncoder().encode(point)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"Point\",",
				"\"coordinates\":[-1.55366,47.21881],",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined())
	}
	
	func testMultiPoint2DEncode() throws {
		let multiPoint = MultiPoint2D(coordinates: [.nantes])
		let data = try JSONEncoder().encode(multiPoint)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"MultiPoint\",",
				"\"coordinates\":[",
					"[-1.55366,47.21881]",
				"],",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined())
	}
	
	func testLineString2DEncode() throws {
		let lineString = try XCTUnwrap(LineString2D(coordinates: [.nantes, .paris]))
		let data = try JSONEncoder().encode(lineString)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"LineString\",",
				"\"coordinates\":[",
					"[-1.55366,47.21881],",
					"[2.3529,48.85719]",
				"],",
				"\"bbox\":[-1.55366,47.21881,2.3529,48.85719]",
			"}",
		].joined())
	}
	
	func testMultiLineString2DEncode() throws {
		let multiLineString = try XCTUnwrap(MultiLineString2D(coordinates: [[.nantes, .bordeaux], [.paris, .marseille]]))
		let data = try JSONEncoder().encode(multiLineString)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"MultiLineString\",",
				"\"coordinates\":[",
					"[",
						"[-1.55366,47.21881],",
						"[-0.58143,44.8378]",
					"],",
					"[",
						"[2.3529,48.85719],",
						"[5.36468,43.29868]",
					"]",
				"],",
				"\"bbox\":[-1.55366,43.29868,5.36468,48.85719]",
			"}",
		].joined())
	}
	
	func testPolygon2DEncode() throws {
		let polygon = try XCTUnwrap(Polygon2D(coordinates: [
			[.nantes, .bordeaux, .marseille, .paris, .nantes],
		]))
		let data = try JSONEncoder().encode(polygon)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"Polygon\",",
				"\"coordinates\":[",
					"[",
						"[-1.55366,47.21881],",
						"[-0.58143,44.8378],",
						"[5.36468,43.29868],",
						"[2.3529,48.85719],",
						"[-1.55366,47.21881]",
					"]",
				"],",
				"\"bbox\":[-1.55366,43.29868,5.36468,48.85719]",
			"}",
		].joined())
	}
	
	// testPolygonNeeds4Points
	// testPolygonIsClockwise
	// testPolygon2DCrossingAntiMeridianEncode
	
	func testMultiPolygon2DEncode() throws {
		let multiPolygon = try XCTUnwrap(MultiPolygon2D(coordinates: [
			[
				[.nantes, .bordeaux, .marseille, .paris, .nantes],
			],
		]))
		let data = try JSONEncoder().encode(multiPolygon)
		let string = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(string, [
			"{",
				"\"type\":\"MultiPolygon\",",
				"\"coordinates\":[",
					"[",
						"[",
							"[-1.55366,47.21881],",
							"[-0.58143,44.8378],",
							"[5.36468,43.29868],",
							"[2.3529,48.85719],",
							"[-1.55366,47.21881]",
						"]",
					"]",
				"],",
				"\"bbox\":[-1.55366,43.29868,5.36468,48.85719]",
			"}",
		].joined())
	}
	
	func testFeature2DEncode() throws {
		struct FeatureProperties: Hashable, Codable {}
		
		let feature: Feature = Feature(
			geometry: Point2D(coordinates: .nantes),
			properties: FeatureProperties()
		)
		let data: Data = try JSONEncoder().encode(feature)
		let string: String = try XCTUnwrap(String(data: data, encoding: .utf8))
		
		let expected: String = [
			"{",
				// For some reason, `"properties"` goes on top 🤷
				"\"properties\":{},",
				"\"type\":\"Feature\",",
				"\"geometry\":{",
					"\"type\":\"Point\",",
					"\"coordinates\":[-1.55366,47.21881],",
					"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
				"},",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined()
		XCTAssertEqual(string, expected)
	}
	
	func testFeature2DWithIDEncode() throws {
		struct FeatureProperties: Hashable, Codable {}
		
		let feature: Feature = Feature(
			id: "feature_id",
			geometry: Point2D(coordinates: .nantes),
			properties: FeatureProperties()
		)
		let data: Data = try JSONEncoder().encode(feature)
		let string: String = try XCTUnwrap(String(data: data, encoding: .utf8))
		
		let expected: String = [
			"{",
				// For some reason, `"id"` goes here 🤷
				"\"id\":\"feature_id\",",
				// For some reason, `"properties"` goes here 🤷
				"\"properties\":{},",
				"\"type\":\"Feature\",",
				"\"geometry\":{",
					"\"type\":\"Point\",",
					"\"coordinates\":[-1.55366,47.21881],",
					"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
				"},",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined()
		XCTAssertEqual(string, expected)
	}
	
	func testFeatureCollectionOfGeometryCollectionEncode() throws {
		struct FeatureProperties: Hashable, Codable {}
		
		let featureCollection: FeatureCollection = FeatureCollection(features: [
			Feature(
				geometry: GeometryCollection(geometries: [
					.point2D(Point2D(coordinates: .nantes)),
					.point2D(Point2D(coordinates: .bordeaux)),
				]),
				properties: FeatureProperties()
			),
			Feature(
				geometry: GeometryCollection(geometries: [
					.point2D(Point2D(coordinates: .paris)),
					 .point2D(Point2D(coordinates: .marseille)),
				]),
				properties: FeatureProperties()
			),
		])
		let data: Data = try JSONEncoder().encode(featureCollection)
		let string: String = try XCTUnwrap(String(data: data, encoding: .utf8))
		
		let expected: String = [
			"{",
				"\"type\":\"FeatureCollection\",",
				// For some reason, `"bbox"` goes here 🤷
				"\"bbox\":[-1.55366,43.29868,5.36468,48.85719],",
				"\"features\":[",
					"{",
						// For some reason, `"properties"` goes here 🤷
						"\"properties\":{},",
						"\"type\":\"Feature\",",
						"\"geometry\":{",
							"\"type\":\"GeometryCollection\",",
							// For some reason, `"bbox"` goes here 🤷
							"\"bbox\":[-1.55366,44.8378,-0.58143,47.21881],",
							"\"geometries\":[",
								"{",
									"\"type\":\"Point\",",
									"\"coordinates\":[-1.55366,47.21881],",
									"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
								"},",
								"{",
									"\"type\":\"Point\",",
									"\"coordinates\":[-0.58143,44.8378],",
									"\"bbox\":[-0.58143,44.8378,-0.58143,44.8378]",
								"}",
							"]",
						"},",
						"\"bbox\":[-1.55366,44.8378,-0.58143,47.21881]",
					"},",
					"{",
						// For some reason, `"properties"` goes here 🤷
						"\"properties\":{},",
						"\"type\":\"Feature\",",
						"\"geometry\":{",
							"\"type\":\"GeometryCollection\",",
							// For some reason, `"bbox"` goes here 🤷
							"\"bbox\":[2.3529,43.29868,5.36468,48.85719],",
							"\"geometries\":[",
								"{",
									"\"type\":\"Point\",",
									"\"coordinates\":[2.3529,48.85719],",
									"\"bbox\":[2.3529,48.85719,2.3529,48.85719]",
								"},",
								"{",
									"\"type\":\"Point\",",
									"\"coordinates\":[5.36468,43.29868],",
									"\"bbox\":[5.36468,43.29868,5.36468,43.29868]",
								"}",
							"]",
						"},",
						"\"bbox\":[2.3529,43.29868,5.36468,48.85719]",
					"}",
				"]",
			"}",
		].joined()
		XCTAssertEqual(string, expected)
	}
	
}
