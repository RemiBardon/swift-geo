//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol BoundingBox: Hashable {
	
	associatedtype Point: GeoModels.Point
	
	static var zero: Self { get }
	
	var origin: Point { get }
	
	init(origin: Point.Components, size: Point.Components)
	
	func union(_ other: Self) -> Self
	
}
