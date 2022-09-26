//
//  MultiPoint.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol MultiPoint<CoordinateSystem>: Hashable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
	typealias Point = Self.CoordinateSystem.Point
	associatedtype Points: NonEmptyProtocol
	where Self.Points.Element == Self.Point
	
	var points: Self.Points { get }
	
	init(points: Self.Points)
	
}
