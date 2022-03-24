//
//  MultiPoint.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol MultiPoint: Hashable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
		where Self.CoordinateSystem.Point == Self.Point
	associatedtype Point: GeoModels.Point
	associatedtype Points: NonEmptyProtocol
		where Points.Collection: NonEmptyProtocol,
			  Points.Element == Self.Point
	
	var points: Points { get }
	
	init(points: Points)
	
}
