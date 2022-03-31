//
//  Point2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public typealias Point2D = GeoModels.Coordinate2D

extension Point2D: GeoModels.Point {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
	public var coordinates: Self.Coordinates { self }
	
	public init(_ coordinates: Self.Coordinates) {
		self.init(x: coordinates.x, y: coordinates.y)
	}
	
	public init<N: BinaryFloatingPoint>(repeating number: N) {
		self.init(x: X(number), y: Y(number))
	}
	
}

extension Point2D: CustomDebugStringConvertible {
	
	public var debugDescription: String { self.ddNotation }
	
}
