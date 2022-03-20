//
//  CoordinateSystem.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol CoordinateSystem {
	
	associatedtype Point // GeoModels.Point
//	associatedtype MultiPoint: GeoModels.MultiPoint
//		where Self.MultiPoint.Point == Self.Point
	associatedtype Line: GeoModels.Line
		where Self.Line.Point == Self.Point
//	associatedtype MultiLine: GeoModels.MultiLine
//		where Self.MultiLine.Line == Self.Line
//	associatedtype LineString: GeoModels.LineString
//		where Self.LineString.Line == Self.Line
//	associatedtype LinearRing: GeoModels.LinearRing
//		where Self.LinearRing.Line == Self.Line
	
	associatedtype BoundingBox: GeoModels.BoundingBox
		where Self.BoundingBox.Point == Self.Point
	
}
