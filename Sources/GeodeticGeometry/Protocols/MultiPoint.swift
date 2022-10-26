//
//  MultiPoint.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import NonEmpty

public protocol MultiPoint<Point>: Hashable {
	
	associatedtype Point: GeodeticGeometry.Point
	associatedtype Points: NonEmptyProtocol
	where Self.Points.Element == Self.Point
	
	var points: Self.Points { get }
	
	init(points: Self.Points)
	
}

extension MultiPoint {

	public typealias GeometricSystem = Self.Point.GeometricSystem

}
