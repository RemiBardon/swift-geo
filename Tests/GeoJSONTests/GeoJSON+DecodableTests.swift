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
	
	// MARK: Specification tests
	
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
		let feature = try JSONDecoder().decode(Feature<NonID, Point2D, FeatureProperties>.self, from: data)
		
		let expected: Feature = Feature(
			geometry: Point2D(coordinates: .nantes),
			properties: FeatureProperties()
		)
		XCTAssertEqual(feature, expected)
	}
	
	func testFeature2DWithIDDecode() throws {
		struct FeatureProperties: Hashable, Codable {}
		
		let string: String = [
			"{",
				"\"type\":\"Feature\",",
				"\"id\":\"feature_id\",",
				"\"geometry\":{",
					"\"type\":\"Point\",",
					"\"coordinates\":[-1.55366,47.21881]",
				"},",
				"\"properties\":{},",
				"\"bbox\":[-1.55366,47.21881,-1.55366,47.21881]",
			"}",
		].joined()
		
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		let feature = try JSONDecoder().decode(Feature<String, Point2D, FeatureProperties>.self, from: data)
		
		let expected: Feature = Feature(
			id: "feature_id",
			geometry: Point2D(coordinates: .nantes),
			properties: FeatureProperties()
		)
		XCTAssertEqual(feature, expected)
	}
	
	// MARK: Real-world use cases
	
	func testDecodeFeatureProperties() throws {
		struct RealWorldProperties: Hashable, Codable {
			let prop0: String
		}
		
		let string = """
		{
			"type": "Feature",
			"geometry": {
				"type": "Point",
				"coordinates": [102.0, 0.5]
			},
			"properties": {
				"prop0": "value0"
			}
		}
		"""
		
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		let feature = try JSONDecoder().decode(AnyFeature<RealWorldProperties>.self, from: data)
		
		let expected: AnyFeature = AnyFeature(
			geometry: .point2D(Point2D(coordinates: .init(latitude: 0.5, longitude: 102))),
			properties: RealWorldProperties(prop0: "value0")
		)
		XCTAssertEqual(feature, expected)
	}
	
	/// Example from [RFC 7946, section 1.5](https://datatracker.ietf.org/doc/html/rfc7946#section-1.5).
	func testDecodeHeterogeneousFeatureCollection() throws {
		enum HeterogeneousProperties: Hashable, Codable, CustomStringConvertible {
			struct Properties1: Hashable, Codable, CustomStringConvertible {
				let prop0: String
				
				var description: String {
					"{prop0:\"\(prop0)\"}"
				}
			}
			struct Properties2: Hashable, Codable, CustomStringConvertible {
				let prop0: String
				let prop1: Double
				
				var description: String {
					"{prop0:\"\(prop0)\",prop1:\(prop1)}"
				}
			}
			struct Properties3: Hashable, Codable, CustomStringConvertible {
				struct Prop1: Hashable, Codable, CustomStringConvertible {
					let this: String
					
					var description: String {
						"{this:\"\(this)\"}"
					}
				}
				
				let prop0: String
				let prop1: Prop1
				
				var description: String {
					"{prop0:\"\(prop0)\",prop1:\(prop1)}"
				}
			}
			
			enum CodingKeys: String, CodingKey {
				case prop0, prop1
			}
			
			case type1(Properties1)
			case type2(Properties2)
			case type3(Properties3)
			
			var description: String {
				switch self {
				case .type1(let type1):
					return type1.description
				case .type2(let type2):
					return type2.description
				case .type3(let type3):
					return type3.description
				}
			}
			
			init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				
				let prop0 = try container.decode(String.self, forKey: .prop0)
				do {
					do {
						let prop1 = try container.decode(Double.self, forKey: .prop1)
						self = .type2(.init(prop0: prop0, prop1: prop1))
					} catch {
						let prop1 = try container.decode(Properties3.Prop1.self, forKey: .prop1)
						self = .type3(.init(prop0: prop0, prop1: prop1))
					}
				} catch {
					self = .type1(.init(prop0: prop0))
				}
			}
			
			func encode(to encoder: Encoder) throws {
				fatalError("Useless")
			}
		}
		
		let string = """
		{
			"type": "FeatureCollection",
			"features": [{
				"type": "Feature",
				"geometry": {
					"type": "Point",
					"coordinates": [102.0, 0.5]
				},
				"properties": {
					"prop0": "value0"
				}
			}, {
				"type": "Feature",
				"geometry": {
					"type": "LineString",
					"coordinates": [
						[102.0, 0.0],
						[103.0, 1.0],
						[104.0, 0.0],
						[105.0, 1.0]
					]
				},
				"properties": {
					"prop0": "value0",
					"prop1": 0.0
				}
			}, {
				"type": "Feature",
				"geometry": {
					"type": "Polygon",
					"coordinates": [
						[
							[100.0, 0.0],
							[101.0, 0.0],
							[101.0, 1.0],
							[100.0, 1.0],
							[100.0, 0.0]
						]
					]
				},
				"properties": {
					"prop0": "value0",
					"prop1": {
						"this": "that"
					}
				}
			}]
		}
		"""
		
		let data: Data = try XCTUnwrap(string.data(using: .utf8))
		let feature = try JSONDecoder().decode(AnyFeatureCollection<HeterogeneousProperties>.self, from: data)
		
		let expected: AnyFeatureCollection<HeterogeneousProperties> = AnyFeatureCollection(features: [
			Feature(
				geometry: .point2D(Point2D(coordinates: .init(latitude: 0.5, longitude: 102))),
				properties: .type1(.init(prop0: "value0"))
			),
			Feature(
				geometry: .lineString2D(.init(coordinates: [
					.init(latitude: 0.0, longitude: 102.0),
					.init(latitude: 1.0, longitude: 103.0),
					.init(latitude: 0.0, longitude: 104.0),
					.init(latitude: 1.0, longitude: 105.0)
				])!),
				properties: .type2(.init(prop0: "value0", prop1: 0))
			),
			Feature(
				geometry: .polygon2D(.init(coordinates: .init(arrayLiteral: [
					.init(latitude: 0.0, longitude: 100.0),
					.init(latitude: 0.0, longitude: 101.0),
					.init(latitude: 1.0, longitude: 101.0),
					.init(latitude: 1.0, longitude: 100.0),
					.init(latitude: 0.0, longitude: 100.0)
				]))),
				properties: .type3(.init(prop0: "value0", prop1: .init(this: "that")))
			),
		])
		XCTAssertEqual(feature, expected)
	}
	
}
