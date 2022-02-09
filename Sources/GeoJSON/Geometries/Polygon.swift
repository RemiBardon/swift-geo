//
//  Polygon.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty
import Turf

/// A [GeoJSON Polygon](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6) / linear ring.
public protocol Polygon: SingleGeometry {
	
	associatedtype Point: GeoJSON.Point
	associatedtype Coordinates = [LinearRingCoordinates<Point>]
	
}

public struct LinearRingCoordinates<Point: GeoJSON.Point>: Boundable, Hashable, Codable {
	
	public typealias RawValue = NonEmpty<NonEmpty<NonEmpty<NonEmpty<[Point.Coordinates]>>>>
	
	public var rawValue: RawValue
	
	public var bbox: RawValue.BoundingBox { rawValue.bbox }
	
	public init(rawValue: RawValue) throws {
		guard rawValue.first == rawValue.last else {
			throw LinearRingError.firstAndLastPositionsShouldBeEquivalent
		}
		self.rawValue = rawValue
	}
	
	public init(elements: [Point.Coordinates]) throws {
		guard let rawValue = NonEmpty(rawValue: elements)
			.flatMap(NonEmpty.init(rawValue:))
			.flatMap(NonEmpty.init(rawValue:))
			.flatMap(NonEmpty.init(rawValue:))
		else { throw LinearRingError.notEnoughPoints }
		
		try self.init(rawValue: rawValue)
	}
	
}

extension LinearRingCoordinates: ExpressibleByArrayLiteral {
	
	public init(arrayLiteral elements: Point.Coordinates...) {
		do {
			try self.init(elements: elements)
		} catch {
			fatalError("Array literal should contain at least 4 values.")
		}
	}
	
}

/// A ``Polygon`` with ``Point2D``s.
public struct Polygon2D: Polygon {
	
	public typealias Point = Point2D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .polygon }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .polygon2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}

/// A ``Polygon`` with ``Point3D``s.
public struct Polygon3D: Polygon {
	
	public typealias Point = Point3D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .polygon }
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .polygon3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
}
