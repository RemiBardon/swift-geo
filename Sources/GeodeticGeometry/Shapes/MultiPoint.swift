//
//  MultiPoint.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import protocol NonEmpty.NonEmptyProtocol

public protocol MultiPoint<GeometricSystem>: Hashable {

	typealias CRS = Self.GeometricSystem.CRS
	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem<Self.CRS>
	typealias Point = Self.GeometricSystem.Point
	associatedtype Points: NonEmpty.NonEmptyProtocol
	where Self.Points.Element == Self.Point
	
	var points: Self.Points { get }
	
	init(points: Self.Points)
	
}

extension MultiPoint {
	// Type alias defined so we can declare a `Point` associated type
	// and `GeometricSystem` is inferred.
	public typealias GeometricSystem = Self.Point.GeometricSystem
}
