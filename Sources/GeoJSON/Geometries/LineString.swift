//
//  LineString.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

/// A [GeoJSON LineString](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.4).
public protocol LineString: SingleGeometry {
	
	associatedtype Position: GeoJSON.Position
	associatedtype Coordinates = NonEmpty<NonEmpty<[Position]>>
	
}

extension LineString {
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .lineString }
	
}

/// A ``LineString`` with ``Point2D``s.
public struct LineString2D: LineString {
	
	public typealias Position = Position2D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .lineString2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
	public init?(coordinates: [Position2D]) {
		guard let coordinates = NonEmpty(rawValue: coordinates)
			.flatMap(NonEmpty.init(rawValue:))
		else { return nil }
		
		self.init(coordinates: coordinates)
	}
	
}

/// A ``LineString`` with ``Point3D``s.
public struct LineString3D: LineString {
	
	public typealias Position = Position3D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .lineString3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
	public init?(coordinates: [Position3D]) {
		guard let coordinates = NonEmpty(rawValue: coordinates)
			.flatMap(NonEmpty.init(rawValue:))
		else { return nil }
		
		self.init(coordinates: coordinates)
	}
	
}
