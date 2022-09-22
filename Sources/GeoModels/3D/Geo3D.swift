//
//  Geo3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public enum Geo3D: GeoModels.CoordinateSystem {
	
	public typealias Coordinates = Coordinate3D
	
	public typealias Point = Point3D
	public typealias Size = Size3D
//	public typealias MultiPoint = MultiPoint3D
	public typealias Line = Line3D
//	public typealias MultiLine = MultiLine3D
	public typealias LineString = LineString3D
//	public typealias LinearRing = LinearRing3D
	
	public typealias BoundingBox = BoundingBox3D
	
}
