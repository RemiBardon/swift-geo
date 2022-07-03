//
//  Size2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public struct Size2D: RawRepresentable {
	
	public typealias RawValue = GeoCoordinates.Coordinate2D
	
	public let rawValue: Self.RawValue
	
	public var width: Self.RawValue.X { self.rawValue.x }
	public var height: Self.RawValue.Y { self.rawValue.y }
	
	public init(rawValue: Self.RawValue) {
		self.rawValue = rawValue
	}
	
	public init(width: Self.RawValue.X, height: Self.RawValue.Y) {
		self.init(rawValue: Self.RawValue.init(x: width, y: height))
	}
	
}

extension Size2D: Zeroable {
	
	public static var zero: Self { Self.init(rawValue: .zero) }
	
}

extension Size2D: GeoModels.Size {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
//	public var coordinates: Self.Coordinates { self.rawValue }
//
//	public init(_ coordinates: Self.Coordinates) {
//		self.init(rawValue: coordinates)
//	}
	
}
