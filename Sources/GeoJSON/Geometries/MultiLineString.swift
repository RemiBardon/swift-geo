//
//  MultiLineString.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

/// A [GeoJSON MultiLineString](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.5).
public protocol MultiLineString: SingleGeometry {
	
	associatedtype LineString: GeoJSON.LineString
	associatedtype Coordinates = [LineString.Coordinates]
	
}

extension MultiLineString {
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .multiLineString }
	
}

/// A ``MultiLineString`` with ``Point2D``s.
public struct MultiLineString2D: MultiLineString {
	
	public typealias LineString = LineString2D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiLineString2D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
	public init?(coordinates: [[Position2D]]) {
		var coord1 = [LineString2D.Coordinates]()
		
		for coord2 in coordinates {
			guard let coord3 = NonEmpty(rawValue: coord2)
				.flatMap(NonEmpty.init(rawValue:))
			else { return nil }
			
			coord1.append(coord3)
		}
		
		self.init(coordinates: coord1)
	}
	
}

/// A ``MultiLineString`` with ``Point3D``s.
public struct MultiLineString3D: MultiLineString {
	
	public typealias LineString = LineString3D
	
	public var coordinates: Coordinates
	
	public var asAnyGeometry: AnyGeometry { .multiLineString3D(self) }
	
	public init(coordinates: Coordinates) {
		self.coordinates = coordinates
	}
	
	public init?(coordinates: [[Position3D]]) {
		var coord1 = [LineString3D.Coordinates]()
		
		for coord2 in coordinates {
			guard let coord3 = NonEmpty(rawValue: coord2)
				.flatMap(NonEmpty.init(rawValue:))
			else { return nil }
			
			coord1.append(coord3)
		}
		
		self.init(coordinates: coord1)
	}
	
}
