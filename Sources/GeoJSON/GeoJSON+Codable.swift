//
//  GeoJSON+Codable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation
import GeoModels

//extension BinaryFloatingPoint {
//
//	/// Rounds the double to decimal places value
//	fileprivate func roundedToPlaces(_ places: Int) -> Self {
//		let divisor = pow(10.0, Double(places))
//		return Self((Double(self) * divisor).rounded() / divisor)
//	}
//
//}

extension Double {
	
	/// Rounds the double to decimal places value
	func roundedToPlaces(_ places: Int) -> Decimal {
		let divisor = pow(10.0, Double(places))
		return Decimal((self * divisor).rounded()) / Decimal(divisor)
	}
	
}

extension Latitude: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let decimalDegrees = try container.decode(Double.self)
		
		self.init(decimalDegrees: decimalDegrees)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		try container.encode(self.decimalDegrees.roundedToPlaces(6))
	}
	
}

extension Longitude: Codable {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let decimalDegrees = try container.decode(Double.self)
		
		self.init(decimalDegrees: decimalDegrees)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		try container.encode(self.decimalDegrees.roundedToPlaces(6))
	}
	
}

extension Position2D: Codable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		
		let longitude = try container.decode(Longitude.self)
		let latitude = try container.decode(Latitude.self)
		
		self.init(latitude: latitude, longitude: longitude)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		
		try container.encode(self.longitude)
		try container.encode(self.latitude)
	}
	
}

extension LinearRingCoordinates {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let coordinates = try container.decode(Self.RawValue.self)
		
		try self.init(rawValue: coordinates)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		try container.encode(self.rawValue)
	}
	
}

fileprivate enum SingleGeometryCodingKeys: String, CodingKey {
	case geoJSONType = "type"
	case coordinates
}

extension SingleGeometry {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: SingleGeometryCodingKeys.self)
		
		let type = try container.decode(GeoJSON.`Type`.self, forKey: .geoJSONType)
		guard type == Self.geoJSONType else {
			throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
				codingPath: container.codingPath,
				debugDescription: "Found GeoJSON type '\(type.rawValue)'"
			))
		}
		
		let coordinates = try container.decode(Self.Coordinates.self, forKey: .coordinates)
		
		self.init(coordinates: coordinates)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: SingleGeometryCodingKeys.self)
		
		try container.encode(Self.geoJSONType, forKey: .geoJSONType)
		try container.encode(self.coordinates, forKey: .coordinates)
	}
	
}

fileprivate enum AnyGeometryCodingKeys: String, CodingKey {
	case geoJSONType = "type"
}

extension AnyGeometry {
	
	public init(from decoder: Decoder) throws {
		let typeContainer = try decoder.container(keyedBy: SingleGeometryCodingKeys.self)
		let type = try typeContainer.decode(GeoJSON.`Type`.Geometry.self, forKey: .geoJSONType)
		
		let container = try decoder.singleValueContainer()
		
		// FIXME: Fix 2D/3D performance by checking the number of values in `bbox`
		switch type {
		case .geometryCollection:
			let geometryCollection = try container.decode(GeometryCollection.self)
			self = .geometryCollection(geometryCollection)
		case .point:
//			do {
//				let point3D = try container.decode(Point3D.self)
//				self = .point3D(point3D)
//			} catch {
				let point2D = try container.decode(Point2D.self)
				self = .point2D(point2D)
//			}
		case .multiPoint:
			let multiPoint2D = try container.decode(MultiPoint2D.self)
			self = .multiPoint2D(multiPoint2D)
		case .lineString:
			let lineString2D = try container.decode(LineString2D.self)
			self = .lineString2D(lineString2D)
		case .multiLineString:
			let multiLineString2D = try container.decode(MultiLineString2D.self)
			self = .multiLineString2D(multiLineString2D)
		case .polygon:
			let polygon2D = try container.decode(Polygon2D.self)
			self = .polygon2D(polygon2D)
		case .multiPolygon:
			let multiPolygon2D = try container.decode(MultiPolygon2D.self)
			self = .multiPolygon2D(multiPolygon2D)
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		switch self {
		case .geometryCollection(let geometryCollection):
			try container.encode(geometryCollection)
		case .point2D(let point2D):
			try container.encode(point2D)
		case .multiPoint2D(let multiPoint2D):
			try container.encode(multiPoint2D)
		case .lineString2D(let lineString2D):
			try container.encode(lineString2D)
		case .multiLineString2D(let multiLineString2D):
			try container.encode(multiLineString2D)
		case .polygon2D(let polygon2D):
			try container.encode(polygon2D)
		case .multiPolygon2D(let multiPolygon2D):
			try container.encode(multiPolygon2D)
		}
	}
	
}

extension BoundingBox2D {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		
		let westLongitude = try container.decode(Longitude.self)
		let southLatitude = try container.decode(Latitude.self)
		let eastLongitude = try container.decode(Longitude.self)
		let northLatitude = try container.decode(Latitude.self)
		
		self.init(
			southWest: Coordinate2D(latitude: southLatitude, longitude: westLongitude),
			northEast: Coordinate2D(latitude: northLatitude, longitude: eastLongitude)
		)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		
		try container.encode(self.westLongitude)
		try container.encode(self.southLatitude)
		try container.encode(self.eastLongitude)
		try container.encode(self.northLatitude)
	}
	
}

extension AnyBoundingBox {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let boundingBox2D = try container.decode(BoundingBox2D.self)
		self = .twoDimensions(boundingBox2D)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		switch self {
		case .twoDimensions(let boundingBox2D):
			try container.encode(boundingBox2D)
		}
	}
	
}

fileprivate enum FeatureCodingKeys: String, CodingKey {
	case geoJSONType = "type"
	case geometry, properties, bbox
}

extension Feature {
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: FeatureCodingKeys.self)
		
		let type = try container.decode(GeoJSON.`Type`.self, forKey: .geoJSONType)
		guard type == Self.geoJSONType else {
			throw DecodingError.typeMismatch(Self.self, DecodingError.Context(
				codingPath: container.codingPath,
				debugDescription: "Found GeoJSON type '\(type.rawValue)'"
			))
		}
		
		let geometry = try container.decodeIfPresent(AnyGeometry.self, forKey: .geometry)
		let properties = try container.decode(Properties.self, forKey: .properties)
		
		self.init(geometry: geometry, properties: properties)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: FeatureCodingKeys.self)
		
		try container.encode(Self.geoJSONType, forKey: .geoJSONType)
		try container.encodeIfPresent(self.geometry, forKey: .geometry)
		try container.encode(self.properties, forKey: .properties)
		// TODO: Create GeoJSONEncoder that allows setting "export bboxes" to a boolean value
		// TODO: Memoize bboxes not to recompute them all the time (bboxes tree)
		try container.encodeIfPresent(self.bbox, forKey: .bbox)
	}
	
}
