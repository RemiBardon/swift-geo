//
//  MultiPolygon.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON MultiPolygon](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.7).
public protocol MultiPolygon: SingleGeometry {
	
	associatedtype Polygon: GeoJSON.Polygon
	associatedtype Coordinates = [Polygon.Coordinates]
	
}

/// A ``MultiPolygon`` with ``Point2D``s.
public struct MultiPolygon2D: MultiPolygon {
	
	public typealias Polygon = Polygon2D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .multiPolygon }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiPolygon2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}

/// A ``MultiPolygon`` with ``Point3D``s.
public struct MultiPolygon3D: MultiPolygon {
	
	public typealias Polygon = Polygon3D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .multiPolygon }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiPolygon3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
