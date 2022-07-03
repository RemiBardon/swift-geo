//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public protocol BoundingBox: Hashable, Zeroable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
	typealias Coordinates = Self.CoordinateSystem.Coordinates
	typealias Point = Self.CoordinateSystem.Point
	typealias Size = Self.CoordinateSystem.Size
	
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
