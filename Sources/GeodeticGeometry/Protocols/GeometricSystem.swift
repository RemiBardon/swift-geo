//
//  GeometricSystem.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

public protocol GeometricSystem<CRS> {

	associatedtype CRS: Geodesy.CoordinateReferenceSystem

	typealias Coordinates = Point.Coordinates
	associatedtype Point: GeodeticGeometry.Point<Self>
	where Point.GeometricSystem == Self
	associatedtype Size: GeodeticGeometry.Size<Self>
//	associatedtype MultiPoint: GeodeticGeometry.MultiPoint<Point>
	associatedtype Line: GeodeticGeometry.Line<Point>
//	associatedtype MultiLine: GeodeticGeometry.MultiLine<Point>
	associatedtype LineString: GeodeticGeometry.LineString<Point>
//	associatedtype LinearRing: GeodeticGeometry.LinearRing<Point>

	associatedtype BoundingBox: GeodeticGeometry.BoundingBox<Point>

}

public protocol TwoDimensionsGeometricSystem: GeometricSystem
where CRS: TwoDimensionsCRS,
			Point.Coordinates: TwoDimensionsCoordinate
{}

public protocol ThreeDimensionsGeometricSystem: GeometricSystem
where CRS: ThreeDimensionsCRS,
			Point.Coordinates: ThreeDimensionsCoordinate
{}
