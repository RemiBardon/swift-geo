//
//  LineString.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol LineString: SingleGeometry {
	
	associatedtype Position: GeoJSON.Position
	associatedtype Coordinates = NonEmpty<NonEmpty<[Position]>>
	
}

public struct LineString2D: LineString {
	
	public typealias Position = Position2D
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .lineString }
	
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
