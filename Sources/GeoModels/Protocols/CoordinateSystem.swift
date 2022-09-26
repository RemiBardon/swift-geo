//
//  CoordinateSystem.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public protocol CoordinateSystem {

	associatedtype Point: GeoCoordinates.Coordinates//: GeoModels.Point<Self>
	associatedtype Size: GeoModels.Size<Self>
//	associatedtype MultiPoint: GeoModels.MultiPoint<Self>
	associatedtype Line: GeoModels.Line<Self>
//	associatedtype MultiLine: GeoModels.MultiLine<Self>
	associatedtype LineString: GeoModels.LineString<Self>
//	associatedtype LinearRing: GeoModels.LinearRing<Self>

	associatedtype BoundingBox: GeoModels.BoundingBox<Self>

}
