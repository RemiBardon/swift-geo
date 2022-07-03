//
//  Size3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public struct Size3D: RawRepresentable {
	
	public typealias RawValue = GeoCoordinates.Coordinate3D
	
	public let rawValue: Self.RawValue
	
	public var width: Self.RawValue.X { self.rawValue.x }
	public var height: Self.RawValue.Y { self.rawValue.y }
	public var zHeight: Self.RawValue.Z { self.rawValue.z }
	
	public init(rawValue: Self.RawValue) {
		self.rawValue = rawValue
	}
	
	public init(width: Self.RawValue.X, height: Self.RawValue.Y, zHeight: Self.RawValue.Z) {
		self.init(rawValue: Self.RawValue.init(x: width, y: height, z: zHeight))
	}
	
}

extension Size3D: Zeroable {
	
	public static var zero: Self { Self.init(rawValue: .zero) }
	
}

extension Size3D: GeoModels.Size {
	
	public typealias CoordinateSystem = GeoModels.Geo3D
	
//	public var coordinates: Self.Coordinates { self.rawValue }
//
//	public init(_ coordinates: Self.Coordinates) {
//		self.init(rawValue: coordinates)
//	}
	
}

extension Size3D: GeoCoordinates.CompoundDimension {
	
	public typealias LowerDimension = GeoModels.Size2D
	
	public var lowerDimension: Self.LowerDimension {
		GeoModels.Size2D(rawValue: self.rawValue.lowerDimension)
	}
	
	public init(_ twoDimensions: GeoModels.Size2D, zHeight: Self.RawValue.Z) {
		self.init(rawValue: Self.RawValue.init(
			x: twoDimensions.width,
			y: twoDimensions.height,
			z: zHeight
		))
	}
	
}
