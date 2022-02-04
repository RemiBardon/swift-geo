//
//  GeoJSON+DecodableTests.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@testable import GeoJSON
import XCTest

final class GeoJSONDecodableTests: XCTestCase {
	
	func testPosition2DDecode() throws {
		let string: String = "[-1.55366,47.21881]"
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let position = try JSONDecoder().decode(Position2D.self, from: data)
		
		let expected: Position2D = .nantes
		XCTAssertEqual(position, expected)
	}
	
	func testPoint2DDecode() throws {
		let string: String = [
			"{",
				"\"type\":\"Point\",",
				"\"coordinates\":[-1.55366,47.21881]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let point = try JSONDecoder().decode(Point2D.self, from: data)
		
		let expected: Point2D = Point2D(coordinates: .nantes)
		XCTAssertEqual(point, expected)
	}
	
	func testMultiPoint2DDecode() throws {
		let string: String = [
			"{",
				"\"type\":\"MultiPoint\",",
				"\"coordinates\":[",
					"[-1.55366,47.21881]",
				"]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let multiPoint = try JSONDecoder().decode(MultiPoint2D.self, from: data)
		
		let expected: MultiPoint2D = MultiPoint2D(coordinates: [.nantes])
		XCTAssertEqual(multiPoint, expected)
	}
	
	func testLineString2DDecode() throws {
		let string: String = [
			"{",
				"\"type\":\"LineString\",",
				"\"coordinates\":[",
					"[-1.55366,47.21881],",
					"[2.3529,48.85719]",
				"]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let lineString = try JSONDecoder().decode(LineString2D.self, from: data)
		
		let expected: LineString2D = try XCTUnwrap(LineString2D(coordinates: [.nantes, .paris]))
		XCTAssertEqual(lineString, expected)
	}
	
	func testMultiLineString2DDecode() throws {
		let string: String = [
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
				"]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let multiLineString = try JSONDecoder().decode(MultiLineString2D.self, from: data)
		
		let expected: MultiLineString2D = try XCTUnwrap(MultiLineString2D(coordinates: [
			[.nantes, .bordeaux],
			[.paris, .marseille],
		]))
		XCTAssertEqual(multiLineString, expected)
	}
	
	func testPolygon2DDecode() throws {
		let string = [
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
				"]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let polygon = try JSONDecoder().decode(Polygon2D.self, from: data)
		
		let expected: Polygon2D = Polygon2D(coordinates: [
			[.nantes, .bordeaux, .marseille, .paris, .nantes],
		])
		XCTAssertEqual(polygon, expected)
	}
	
	func testMultiPolygon2DDecode() throws {
		let string: String = [
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
				"]",
			"}",
		].joined()
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		
		let multiPolygon = try JSONDecoder().decode(MultiPolygon2D.self, from: data)
		
		let expected: MultiPolygon2D = try XCTUnwrap(MultiPolygon2D(coordinates: [
			[
				[.nantes, .bordeaux, .marseille, .paris, .nantes],
			],
		]))
		XCTAssertEqual(multiPolygon, expected)
	}
	
	func testFeature2DDecode() throws {
		struct FeatureProperties: Hashable, Codable {}
		
		let string: String = [
			"{",
				"\"type\":\"Feature\",",
				"\"geometry\":{",
					"\"type\":\"Point\",",
					"\"coordinates\":[-1.55366,47.21881]",
				"},",
				"\"properties\":{},",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined()
		
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		let feature = try JSONDecoder().decode(Feature<FeatureProperties>.self, from: data)
		
		let expected: Feature = Feature(
			geometry: .point2D(Point2D(coordinates: .nantes)),
			properties: FeatureProperties()
		)
		XCTAssertEqual(feature, expected)
	}
	
}
