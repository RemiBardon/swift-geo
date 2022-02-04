//
//  Point.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Point: SingleGeometry {
	
	associatedtype Position: GeoJSON.Position
	associatedtype Coordinates = Position
	
}

public struct Point2D: Point {
	
	public typealias Position = Position2D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .point }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .point2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
