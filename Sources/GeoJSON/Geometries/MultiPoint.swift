//
//  MultiPoint.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON MultiPoint](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.3).
public protocol MultiPoint: SingleGeometry {
	
	associatedtype Point: GeoJSON.Point
	associatedtype Coordinates = [Point.Coordinates]
	
}

extension MultiPoint {
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .multiPoint }
	
}

/// A ``MultiPoint`` with ``Point2D``s.
public struct MultiPoint2D: MultiPoint {
	
	public typealias Point = Point2D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiPoint2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}

/// A ``MultiPoint`` with ``Point3D``s.
public struct MultiPoint3D: MultiPoint {
	
	public typealias Point = Point3D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiPoint3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
