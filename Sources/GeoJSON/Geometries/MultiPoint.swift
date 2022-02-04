//
//  MultiPoint.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol MultiPoint: SingleGeometry {
	
	associatedtype Point: GeoJSON.Point
	associatedtype Coordinates = [Point.Coordinates]
	
}

public struct MultiPoint2D: MultiPoint {
	
	public typealias Point = Point2D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .multiPoint }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiPoint2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
