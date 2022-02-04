//
//  File.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Turf

public protocol Geometry: GeoJSON.Object, Hashable, Codable {
	
	static var geometryType: GeoJSON.`Type`.Geometry { get }
	
	var bbox: BoundingBox? { get }
	
	var asAnyGeometry: AnyGeometry { get }
	
}

extension Geometry {
	
	public static var geoJSONType: GeoJSON.`Type` { .geometry(Self.geometryType) }
	
}

public protocol SingleGeometry: Geometry {
	
	associatedtype Coordinates: Boundable & Hashable & Codable
	associatedtype BoundingBox = Coordinates.BoundingBox
	
	var coordinates: Coordinates { get set }
	
	init(coordinates: Coordinates)
	
}

extension SingleGeometry {
	
	public var bbox: Coordinates.BoundingBox? { coordinates.bbox }
	
}

public enum AnyGeometry: Hashable, Codable {
	
	case geometryCollection(GeometryCollection)
	
	case point2D(Point2D)
	case multiPoint2D(MultiPoint2D)
	case lineString2D(LineString2D)
	case multiLineString2D(MultiLineString2D)
	case polygon2D(Polygon2D)
	case multiPolygon2D(MultiPolygon2D)
	
	public var bbox: AnyBoundingBox? {
		switch self {
		case .geometryCollection(let geometryCollection):
			return geometryCollection.bbox
			
		case .point2D(let point2D):
			return point2D.bbox?.asAny
		case .multiPoint2D(let multiPoint2D):
			return multiPoint2D.bbox?.asAny
		case .lineString2D(let lineString2D):
			return lineString2D.bbox?.asAny
		case .multiLineString2D(let multiLineString2D):
			return multiLineString2D.bbox?.asAny
		case .polygon2D(let polygon2D):
			return polygon2D.bbox?.asAny
		case .multiPolygon2D(let multiPolygon2D):
			return multiPolygon2D.bbox?.asAny
		}
	}
	
}
