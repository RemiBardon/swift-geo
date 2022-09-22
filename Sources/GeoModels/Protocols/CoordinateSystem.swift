//
//  CoordinateSystem.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public protocol CoordinateSystem {
	
	associatedtype Coordinates: GeoCoordinates.Coordinates
	associatedtype Point: GeoModels.Point
		where Self.Point.CoordinateSystem == Self
	associatedtype Size: GeoModels.Size
		where Self.Size.CoordinateSystem == Self
//	associatedtype MultiPoint: GeoModels.MultiPoint
//		where Self.MultiPoint.CoordinateSystem == Self
	associatedtype Line: GeoModels.Line
		where Self.Line.CoordinateSystem == Self
//	associatedtype MultiLine: GeoModels.MultiLine
//		where Self.MultiLine.CoordinateSystem == Self
	associatedtype LineString: GeoModels.LineString
		where Self.LineString.CoordinateSystem == Self
//	associatedtype LinearRing: GeoModels.LinearRing
//		where Self.LinearRing.CoordinateSystem == Self
	
	associatedtype BoundingBox: GeoModels.BoundingBox
		where Self.BoundingBox.CoordinateSystem == Self
	
}
