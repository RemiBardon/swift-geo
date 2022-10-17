//
//  GeometricSystem.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

public protocol GeometricSystem<CRS> {

	associatedtype CRS: CoordinateReferenceSystem

	associatedtype Point: GeodeticGeometry.Point<CRS>
	associatedtype Size: GeodeticGeometry.Size<CRS>
//	associatedtype MultiPoint: GeodeticGeometry.MultiPoint<Point>
	associatedtype Line: GeodeticGeometry.Line<Point>
//	associatedtype MultiLine: GeodeticGeometry.MultiLine<Point>
	associatedtype LineString: GeodeticGeometry.LineString<Point>
//	associatedtype LinearRing: GeodeticGeometry.LinearRing<Point>

	associatedtype BoundingBox: GeodeticGeometry.BoundingBox<Point>

}
