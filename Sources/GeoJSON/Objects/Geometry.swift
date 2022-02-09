//
//  File.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Turf

/// A [GeoJSON Geometry](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1).
public protocol Geometry: GeoJSON.Object, Hashable {
	
	var bbox: BoundingBox? { get }
	
	/// This geometry, but type-erased.
	var asAnyGeometry: AnyGeometry { get }
	
}

public protocol CodableGeometry: Geometry, CodableObject {
	
	/// The GeoJSON type of this geometry.
	static var geometryType: GeoJSON.`Type`.Geometry { get }
	
}

extension CodableGeometry {
	
	public static var geoJSONType: GeoJSON.`Type` { .geometry(Self.geometryType) }
	
}

/// A single [GeoJSON Geometry](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1)
/// (not a [GeometryCollection](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.8)).
public protocol SingleGeometry: CodableGeometry {
	
	associatedtype Coordinates: Boundable & Hashable & Codable
	associatedtype BoundingBox = Coordinates.BoundingBox
	
	var coordinates: Coordinates { get set }
	
	init(coordinates: Coordinates)
	
}

extension SingleGeometry {
	
	public var bbox: Coordinates.BoundingBox? { coordinates.bbox }
	
}

/// A type-erased ``Geometry``.
public enum AnyGeometry: Geometry, Hashable, Codable {
	
	case geometryCollection(GeometryCollection)
	
	case point2D(Point2D)
	case multiPoint2D(MultiPoint2D)
	case lineString2D(LineString2D)
	case multiLineString2D(MultiLineString2D)
	case polygon2D(Polygon2D)
	case multiPolygon2D(MultiPolygon2D)
	
	case point3D(Point3D)
	case multiPoint3D(MultiPoint3D)
	case lineString3D(LineString3D)
	case multiLineString3D(MultiLineString3D)
	case polygon3D(Polygon3D)
	case multiPolygon3D(MultiPolygon3D)
	
//	public var geometryType: GeoJSON.`Type`.Geometry {
//		switch self {
//		case .geometryCollection(let geo): 	return geo.geometryType
//
//		case .point2D(let geo): 			return geo.geometryType
//		case .multiPoint2D(let geo): 		return geo.geometryType
//		case .lineString2D(let geo): 		return geo.geometryType
//		case .multiLineString2D(let geo): 	return geo.geometryType
//		case .polygon2D(let geo): 			return geo.geometryType
//		case .multiPolygon2D(let geo): 		return geo.geometryType
//
//		case .point3D(let geo): 			return geo.geometryType
//		case .multiPoint3D(let geo): 		return geo.geometryType
//		case .lineString3D(let geo): 		return geo.geometryType
//		case .multiLineString3D(let geo): 	return geo.geometryType
//		case .polygon3D(let geo): 			return geo.geometryType
//		case .multiPolygon3D(let geo): 		return geo.geometryType
//		}
//	}
	
	public var bbox: AnyBoundingBox? {
		switch self {
		case .geometryCollection(let geo): 	return geo.bbox
			
		case .point2D(let geo): 			return geo.bbox?.asAny
		case .multiPoint2D(let geo): 		return geo.bbox?.asAny
		case .lineString2D(let geo): 		return geo.bbox?.asAny
		case .multiLineString2D(let geo): 	return geo.bbox?.asAny
		case .polygon2D(let geo): 			return geo.bbox?.asAny
		case .multiPolygon2D(let geo): 		return geo.bbox?.asAny
			
		case .point3D(let geo): 			return geo.bbox?.asAny
		case .multiPoint3D(let geo): 		return geo.bbox?.asAny
		case .lineString3D(let geo): 		return geo.bbox?.asAny
		case .multiLineString3D(let geo): 	return geo.bbox?.asAny
		case .polygon3D(let geo): 			return geo.bbox?.asAny
		case .multiPolygon3D(let geo): 		return geo.bbox?.asAny
		}
	}
	
	public var asAnyGeometry: AnyGeometry { self }
	
}
