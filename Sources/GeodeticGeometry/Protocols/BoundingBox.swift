//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public protocol BoundingBox<Point>: Hashable, Zeroable {
	
	associatedtype Point: GeodeticGeometry.Point
	associatedtype Size: GeodeticGeometry.Size<Point.GeometricSystem>
	
	var origin: Point { get }
	var size: Size { get }
	
	init(origin: Point, size: Size)
	init(min: Point, max: Point)
	
	func union(_ other: Self) -> Self
	
}

public extension BoundingBox {
	
	static var zero: Self {
		Self.init(origin: .zero, size: .zero)
	}

	init(min: Point, max: Point) {
		self.init(origin: min, size: Size.init(from: min, to: max))
	}
	
}
