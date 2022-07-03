//
//  Point3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public typealias Point3D = Coordinate3D

extension Point3D: GeoModels.Point {
	
	public typealias CoordinateSystem = GeoModels.Geo3D
	
	public var coordinates: Self.Coordinates { self }
	
	public init(_ coordinates: Self.Coordinates) {
		self.init(x: coordinates.x, y: coordinates.y, z: coordinates.z)
	}
	
}

extension Point3D: CustomDebugStringConvertible {
	
	public var debugDescription: String { "\(String(reflecting: self.lowerDimension)) \(self.altitude)m" }
	
}
