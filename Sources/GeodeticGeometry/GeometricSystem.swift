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
//	associatedtype MultiPoint: GeodeticGeometry.MultiPoint<Self>
	associatedtype Line: GeodeticGeometry.Line<Self>
//	associatedtype MultiLine: GeodeticGeometry.MultiLine<Self>
	associatedtype LineString: GeodeticGeometry.LineString<Self>
//	associatedtype LinearRing: GeodeticGeometry.LinearRing<Self>

	associatedtype BoundingBox: GeodeticGeometry.BoundingBox<Self>

}

public protocol TwoDimensionalGeometricSystem: GeometricSystem
where CRS: TwoDimensionalCRS,
			Point.Coordinates: TwoDimensionalCoordinate,
			Size: Size2D
{}

public protocol ThreeDimensionalGeometricSystem: GeometricSystem
where CRS: ThreeDimensionalCRS,
			Point.Coordinates: ThreeDimensionalCoordinate,
			Size: Size3D
{}
