//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

@dynamicMemberLookup
public protocol Point: Hashable, Zeroable, AdditiveArithmetic {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
		where Self.CoordinateSystem.Point == Self
	typealias Coordinates = Self.CoordinateSystem.Coordinates
	
	var coordinates: Self.Coordinates { get }
	
	init(_ coordinates: Self.Coordinates)
	init<N: BinaryFloatingPoint>(repeating number: N)
	
	subscript<T>(dynamicMember keyPath: KeyPath<Self.Coordinates, T>) -> T { get }
	
	static func / (lhs: Self, rhs: Self) -> Self
	static func / <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self
	
}

extension Point {
	
	public subscript<T>(dynamicMember keyPath: KeyPath<Self.Coordinates, T>) -> T {
		self.coordinates[keyPath: keyPath]
	}
	
	public static func / <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		return lhs / Self.init(repeating: rhs)
	}
	
}
