//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

@dynamicMemberLookup
public protocol Point: Hashable, Zeroable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
		where Self.CoordinateSystem.Point == Self
	typealias Coordinates = Self.CoordinateSystem.Coordinates
	
	var coordinates: Self.Coordinates { get }
	
	init(_ coordinates: Self.Coordinates)
	
	subscript<T>(dynamicMember keyPath: KeyPath<Self.Coordinates, T>) -> T { get }
	
}

extension Point {
	
	public subscript<T>(dynamicMember keyPath: KeyPath<Self.Coordinates, T>) -> T {
		self.coordinates[keyPath: keyPath]
	}
	
}
