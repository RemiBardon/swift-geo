//
//  Point2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public typealias Point2D = Coordinate2D

extension Point2D: GeoModels.Point {
	
	public typealias CoordinateSystem = Geo2D
	public typealias Components = (X, Y)
	
	public var components: Components { (x, y) }
	
	public init(_ components: Components) {
		self.init(x: components.0, y: components.1)
	}
	
}

extension Point2D: GeoModels.Zeroable {}

extension Point2D: CustomDebugStringConvertible {
	
	public var debugDescription: String { self.ddNotation }
	
}
