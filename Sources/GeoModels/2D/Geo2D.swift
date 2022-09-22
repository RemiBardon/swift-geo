//
//  Geo2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public enum Geo2D: GeoModels.CoordinateSystem {
	
	public typealias Coordinates = Coordinate2D
	
	public typealias Point = Point2D
	public typealias Size = Size2D
//	public typealias MultiPoint = MultiPoint2D
	public typealias Line = Line2D
//	public typealias MultiLine = MultiLine2D
	public typealias LineString = LineString2D
//	public typealias LinearRing = LinearRing2D
	
	public typealias BoundingBox = BoundingBox2D
	
}
