//
//  Point2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public typealias Point2D = Coordinate2D

extension Point2D: GeoModels.Point {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
	public var coordinates: Self.Coordinates { self }
	
	public init(_ coordinates: Self.Coordinates) {
		self.init(x: coordinates.x, y: coordinates.y)
	}
	
}

extension Point2D: CustomDebugStringConvertible {
	
	public var debugDescription: String { self.ddNotation }
	
}
