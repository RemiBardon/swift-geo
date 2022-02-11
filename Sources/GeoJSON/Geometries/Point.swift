//
//  Point.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON Point](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.2).
public protocol Point: SingleGeometry {
	
	associatedtype Position: GeoJSON.Position
	associatedtype Coordinates = Position
	
}

extension Point {
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .point }
	
}

/// A two-dimensional ``Point`` (with longitude and latitude).
public struct Point2D: Point {
	
	public typealias Position = Position2D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .point2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}

/// A three-dimensional ``Point`` (with longitude, latitude and altitude).
public struct Point3D: Point {
	
	public typealias Position = Position3D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .point3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
