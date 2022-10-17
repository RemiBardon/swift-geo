//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

public protocol BoundingBox<Point>: Hashable, Zeroable {
	
	associatedtype Point: GeodeticGeometry.Point
	associatedtype Size: GeodeticGeometry.Size<Point.Coordinates.CRS>
	
	var origin: Point { get }
	var size: Size { get }
	
	init(origin: Point, size: Size)
	
	func union(_ other: Self) -> Self
	
}

extension BoundingBox {
	
	public static var zero: Self {
		Self.init(origin: .zero, size: .zero)
	}
	
}
